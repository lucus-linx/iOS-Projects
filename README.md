# iOS-Projects

iOS 学习 / 练习项目集合仓库，按**知识主题**归类整理。

> 整理说明：本仓库由多个独立仓库合并而来（LXRunTimeAll、TodayNews、RongCloud_Demo、SwiftProject、LXLogViewPods、SomeEasyDemos 等），经 `git mv` 归类移动，历史均已保留。

## 目录结构

| 目录 | 主题 | 内容 |
|---|---|---|
| `00_文档笔记/` | 文档 | 代码规范、思维导图、文档笔记、归档 LICENSE |
| `01_OC基础/` | OC 语言 | 数据类型、Block、load/initialize、协议、拷贝 |
| `02_OC底层原理/` | 底层 | runtime、消息机制、事件响应链、Category、防崩溃 |
| `03_架构与编程思想/` | 架构 | 链式编程、RAC、MVVM、设计模式、数据结构 |
| `04_UI与系统框架/` | UI | HUD、文件目录、frame/bounds、本地通知、表单 |
| `05_第三方SDK与网络/` | SDK | 融云、FastDFS、RabbitMQ、Socket、极光推送 |
| `06_可复用组件Pod/` | 组件 | 启动引导、二维码、日志视图、版本检测 |
| `07_媒体与工具/` | 媒体 | 音视频播放、音频、AR、扫码、文件/邮件 |
| `08_Swift/` | Swift | Swift 项目集合 |
| `09_完整App/` | App | 完整可运行项目 |

## 项目索引

### 00_文档笔记
- `代码规范` — 编码规范文档
- `iOS文件目录.xmind` / `基本数据类型.xmind` / `Runtime头文件.xmind` — 知识导图
- `OC最实用的runtime总结.docx` — runtime 笔记
- `_归档/LICENSE_SomeEasyDemos.txt` — 原 SomeEasyDemos 仓库 MIT License

### 01_OC基础
- `LXInt_NSInt_Test` — OC 基本数据类型问题测试
- `load_initialize_init_demo` — load / initialize / init 方法区别（含 3 个子工程）
- `LXBlock_Demo` — Block 用法
- `Objective-C多继承` — OC 中模拟多继承
- `Protocol_Demo` — 协议
- `Copy&mutableCopy` — 深拷贝 / 浅拷贝

### 02_OC底层原理
- `LXRunTimeAll` — runtime 各类问题探究（含 9 个子项目）
- `Responder_Chain_Demo` — 触摸事件分发与响应链
- `Category深入` — Category 底层探究
- `AvoidCrash` — 基于 runtime 的防崩溃方案
- `Analyze_YYModel` — YYModel 源码分析

### 03_架构与编程思想
- `LXProgrammeThought` — 链式编程思想
- `LXReactiveCocoa_Demo` — RAC 探究（映射 / 组合 / 过滤 / 登录逻辑 / MVVM 等 6 个子项目）
- `MVVM_Demo` — MVVM 架构
- `FactoryPattern-master` — 工厂模式
- `DataStructure_Graph_Demo` — 数据结构（图）

### 04_UI与系统框架
- `LXMBProgressHUD_Demo` — MBProgressHUD 的 Category
- `LXFileCatalogue` — iOS 文件目录结构
- `frame_vs_bounds` — frame 与 bounds 区别
- `LocalNotif_OC` — 本地通知
- `FormTest` — 表单测试

### 05_第三方SDK与网络
- `RongCloud_Demo` — 融云 IM 接入（Swift）
- `FastDFS_iOS_demo` — FastDFS 文件上传
- `LXRabbitMQ_iOS_Demo` — RabbitMQ 消息队列
- `Socket_Demo` — Socket 通信
- `Jpush_Demo` — 极光推送（含 Notification Service Extension）

### 06_可复用组件Pod
- `LXLaunchGuidePods` — 启动引导页（含 `.podspec`）
- `LXQRCodePods` — 二维码扫描 / 识别（含 `.podspec`）
- `LXLogViewPods` — 日志视图组件
- `LXCheckAppVersion` — App 版本更新检测（组件 + Demo）

### 07_媒体与工具
- `LX_ijkplayer_demo` — ijkplayer 播放器接入
- `Audio_Demo` — 音频播放
- `Scan_QRCode_Distance` — 扫码识别距离
- `ShowSandBoxFile_SendFileByMail_Demo` — 沙盒文件浏览 + 邮件发送

### 08_Swift
- `SwiftProject` — Swift 集合（Swift_30day、LXSwift、TestPods_OC/Swift、Notification_Demo、MacOS_First、AppCenter、playground 等 8 个子项目）

### 09_完整App
- `TodayNews` — 今日头条风格新闻 demo（内含 TodayNews 主工程与 `FlickrSearchStarterProject` 图片搜索工程）

---

## 使用提示

- 移动采用 `git mv`，每个工程的 `.xcodeproj` 相对路径未变，可直接打开。
- 含 CocoaPods 依赖的项目（如 LXLogViewPods、RongCloud_Demo、SwiftProject 等）`Pods/` 已被 `.gitignore` 忽略，克隆后需先 `pod install`。
