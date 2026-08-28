# Lucus-Finder 开发说明：Finder 右键自定义操作（服务菜单）

> 目标：在 Finder 中右键任意文件/文件夹，能出现自定义操作，例如「在此处打开终端」。
> 本文记录完整的实现思路、技术细节、验证方法与扩展方式。

---

## 1. 方案选型

在 macOS 上给 Finder 右键菜单添加自定义项，主要有两条路：

### ✅ 采用：NSServices（系统服务菜单）

- 在 `Info.plist` 的 `NSServices` 中声明服务项；
- 服务项出现在 Finder 右键菜单的「服务」子菜单（动作总数少于 5 个时直接显示在主菜单）；
- 用户选择后，系统把所选文件/文件夹的**路径以粘贴板形式**传给 App；
- 优点：官方支持、无需用户手动启用扩展、**文件与文件夹都支持**、添加新动作只改 plist + 加一个方法。

### ❌ 放弃：Finder Sync 扩展（`FIFinderSyncController`）

| 问题 | 说明 |
|---|---|
| 作用域受限 | 右键菜单只出现在**被监控的目录**内，无法全局生效 |
| 不跨文件系统 | `/` 作为根也覆盖不到 `/Volumes` 挂载卷 |
| 独占目录 | 与 iCloud Drive 等扩展冲突，iCloud 目录内不可用 |
| 启用麻烦 | macOS 15.0 的扩展管理界面一度失效，需命令行 `pluginkit` 处理 |
| 定位不符 | Apple 明确说明它是为「云盘同步类 App」设计的，不是全局右键菜单工具 |

**结论**：对于「在任意路径打开终端」这类全局动作，NSServices 是最佳方案。

---

## 2. 技术原理

### 2.1 NSServices 的工作机制

```
Finder 右键选择文件/文件夹
      │  选中「Lucus：在此处打开终端」
      ▼
LaunchServices 找到提供该服务的 App（com.linx.Lucus-Finder）
      │  若 App 未运行则先启动它
      ▼
系统把所选路径写入 NSPasteboard，调用 servicesProvider 上的方法
      │  selector 名 = Info.plist 里的 NSMessage
      ▼
App 从粘贴板读出路径 → 执行自定义动作（打开终端 / 复制路径）
```

三个关键要素缺一不可：

1. **Info.plist 声明**（`NSServices`）：告诉系统「我有这些服务、接受什么类型」；
2. **运行时注册**（`NSApp.servicesProvider = ...`）：把实现了服务方法的对象交给系统；
3. **方法签名**：`@objc` 方法，且方法名与 `NSMessage` 严格一致。

### 2.2 服务方法签名（必须精确匹配）

```swift
@objc func openTerminalHere(_ pboard: NSPasteboard,
                            userData: String,
                            error: AutoreleasingUnsafeMutablePointer<NSString?>)
```

- `pboard`：传入所选路径的粘贴板；
- 方法名 `openTerminalHere` 与 plist 中 `NSMessage` 的字符串一致。

### 2.3 文件如何传入

`NSSendFileTypes` 声明了服务接受 `public.item`（根 UTI，同时匹配文件与文件夹）。Finder 传参时，粘贴板的 `public.file-url` 类型里是一组 **POSIX 路径字符串**：

```swift
let paths = pboard.propertyList(forType: .fileURL) as? [String]
// 例如：["/Users/qiyeyun/Desktop/foo"]
```

兼容旧粘贴板类型 `NSFilenamesPboardType`（`"NSFilenamesPboardType"`）作为兜底。

---

## 3. 代码实现

### 3.1 文件清单

| 文件 | 类型 | 职责 |
|---|---|---|
| `Lucus-Finder/Info.plist` | 新增 | 声明两个 NSServices |
| `Lucus-Finder/ServicesProvider.swift` | 新增 | 服务提供者：实现两个 `@objc` 动作方法 |
| `Lucus-Finder/Lucus_FinderApp.swift` | 修改 | 加 `AppDelegate`，注册 servicesProvider |
| `Lucus-Finder/ContentView.swift` | 修改 | 主界面使用说明 |
| `Lucus-Finder.xcodeproj/project.pbxproj` | 修改 | 加 `INFOPLIST_FILE`；排除 Info.plist 重复拷贝 |

### 3.2 `Info.plist`（NSServices 声明）

