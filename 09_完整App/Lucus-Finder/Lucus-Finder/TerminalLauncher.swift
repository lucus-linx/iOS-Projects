//
//  TerminalLauncher.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import AppKit

/// 在指定目录打开终端。按 App 分派，优先用"无 TCC 授权"的机制：
///   Terminal → LS odoc（系统行为，目录作为新窗口工作目录）
///   Warp     → 官方 URL scheme（无授权依赖）
///   Ghostty  → 自带 CLI `+new-window --working-directory=`
///   iTerm2   → AppleScript（首次会触发"控制 iTerm2"的自动化授权）
///   其他     → 回退 LS odoc
/// 说明：各 App 的"在目录打开"行为是版本相关的实现细节，README 里留有实测记录表。
@MainActor
enum TerminalLauncher {

    static func open(directory: URL, inTerminalWithBundleID bundleID: String) {
        guard let appURL = AppRegistry.url(for: bundleID) else {
            print("[Lucus] 未安装终端：\(bundleID)")
            return
        }
        switch bundleID {
        case "com.apple.Terminal":
            openByLS(url: directory, appURL: appURL)
        case "dev.warp.Warp-Stable":
            openWarp(directory: directory)
        case "com.mitchellh.ghostty":
            openGhostty(directory: directory)
        case "com.googlecode.iterm2":
            openITerm2(directory: directory)
        default:
            openByLS(url: directory, appURL: appURL)
        }
    }

    private static func openByLS(url: URL, appURL: URL) {
        let cfg = NSWorkspace.OpenConfiguration()
        cfg.activates = true
        NSWorkspace.shared.open([url], withApplicationAt: appURL, configuration: cfg) { _, error in
            if let error { print("[Lucus] 打开终端失败：\(error)") }
        }
    }

    private static func openWarp(directory: URL) {
        var comps = URLComponents(string: "warp://action/new_window")
        comps?.queryItems = [URLQueryItem(name: "path", value: directory.path)]
        guard let url = comps?.url else { return }
        NSWorkspace.shared.open(url)
    }

    private static func openGhostty(directory: URL) {
        guard let appURL = AppRegistry.url(for: "com.mitchellh.ghostty") else { return }
        let cli = appURL.appendingPathComponent("Contents/MacOS/ghostty")
        let args = ["+new-window", "--working-directory=\(directory.path)"]
        ProcessRunner.run(executable: cli, arguments: args)
    }

    private static func openITerm2(directory: URL) {
        // 终端里执行的 shell 命令（cd 到路径），随后作为 AppleScript 字符串字面量嵌入。
        let cdCommand = "cd \(PathFormatting.shellSingleQuote(directory.path))"
        let script = """
        tell application "iTerm2"
            create window with default profile
            tell current session of current window to write text \(PathFormatting.appleScriptStringLiteral(cdCommand))
        end tell
        """
        ProcessRunner.runAsync(executable: URL(fileURLWithPath: "/usr/bin/osascript"),
                               arguments: ["-e", script]) { code in
            if code != 0 { print("[Lucus] 用 iTerm2 打开失败，osascript 退出码 \(code)") }
        }
    }
}
