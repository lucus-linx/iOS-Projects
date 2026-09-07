//
//  EditorLauncher.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import AppKit

/// 在编辑器里打开文件/目录。
@MainActor
enum EditorLauncher {

    /// 通用编辑器：目录作为 workspace、文件开 tab。VSCode/Cursor/Sublime/CotEditor 都处理 odoc。
    static func open(url: URL, inEditorWithBundleID bundleID: String) {
        guard let appURL = AppRegistry.url(for: bundleID) else {
            print("[Lucus] 未安装编辑器：\(bundleID)")
            return
        }
        let cfg = NSWorkspace.OpenConfiguration()
        cfg.activates = true
        NSWorkspace.shared.open([url], withApplicationAt: appURL, configuration: cfg) { _, error in
            if let error { print("[Lucus] 打开编辑器失败：\(error)") }
        }
    }

    /// Xcode 专用入口：
    /// - 目录：扫到 `.xcodeproj/.xcworkspace/.playground` 用 `xed` 打开工程；纯目录用 Xcode 打开文件夹。
    /// - 文件：`xed` 直接在 Xcode 中打开。
    static func openInXcode(at url: URL) {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)

        if isDirectory.boolValue {
            if let projectPath = firstProjectPath(in: url) {
                runXed(projectPath)
            } else if let xcode = AppRegistry.url(for: "com.apple.dt.Xcode") {
                let cfg = NSWorkspace.OpenConfiguration()
                cfg.activates = true
                NSWorkspace.shared.open([url], withApplicationAt: xcode, configuration: cfg) { _, error in
                    if let error { print("[Lucus] Xcode 打开目录失败：\(error)") }
                }
            } else {
                print("[Lucus] 未找到 Xcode")
            }
        } else {
            runXed(url.path)
        }
    }

    /// 在目录中寻找首个工程文件（xcodeproj 优先）。
    static func firstProjectPath(in directory: URL) -> String? {
        let fm = FileManager.default
        guard let entries = try? fm.contentsOfDirectory(atPath: directory.path) else { return nil }
        for ext in ["xcodeproj", "xcworkspace", "playground"] {
            if let name = entries.first(where: { $0.hasSuffix(".\(ext)") }) {
                return directory.appendingPathComponent(name).path
            }
        }
        return nil
    }

    private static func runXed(_ path: String) {
        ProcessRunner.run(executable: URL(fileURLWithPath: "/usr/bin/xed"), arguments: [path])
    }
}