```xml
<key>NSServices</key>
<array>
    <dict>
        <key>NSMenuItem</key>
        <dict>
            <key>default</key>
            <string>Lucus：在此处打开终端</string>
        </dict>
        <key>NSMessage</key>
        <string>openTerminalHere</string>
        <key>NSSendFileTypes</key>
        <array>
            <string>public.item</string>
        </array>
        <key>NSRequiredContext</key>
        <dict/>
    </dict>
    <dict>  <!-- 复制路径：同理，NSMessage = copyPath -->
        ...
    </dict>
</array>
```

要点：
- `NSMessage` **必须**与 `ServicesProvider` 里的 `@objc` 方法名一字不差；
- `NSSendFileTypes` 只接受 **UTI**（`public.folder` 仅文件夹 / `public.item` 全部）；
- `NSRequiredContext` 留空 dict，表示任何上下文都可用。

### 3.3 `ServicesProvider.swift`

```swift
import AppKit

final class ServicesProvider: NSObject {

    /// 右键文件夹 → 在该目录打开终端；右键文件 → 在其父目录打开终端。
    @objc func openTerminalHere(_ pboard: NSPasteboard,
                                userData: String,
                                error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard let firstPath = paths(from: pboard).first else { return }
        let directory = directoryURL(for: URL(fileURLWithPath: firstPath))
        openTerminal(at: directory)
    }

    @objc func copyPath(_ pboard: NSPasteboard,
                        userData: String,
                        error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard let firstPath = paths(from: pboard).first else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(firstPath, forType: .string)
    }

    private func paths(from pboard: NSPasteboard) -> [String] {
        if let paths = pboard.propertyList(forType: .fileURL) as? [String] {
            return paths
        }
        let legacy = NSPasteboard.PasteboardType("NSFilenamesPboardType")
        if let paths = pboard.propertyList(forType: legacy) as? [String] {
            return paths
        }
        return []
    }

    /// 文件 → 取父目录；文件夹 → 用自身。
    private func directoryURL(for url: URL) -> URL {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return isDirectory.boolValue ? url : url.deletingLastPathComponent()
    }

    private func openTerminal(at url: URL) {
        let terminalApp = URL(fileURLWithPath: "/System/Applications/Utilities/Terminal.app")
        let config = NSWorkspace.OpenConfiguration()
        config.activates = true
        NSWorkspace.shared.open([url], withApplicationAt: terminalApp,
                                configuration: config) { _, error in
            if let error { print("打开终端失败：\(error)") }
        }
    }
}
```

### 3.4 `Lucus_FinderApp.swift`（注册服务提供者）

```swift
@main
struct Lucus_FinderApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.servicesProvider = ServicesProvider()
        NSUpdateDynamicServices()   // 开发期 Info.plist 变更后强制刷新服务缓存
    }
}
```

> 不注册 `servicesProvider`，菜单能显示但点了没反应——服务动作由它回调。

---

## 4. 工程配置要点（踩坑记录）

### 4.1 自定义 Info.plist 与自动生成合并

工程默认 `GENERATE_INFOPLIST_FILE = YES`（自动生成 Info.plist）。`NSServices` 没有对应的 `INFOPLIST_KEY_*` 构建设置，必须放进自定义 plist 文件。

两者**可以共存合并**：在 pbxproj 的 App target **Debug / Release 两个配置**里都加上：

```
GENERATE_INFOPLIST_FILE = YES;      // 保留，负责生成 CFBundle* 等常规键
INFOPLIST_FILE = "Lucus-Finder/Info.plist";   // 新增，只放 NSServices
```

最终构建产物是两者合并的结果，`NSServices` 会进入 `Contents/Info.plist`。

### 4.2 文件系统同步组会重复拷贝 Info.plist

工程用 Xcode 16+ 的**文件系统同步组**（`PBXFileSystemSynchronizedRootGroup`）管理源码：
- 好处：`.swift` 文件放进 `Lucus-Finder/` 目录**自动进 target**，无需手工改 pbxproj 的 Sources 列表；
- 坑：`Info.plist` 放在该目录里会被当作资源拷进 `Contents/Resources/Info.plist`，构建报警告。

**修复**：给同步组加 `PBXFileSystemSynchronizedBuildFileExceptionSet` 排除它：

