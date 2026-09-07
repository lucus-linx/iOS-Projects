# Lucus-Finder

> macOS Finder 右键「服务」扩展 × 常驻菜单栏后台工具 —— 把打开终端/编辑器、复制、校验和、分享等动作，变成右键即点的操作。
> 本文档完整说明：**采用方案（为什么这么设计）** 与 **功能清单（每一项做什么、怎么用）**。

---

## 目录

- [一、一句话概览](#一一句话概览)
- [二、方案详解（Solution）](#二方案详解solution)
  - [2.1 需求与约束](#21-需求与约束)
  - [2.2 技术路线对比与选型](#22-技术路线对比与选型)
  - [2.3 总体架构](#23-总体架构)
  - [2.4 关键技术决策明细](#24-关键技术决策明细)
- [三、功能详解（Features）](#三功能详解features)
  - [3.1 功能总览](#31-功能总览)
  - [3.2 打开类](#32-打开类)
  - [3.3 复制类](#33-复制类)
  - [3.4 信息类](#34-信息类)
  - [3.5 分享类](#35-分享类)
  - [3.6 设置与界面](#36-设置与界面)
- [四、工程指南（Engineering）](#四工程指南engineering)
  - [4.1 目录结构](#41-目录结构)
  - [4.2 如何扩展：加一个动作](#42-如何扩展加一个动作)
  - [4.3 如何扩展：加终端 / 编辑器 / 复制格式](#43-如何扩展加终端--编辑器--复制格式)
  - [4.4 构建 / 注册 / 测试](#44-构建--注册--测试)
  - [4.5 手动验收清单](#45-手动验收清单)
  - [4.6 排查 FAQ](#46-排查-faq)
  - [4.7 已知限制与路线图](#47-已知限制与路线图)

---

## 一、一句话概览

Lucus-Finder 基于 **NSServices（系统服务菜单）**，在 Finder 右键菜单里提供 11 个动作；App 本体是 **后台（accessory）菜单栏工具**，提供设置与使用说明。全程**沙盒 + 硬签名**，不申请"完全磁盘访问"这类敏感授权，可干净分发。

---

## 二、方案详解（Solution）

### 2.1 需求与约束

| 需求 | 说明 |
|---|---|
| 全局生效 | 任意位置的文件夹/文件都能右键操作（包括挂载卷、iCloud 等） |
| 官方、稳定、免维护 | 不需要用户去"扩展管理"手动开启，不依赖私有 API |
| 沙盒友好 | 尽量不要求敏感授权；本工程 `ENABLE_APP_SANDBOX = YES` + 硬签名 |
| 后台常驻 | 触发服务时不弹主窗口；有入口做设置 |
| 可扩展 | 加一个新动作低成本、不易出错 |

### 2.2 技术路线对比与选型

早期版本已论证并采用 NSServices，本版延续。三条路线对比：

| 维度 | ✅ NSServices（采用） | Finder Sync 扩展 | Finder 插件 / SIMBL（如 XtraFinder、TotalFinder） |
|---|---|---|---|
| 生效范围 | 全局任意路径 | 仅被监控目录，`/Volumes` 挂载卷覆盖不到 | 全局，但侵入 Finder 进程 |
| 启用 | 自动；必要时去「键盘→服务」勾选 | macOS 15 起系统设置入口失效，需 `pluginkit` 命令 | 需注入 Finder，脆弱 |
| 目录冲突 | 无 | 与 iCloud 等云盘扩展独占冲突 | 无 |
| 是否官方 | 是（AppKit 官方机制） | 官方但定位是"云盘同步类 App" | 否 |
| 能做到 | 选中文件/文件夹右键动作 | 同上（但限定目录） | 顶级子菜单、空白处右键、新建文件等 |
| 代价 | 菜单项编译期固定，无法运行时增删 | 启用麻烦 + 范围受限 | 需关沙盒/磁盘访问授权，维护成本高 |

> 结论：对"任意路径的开发动作包"这一目标，NSServices 是最优解；代价（菜单项固定）用「行为门控 + 引导系统服务面板」来消化（见 2.4-②）。

同类现网 App 参考：`超级右键`、`闪电右键 QuickRight`、`iMenuX`、`RightClick Pro`（多为 Finder Sync / 插件路线，主打新建文件、图片转换等系统级能力）；`OpenInTerminal`（开发向，与本品定位最接近）。本品刻意保持**轻量、沙盒友好**，不做需磁盘访问授权的功能。

### 2.3 总体架构

```
Finder 右键 →「服务」菜单（静态 11 项）
                    │  系统把所选路径以粘贴板形式派发给 Lucus-Finder
                    ▼
            ServicesProvider（11 个 @objc 动作）
                    │  每个动作先查 ActionConfig.isEnabled（行为门控）
                    │  再转发到对应功能模块；读取权限 = 服务回调内隐式授权
                    ▼
   ┌────────────┬─────────────────────────────┬───────────────┐
   │ AppRegistry│ Terminal/Editor/Finder      │ ClipboardKit  │
   │ 已装App探测│ 各启动器 / Sharer / 哈希     │ PathFormatting│
   └────────────┴─────────────────────────────┴───────────────┘
                    ▲
   菜单栏 App（.accessory 后台）
      MenuBarExtra ──► AppWindows ──► 设置窗口(SettingsView)
                          │             说明窗口(ContentView)
                          └─ .regular/.accessory 策略切换
```

### 2.4 关键技术决策明细

#### ① 菜单命名与聚簇 —— 分类 token 首段，去掉品牌前缀
NSServices 的动作总数 > 约 5 个时，Finder 会收进右键二级「服务」子菜单；Finder **按名称排序，无分组、无分隔线**，且阈值（默认 ~5，跨所有 App 统计）无官方文档、属非契约行为。
→ 于是每条命名用 `分类：xxx`（如 `工具：复制路径`、`终端：在此处打开`），借首段同前缀天然排序聚簇。13 个「Lucus：」前缀会被系统服务列表和文本菜单重复展示，是噪音，故去掉。

#### ② 设置 = 行为门控，而非"运行时真隐藏"
NSServices 菜单项**编译期写在 Info.plist**，没有任何运行时 API 能增删单项（`NSUpdateDynamicServices()` 只触发重扫，不改变 plist 内容）。
→ 因此设置里的动作开关做**行为门控**：关闭后该项仍在 Finder 菜单里，点击不执行。**真正从菜单移除**由用户到「系统设置 → 键盘 → 键盘快捷键 → 服务」取消勾选（OS 原生支持单项显隐），设置页提供「打开系统服务面板」一键跳转兜底。这样保持沙盒不开洞。
> 想"动态装卸菜单项"的技术方案是 `.service` 附加包（把每动作做成独立 bundle 放 `~/Library/Services`），但需要写主域 Library、涉及沙盒/签名，当前刻意不做（见 §4.7）。

#### ③ 后台化：用运行时 `.accessory`，不写 `LSUIElement`
在 `applicationWillFinishLaunching` 里 `NSApp.setActivationPolicy(.accessory)`（效果等价 `LSUIElement`，但与"展示窗口时切 `.regular`"的策略码写在一处更内聚）。要点：
- 常驻**菜单栏图标**（MenuBarExtra），无 Dock 图标；
- 被 Finder 服务冷启动时**不弹任何窗口**；
- 要打开设置/说明窗时，固定顺序：`setActivationPolicy(.regular)` → `activate(ignoringOtherApps:)` → 展示窗口；`.accessory` 下仅 `activate()` 往往不足以把窗口带到前台；
- `NSWindow.willCloseNotification` 观察器在"没有可见主窗口"时自动切回 `.accessory`；
- SwiftUI 场景只留 `MenuBarExtra`；设置/说明窗口由 `HostedWindow`（AppKit 托管 SwiftUI 的 NSWindow）承载，绕开 accessory 无主菜单导致 `showSettingsWindow:` 不可达的问题。

#### ④ 沙盒读取边界 —— "当场做完，不存路径"
服务回调 = "用户当场选中这些文件"，系统把所选路径的**读取**权限授予本 App（stat / 读内容 / 算哈希 / 分享都允许）。
→ 限制：不能写回源文件旁；读取授权不跨调用持久。因此**哈希、分享都在回调内当场完成**，绝不把路径存下来稍后再读。`urlForApplication` 走 XPC 查 LaunchServices，也属沙盒允许。

#### ⑤ 服务冷启动时序 —— 注册要"最先 + 同步"
pbs（服务菜单守护进程）先把 App 启动到完成 launch，服务消息在 `applicationDidFinishLaunching` 返回、主 run loop 起跑后才会送达 provider。
→ 只要在 didFinishLaunching **同步**赋 `NSApp.servicesProvider` 就严格先于任何回调，无竞态；切勿推迟到异步任务里再注册。DEBUG 构建才调 `NSUpdateDynamicServices()`（开发期改 plist 后强制刷新）。

#### ⑥ 在目录打开终端 —— 按 App 分派，无统一契约
"用 App 在目录开新会话"没有统一 API，不同终端各自机制。分派表（机制已实现）：

| 目标 | Bundle ID | 机制 | 授权 | 实测 |
|---|---|---|---|---|
| Terminal | `com.apple.Terminal` | `NSWorkspace.open(dir, withApplicationAt:)`（LS odoc） | 无 | ✅ 已实测 |
| Warp | `dev.warp.Warp-Stable` | URL scheme `warp://action/new_window?path=` | 无 | 待实测 |
| Ghostty | `com.mitchellh.ghostty` | CLI `+new-window --working-directory=` | 无 | 待实测 |
| iTerm2 | `com.googlecode.iterm2` | `/usr/bin/osascript`（`create window` + `write text "cd '…'"`） | 首次弹"控制 iTerm2" | 待实测 |

> 表中"待实测"项请在你机器上各触发一次并把结果写回来；这是各 App 版本相关行为，不承诺跨版本契约。终端集合 = `AppRegistry.terminals`，菜单只暴露 1 个「终端：在此处打开」，用设置里的"默认终端"决定落到哪款。

#### ⑦ 编辑器打开 & Xcode 特判
VSCode / Cursor / Sublime / CotEditor 都处理 `odoc`（文件夹=工作区、文件=开标签），直接 `NSWorkspace.open(url, withApplicationAt:)`。Xcode 特判：
- 文件 / `.xcodeproj` / `.xcworkspace` / `.playground` → `/usr/bin/xed` 打开；
- 纯目录 → 扫目录内首个工程文件，扫不到就交给 Xcode 打开文件夹。

#### ⑧ 「显示简介」：osascript + `as alias` + 降级
实测正确语句必须是 **`open information window of (POSIX file "…" as alias)`**（缺 `as alias` 会报 -1728）。经 `/usr/bin/osascript` 子进程执行（异步 + 完成回调）。被 TCC 自动化授权拒绝（首次弹「允许 Lucus-Finder 控制 Finder」，之后在 系统设置→隐私与安全性→自动化 里管理）时，降级为 `NSWorkspace.activateFileViewerSelecting`（Finder 里选中高亮，零授权成本）。沙盒不拦 osascript 子进程，拦的是 TCC 授权这一层。

#### ⑨ Info.plist 合并 & 免改 pbxproj & 方法名同源
- 工程 `GENERATE_INFOPLIST_FILE = YES` + 自定义 `Lucus-Finder/Info.plist`（只放 `NSServices`）合并，产物只含 `Contents/Info.plist`；
- 源码用 Xcode 文件系统同步组：新增 `.swift` 放进 `Lucus-Finder/` 目录**自动进 target，pbxproj 零改动**（`Info.plist` 已用 membershipExceptions 排除，避免被当资源重复拷贝）；
- 每条 `NSMessage` 必须与 `ServicesProvider` 的 `@objc` 方法名一字不差，否则"菜单能看、点击没反应、不报错"。DEBUG 启动 `verifyPlistMessagesMatch()` 用 `responds(to:)` 逐一校验。

#### ⑩ 并发模型
`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`（Xcode 26 默认）。服务回调、AppKit/NSWorkspace 回调本就在主线程，`ServicesProvider` 等直接吃默认即可；不要把服务方法标成非隔离。纯字符串/URL 格式化（`PathFormatting`）显式 `nonisolated`，便于脱离主线程与单测。

---

## 三、功能详解（Features）

### 3.1 功能总览

| 菜单名（按分类聚簇） | 类型 | 一句话 | 生效对象 |
|---|---|---|---|
| 终端：在此处打开 | 打开 | 用默认终端在目标目录开新会话 | 文件夹=自身；文件=父目录 |
| 编辑器：在此处打开 | 打开 | 用默认编辑器打开 | 目录=工作区；文件=开标签 |
| 工程：用 Xcode 打开 | 打开 | 工程/文件进 Xcode | 见 3.2 |
| 工具：复制路径 | 复制 | 复制 POSIX 绝对路径 | 首项 |
| 工具：复制文件名 | 复制 | 复制文件名（含扩展名） | 首项 |
| 工具：复制文件名（无后缀） | 复制 | 复制文件名（不含扩展名，点文件原样） | 首项 |
| 工具：复制为 file:// 链接 | 复制 | 复制百分号编码的绝对 URL | 首项 |
| 信息：计算并复制 MD5 | 信息 | 增量算 MD5，结果进剪贴板 | 单个文件 |
| 信息：计算并复制 SHA-256 | 信息 | 增量算 SHA-256，结果进剪贴板 | 单个文件 |
| 信息：显示简介 | 信息 | 打开系统「显示简介」；被拒则 Finder 定位 | 首项 |
| 分享：隔空投送… | 分享 | AirDrop 分享所选文件 | **多选全部分享** |

说明：**生效对象** 中"首项"指多选时只处理第一个（沿用早期行为）；复制/哈希/简介保持单目标，AirDrop 已支持多选。

### 3.2 打开类

**终端：在此处打开**（`openTerminalHere`）
- 触发：右键文件夹 / 文件 → 服务 → 本项。
- 行为：右键文件夹以该文件夹为目录打开；右键文件在其**父目录**打开。
- 用哪款终端：由设置「默认终端」决定（候选 Terminal / iTerm2 / Warp / Ghostty，自动检测已装）。改默认即可换终端，无需改菜单。

**编辑器：在此处打开**（`openInEditor`）
- 触发：右键目录 / 文件。
- 行为：目录作为工作区、文件开标签。
- 用哪款：设置「默认编辑器」（候选 VSCode / Cursor / Sublime / CotEditor；未设置时自动落到第一个已安装项）。

**工程：用 Xcode 打开**（`openInXcode`）
- 触发：右键 `.xcodeproj/.xcworkspace/.playground`、任意代码文件、或工程目录。
- 行为：工程/文件直接进 Xcode（`xed`）；目录先扫首个工程，扫不到则交给 Xcode 打开文件夹。

### 3.3 复制类

统一动作：把结果写入系统剪贴板（会先 `clearContents`）。
- **复制路径**：如 `/Users/me/Desktop/report.md`。
- **复制文件名**：如 `report.md`。
- **复制文件名（无后缀）**：如 `report`。点文件（如 `.gitignore`）原样返回。
- **复制为 file:// 链接**：如 `file:///Users/me/Desktop/report.md`，空格等自动百分号编码，适合拖进浏览器/聊天框当可点链接。

### 3.4 信息类

- **MD5 / SHA-256**：用 CryptoKit 分块增量计算（`Insecure.MD5` / `SHA256`），结果（纯小写十六进制）写剪贴板，便于与 `md5`、`shasum -a 256` 比对。目录不适用（无内容可算）。
- **显示简介**：调用 Finder 打开系统自带的「显示简介」面板，看到大小/权限/日期等系统原生信息；首次会请求"控制 Finder"授权，拒绝后自动降级为在 Finder 中选中并高亮该文件。

### 3.5 分享类

**隔空投送…**（`airDropFile`）：多选文件一次分享；基于 `NSSharingService(.sendViaAirDrop)`。设备/系统不支持 AirDrop 或无读权限时打印提示、不动作。

### 3.6 设置与界面

| 入口 | 说明 |
|---|---|
| 菜单栏图标 | 常驻图标，点击弹出：偏好设置… / 使用说明… / 打开系统服务面板 / 退出 |
| 设置窗口 | 见下表设置项；由菜单栏「偏好设置…」或说明窗右上按钮打开 |
| 使用说明窗口 | 首次启动自动带出一次；可随时从菜单栏再开 |

**设置项详解：**

| 设置 | 作用 | 默认 |
|---|---|---|
| 默认终端 | 决定「终端：在此处打开」落到哪款 | Terminal（`com.apple.Terminal`） |
| 默认编辑器 | 决定「编辑器：在此处打开」落到哪款 | 自动选第一个已安装编辑器 |
| 启用动作 ×11 | **行为门控**：关掉后对应动作点击不执行 | 全开 |
| 打开系统服务面板 | 跳「系统设置→键盘」，进去点「键盘快捷键→服务」可**真正勾选显隐**每项 | — |

> 设置只存 UserDefaults（容器内），沙盒 App 的标准做法；动作开关与门控共用 `ActionConfig` 一个真源。

---

## 四、工程指南（Engineering）

### 4.1 目录结构

| 文件 | 职责 |
|---|---|
| `Lucus_FinderApp.swift` | `@main`：MenuBarExtra 场景 + AppDelegate（注册 provider / `.accessory` 策略 / 首启引导 / 关窗 demote） |
| `AppWindows.swift` | `.accessory/.regular` 切换；`HostedWindow`（AppKit 托管 SwiftUI 的可复用窗口，装设置窗/说明窗） |
| `AppMenuView.swift` | 菜单栏下拉菜单 |
| `SettingsView.swift` | 默认终端/编辑器 Picker + 动作开关 + 跳系统服务面板 |
| `ContentView.swift` | 使用说明窗口内容 |
| `ServicesProvider.swift` | 11 个 `@objc` 动作 + 门控 + 路径解析 + plist/method 自检 |
| `ActionConfig.swift` | `ActionID` 枚举 + UserDefaults 开关（设置与门控唯一真源） |
| `AppRegistry.swift` | 已知 bundle id 探测已装 App（缓存，沙盒安全） |
| `TerminalLauncher.swift` | 按 App 分派在目录打开终端（见 2.4-⑥） |
| `EditorLauncher.swift` | 通用编辑器打开 + Xcode 特判（工程扫描 / `xed`） |
| `ClipboardKit.swift` | 剪贴板写入 |
| `PathFormatting.swift` | 纯字符串/URL 格式化（文件名切分、shell/AppleScript 转义等，可单测） |
| `FileDigest.swift` | CryptoKit MD5 / SHA-256 分块增量计算 |
| `FinderBridge.swift` | osascript 开「显示简介」+ 降级 |
| `Sharer.swift` | AirDrop 分享 |
| `ProcessRunner.swift` | 外部进程运行（fire-and-forget / 异步回调） |
| `SystemPanel.swift` | 打开系统服务面板 |
| `Info.plist` | 仅 `NSServices`（11 项），与 GENERATE_INFOPLIST_FILE 合并 |
| `Lucus-FinderTests/` | Swift Testing 单测（纯函数转义/切分用例） |

### 4.2 如何扩展：加一个动作

三步（其余自动完成）：
1. **`Info.plist`**：`NSServices` 数组复制一个 dict，改菜单名（用 `分类：xxx`）与 `NSMessage`（如 `copyMarkdownLink`）；
2. **`ServicesProvider.swift`**：加同名 `@objc` 方法，首行加 `guard ActionConfig.shared.isEnabled(.xxx) else { return }` 再转发逻辑；
3. **`ActionConfig.swift`**：`ActionID` 补一个 case（含 `displayName` / `groupName` / `systemImage`），它会自动出现在设置页开关清单里。

然后 构建 + 重注册（见 4.4）。DEBUG 启动自检会帮你确认 NSMessage 与方法名一致。

### 4.3 如何扩展：加终端 / 编辑器 / 复制格式

- **加一款终端**：`AppRegistry.terminals` 补 {bundle id, 名称}；`TerminalLauncher.open` 的 switch 里补对应的打开机制（LS / URL scheme / CLI / AppleScript），并更新 2.4-⑥ 实测表。
- **加一款编辑器**：`AppRegistry.editors` 补一项即可（走通用 `NSWorkspace.open`，前提是它处理 `odoc`）。
- **加一种复制格式**：`PathFormatting` 加一个纯函数（`nonisolated`，顺手补单测）+ `ClipboardKit` 复用 + 按 4.2 三步挂一个新动作。

### 4.4 构建 / 注册 / 测试

```bash
# 构建（Debug）
xcodebuild -project Lucus-Finder.xcodeproj -scheme Lucus-Finder \
           -configuration Debug -derivedDataPath /tmp/lucus-dd build

# 校验产物：11 项服务、无 Resources/Info.plist 重复拷贝告警
plutil -p /tmp/lucus-dd/Build/Products/Debug/Lucus-Finder.app/Contents/Info.plist | grep -c NSMessage

# 注册 + 启动（首启自动弹说明窗；常驻菜单栏、无 Dock）
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f <app>
open <app>

# 交叉核对 NSMessage 与 @objc 方法名（应无 diff）
/usr/libexec/PlistBuddy -c "Print :NSServices" Lucus-Finder/Info.plist | grep NSMessage | sed 's/.*= //' | sort
grep -oE '@objc func [a-zA-Z0-9]+' Lucus-Finder/ServicesProvider.swift | awk '{print $3}' | sort

# 单元测试
xcodebuild test -project Lucus-Finder.xcodeproj -scheme Lucus-Finder \
                -destination 'platform=macOS' -only-testing:Lucus-FinderTests \
                -derivedDataPath /tmp/lucus-dd
```

### 4.5 手动验收清单

在 Finder 里逐项打勾（自动化只能覆盖到构建/自检/单测，右键级联需人肉过一遍）：

- [ ] 右键**文件夹** → 终端在自身目录打开；改"默认终端"后再触发，落在新选的终端（Terminal 已实测；iTerm2/Warp/Ghostty 触发后回填 §2.4-⑥）
- [ ] 右键**单个文件** → 终端在其**父目录**打开
- [ ] 右键目录 → 编辑器作为工作区打开；右键文件 → 开标签
- [ ] 右键 `.xcodeproj`/工程目录 → 进 Xcode
- [ ] 复制 路径 / 文件名 / 无后缀 / file:// 四种各粘贴一次检查
- [ ] MD5 / SHA-256 与终端 `md5`、`shasum -a 256` 比对一致
- [ ] 显示简介：首次允许授权 → 弹出系统简介；到系统设置**撤销**授权再点 → 降级为 Finder 定位
- [ ] 多选文件 → 隔空投送弹出、能分享
- [ ] 关闭所有窗口 → 从 Finder 触发任一服务，App 冷启动且**不弹窗**
- [ ] 设置里关掉「计算 MD5」→ 右键该项点击无副作用；「打开系统服务面板」可跳转并真取消勾选
- [ ] 删除 `~/Library/Containers/com.linx.Lucus-Finder` 后重启 App → 首次启动说明窗再出现一次

### 4.6 排查 FAQ

| 现象 | 处理 |
|---|---|
| 右键看不到本 App 的服务 | 系统设置→键盘→键盘快捷键→服务 勾选对应项；`lsregister -f <app>` 重注册；必要时 `killall Finder`；装过旧版先清掉旧 .app |
| 菜单能看到、点下去没反应 | 99% 是 `NSMessage` 与 `@objc` 方法名不一致 → 改 plist 后重新构建 + 重注册；看 DEBUG 启动日志的自检输出 |
| 点「显示简介」没反应 | 到 系统设置→隐私与安全性→自动化 允许 Lucus-Finder 控制 Finder；被拒时已自动降级为 Finder 定位 |
| 改了 plist 但菜单不更新 | 重新构建 → `lsregister -f` → 必要时 `killall Finder`；`NSUpdateDynamicServices()` 只在 DEBUG 生效 |
| 右键**空白处**没有菜单 | 正常：服务绑定在**选中的文件/文件夹**上，空白处无选中项 |
| 菜单项太多/不想要某几个 | 打开系统服务面板取消勾选（真移除）；或设置里关掉对应开关（仅停用行为） |

### 4.7 已知限制与路线图

- **无法运行时真隐藏动作**：NSServices 静态菜单是机制内上限；当前用 行为门控 + 系统面板。要动态装卸需 `.service` 附加包（写 `~/Library/Services`，需评估关沙盒/签名）。
- **读操作为主线程同步**：超大文件算哈希会短暂卡 UI；后续可挪后台线程（沙盒读授权进程内有效，后台线程可读）。
- **终端/编辑器候选固定**：暂不支持"在设置里选任意 .app"（需 NSOpenPanel + security-scoped bookmark 记忆）。
- **多选**：多数动作只处理首个；仅 AirDrop 全量。可扩展"复制全部路径/批量哈希"。
- **「打开」类在多款未装的终端/编辑器**：菜单已精简为默认驱动单入口，避免空菜单项。
- **待实测回填**：iTerm2 / Warp / Ghostty 及 VSCode / Cursor / Sublime / CotEditor 的实际打开结果（见 §2.4-⑥⑦ 与 3.2），按你机器实测后更新。

---

*实现对应：`Info.plist`（NSServices×11）、`ServicesProvider.swift`（动作集+门控）、`Lucus_FinderApp.swift`（后台化）与新增 14 个功能/UI 模块，见 §4.1。测试：`Lucus-FinderTests/`。*
