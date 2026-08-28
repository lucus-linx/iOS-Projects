//
//  ServicesProvider.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import AppKit

/// Finder 右键“服务”菜单的服务提供者。
///
/// 服务项在 Info.plist 的 NSServices 中声明，这里的方法名必须与 NSMessage 一致。
/// 通过 `NSApp.servicesProvider` 注册后，Finder 会把所选文件/文件夹的路径
/// 以粘贴板的形式传入对应方法。
final class ServicesProvider: NSObject {

    // MARK: - 动作一：在此处打开终端

    /// 右键文件夹 → 在该目录打开终端；右键文件 → 在其父目录打开终端。
    @objc func openTerminalHere(_ pboard: NSPasteboard,
                                userData: String,
                                error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard let firstPath = paths(from: pboard).first else { return }
        let directory = directoryURL(for: URL(fileURLWithPath: firstPath))
        openTerminal(at: directory)
    }

    // MARK: - 动作二：复制路径

    /// 复制所选文件/文件夹的 POSIX 路径到剪贴板。
    @objc func copyPath(_ pboard: NSPasteboard,
                        userData: String,
                        error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        guard let firstPath = paths(from: pboard).first else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(firstPath, forType: .string)
        print("[Lucus] 已复制路径：\(firstPath)")
    }

    // MARK: - 工具方法

    /// 从服务传参的粘贴板中读取文件/文件夹路径（POSIX 字符串数组）。
    private func paths(from pboard: NSPasteboard) -> [String] {
        // 现代方式：public.file-url → POSIX 路径数组
        if let paths = pboard.propertyList(forType: .fileURL) as? [String] {
            return paths
        }
        // 兼容旧版 NSFilenamesPboardType
        let legacy = NSPasteboard.PasteboardType("NSFilenamesPboardType")
        if let paths = pboard.propertyList(forType: legacy) as? [String] {
            return paths
        }
        return []
    }

    /// 若目标是文件，取其所在目录；是文件夹则用自身。
    private func directoryURL(for url: URL) -> URL {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return isDirectory.boolValue ? url : url.deletingLastPathComponent()
    }

    /// 用 NSWorkspace 让 Terminal 以指定目录打开新窗口。
    private func openTerminal(at url: URL) {
        let terminalApp = URL(fileURLWithPath: "/System/Applications/Utilities/Terminal.app")
        let config = NSWorkspace.OpenConfiguration()
        config.activates = true
        NSWorkspace.shared.open([url], withApplicationAt: terminalApp, configuration: config) { app, error in
            if let error {
                print("[Lucus] 打开终端失败：\(error)")
            }
        }
    }
}