```
99E1E5D4304124D90032875E /* Lucus-Finder */ = {
    isa = PBXFileSystemSynchronizedRootGroup;
    exceptions = (
        99E1E5FF304124DD00328760 /* Exceptions ... */,
    );
    path = "Lucus-Finder";
    sourceTree = "<group>";
};
// 对应异常集对象：
{
    isa = PBXFileSystemSynchronizedBuildFileExceptionSet;
    membershipExceptions = ( Info.plist, );
    target = 99E1E5D1304124D90032875E /* Lucus-Finder */;
}
```

### 4.3 沙盒与签名

- 工程已开 `ENABLE_APP_SANDBOX = YES`：服务经粘贴板传路径、用 `NSWorkspace` 打开 Terminal 都属于沙盒允许的操作，**无需改沙盒配置**；
- 自动签名（`DEVELOPMENT_TEAM = FL2VP3W5B3`）+ 硬性运行时（`ENABLE_HARDENED_RUNTIME = YES`），直接构建即可。

### 4.4 Swift 并发默认值

工程设置了 `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`（Xcode 26 新默认）。服务回调本来就发生在主线程，`ServicesProvider` 继承该默认即可，无需额外标注。

---

## 5. 验证方法

### 5.1 命令行构建

```bash
xcodebuild -project Lucus-Finder.xcodeproj -scheme Lucus-Finder \
           -configuration Debug -derivedDataPath /tmp/lucus-dd build
```

重点检查：构建成功；**无** `Copy Bundle Resources ... Info.plist` 警告；产物只应有 `Contents/Info.plist`、不应有 `Contents/Resources/Info.plist`。

校验产物里的服务声明：

```bash
plutil -p /tmp/lucus-dd/Build/Products/Debug/Lucus-Finder.app/Contents/Info.plist \
  | grep -A6 NSServices
```

### 5.2 注册服务

首次构建后 App 必须被 LaunchServices 识别，服务项才会出现在菜单里：

```bash
# 启动 App 一次（注册 NSServices 并设置运行时 servicesProvider）
open /path/to/Lucus-Finder.app

# 若此前装过旧版本，强制重注册：
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f /path/to/Lucus-Finder.app

# 菜单未刷新时重启 Finder：
killall Finder
```

### 5.3 功能测试

1. Finder 右键**文件夹** → 服务 → 「Lucus：在此处打开终端」→ Terminal 以该目录开新窗口；
2. 右键单个**文件** → 同上 → 终端在它的**父目录**打开；
3. 右键任意项 → 「Lucus：复制路径」→ 粘贴得到完整 POSIX 路径。

### 5.4 菜单不显示时排查

- **系统设置 → 键盘 → 键盘快捷键 → 服务**：勾选对应项（新服务默认启用，但可在此确认）；
- 服务项可能藏在「服务」子菜单里，动作少于 5 个才会直接上主菜单；
- Info.plist 改动后务必重新构建 + 重注册，必要时 `killall Finder`；
- 右键**空白处**不会出现——服务绑定在选中的文件/文件夹上。

---

## 6. 如何扩展新动作（例：用 VSCode 打开）

两步即可新增一个右键动作：

1. **Info.plist**：在 `NSServices` 数组里复制一个 dict，改菜单名与 `NSMessage`（如 `openInVSCode`）；
2. **ServicesProvider.swift**：加一个同名的 `@objc` 方法，从粘贴板取路径后执行：

```swift
@objc func openInVSCode(_ pboard: NSPasteboard,
                        userData: String,
                        error: AutoreleasingUnsafeMutablePointer<NSString?>) {
    guard let url = ... else { return }
    let app = URL(fileURLWithPath: "/Applications/Visual Studio Code.app")
    NSWorkspace.shared.open([url], withApplicationAt: app,
                            configuration: NSWorkspace.OpenConfiguration())
}
```

## 7. 已知局限与后续方向

- **主窗口会弹出**：服务调用时若 App 未运行，会启动并弹出主窗口。可改为 `LSUIElement`（菜单栏工具）抑制窗口；
- **Terminal 路径写死**：目前指向系统 Terminal，可扩展支持 iTerm / 用户自定义；
- **多选只取第一个**：当前只处理第一个路径，可按需遍历全部。

---

*文档对应实现：git status 中 `Info.plist`、`ServicesProvider.swift` 为新增，`Lucus_FinderApp.swift`、`ContentView.swift`、`project.pbxproj` 为修改。*
