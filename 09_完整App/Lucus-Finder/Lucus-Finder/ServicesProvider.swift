//
//  ServicesProvider.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import AppKit

/// Finder 右键"服务"菜单的服务提供者。
///
/// 每条 `@objc` 方法名必须与 Info.plist `NSServices` 里对应 dict 的 `NSMessage` 一字不差，
/// 否则菜单项能显示但点击后静默无动作。新增动作流程：
///   1. Info.plist 加一个 service dict；
///   2. 这里加同名 `@objc` 方法；
///   3. `ActionID` 枚举补一个 case，纳入设置页开关。
///
/// 沙盒认知：服务回调等于"用户当场选中这些文件"，系统把所选路径的**读取**权限授予本 App，
/// 因此 stat / 哈希 / 分享都要在回调里做完；不能写回源文件旁，也不能存路径稍后再读。
final class ServicesProvider: NSObject {

    // MARK: - 打开

    /// 右键文件夹 → 在该目录打开终端；右键文件 → 在其父目录打开终端。终端由设置决定。
    @objc func openTerminalHere(_ pboard: NSPasteboard,
                                userData: String,
                                error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard ActionConfig.shared.isEnabled(.openTerminalHere),
              let url = firstURL(from: pboard) else { return }
        let terminalID = ActionConfig.shared.defaultTerminalID
        TerminalLauncher.open(directory: directoryURL(for: url), inTerminalWithBundleID: terminalID)
    }

    /// 在默认编辑器里打开（目录当 workspace / 文件开 tab）。
    @objc func openInEditor(_ pboard: NSPasteboard,
                            userData: String,
                            error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard ActionConfig.shared.isEnabled(.openInEditor),
              let url = firstURL(from: pboard) else { return }
        let editorID = ActionConfig.shared.defaultEditorID
        EditorLauncher.open(url: url, inEditorWithBundleID: editorID)
    }

    /// 用 Xcode 打开工程（目录扫首个工程；文件直接进 Xcode）。
    @objc func openInXcode(_ pboard: NSPasteboard,
                           userData: String,
                           error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard ActionConfig.shared.isEnabled(.openInXcode),
              let url = firstURL(from: pboard) else { return }
        EditorLauncher.openInXcode(at: url)
    }

    // MARK: - 复制

    @objc func copyPath(_ pboard: NSPasteboard,
                        userData: String,
                        error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard ActionConfig.shared.isEnabled(.copyPath),
              let url = firstURL(from: pboard) else { return }
        ClipboardKit.copy(url.path)
    }

    @objc func copyFileName(_ pboard: NSPasteboard,
                            userData: String,
                            error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard ActionConfig.shared.isEnabled(.copyFileName),
              let url = firstURL(from: pboard) else { return }
        ClipboardKit.copy(PathFormatting.fileName(url))
    }

    @objc func copyBaseName(_ pboard: NSPasteboard,
                            userData: String,
                            error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard ActionConfig.shared.isEnabled(.copyBaseName),
              let url = firstURL(from: pboard) else { return }
        ClipboardKit.copy(PathFormatting.baseName(url))
    }

    @objc func copyFileURL(_ pboard: NSPasteboard,
                           userData: String,
                           error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard ActionConfig.shared.isEnabled(.copyFileURL),
              let url = firstURL(from: pboard) else { return }
        ClipboardKit.copy(PathFormatting.fileURLString(url))
    }

    // MARK: - 信息

    @objc func copyMD5(_ pboard: NSPasteboard,
                       userData: String,
                       error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard ActionConfig.shared.isEnabled(.copyMD5),
              let url = firstURL(from: pboard),
              let hex = FileDigest.md5Hex(of: url) else { return }
        ClipboardKit.copy(hex)
    }

    @objc func copySHA256(_ pboard: NSPasteboard,
                          userData: String,
                          error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard ActionConfig.shared.isEnabled(.copySHA256),
              let url = firstURL(from: pboard),
              let hex = FileDigest.sha256Hex(of: url) else { return }
        ClipboardKit.copy(hex)
    }

    @objc func showInfoPanel(_ pboard: NSPasteboard,
                             userData: String,
                             error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard ActionConfig.shared.isEnabled(.showInfoPanel),
              let url = firstURL(from: pboard) else { return }
        FinderBridge.showInfoPanel(for: url)
    }

    // MARK: - 分享

    @objc func airDropFile(_ pboard: NSPasteboard,
                           userData: String,
                           error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard ActionConfig.shared.isEnabled(.airDropFile) else { return }
        let urls = paths(from: pboard).map { URL(fileURLWithPath: $0) }
        guard !urls.isEmpty else { return }
        Sharer.airDrop(urls: urls)
    }

    // MARK: - 工具方法

    /// 读服务传参的粘贴板路径（POSIX 字符串数组），兼容新旧粘贴板类型。
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

    private func firstURL(from pboard: NSPasteboard) -> URL? {
        guard let first = paths(from: pboard).first else { return nil }
        return URL(fileURLWithPath: first)
    }

    /// 文件 → 取其父目录；文件夹 → 用自身。用于"在此处打开终端"。
    private func directoryURL(for url: URL) -> URL {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return isDirectory.boolValue ? url : url.deletingLastPathComponent()
    }

    // MARK: - 一致性自检

    /// 校验 Info.plist 里每个 NSMessage 是否都有对应 @objc 方法，防止改名后菜单"能看不能点"。
    @MainActor
    static func verifyPlistMessagesMatch() {
        guard let services = Bundle.main.object(forInfoDictionaryKey: "NSServices") as? [[String: Any]] else {
            print("[Lucus] ⚠️ 未在 Info.plist 找到 NSServices")
            return
        }
        let provider = ServicesProvider()
        for dict in services {
            if let message = dict["NSMessage"] as? String {
                let matched = provider.responds(to: Selector(message))
                print("[Lucus] NSMessage「\(message)」→ \(matched ? "✓ 有对应方法" : "✗ 缺少对应方法！")")
            }
        }
    }
}
