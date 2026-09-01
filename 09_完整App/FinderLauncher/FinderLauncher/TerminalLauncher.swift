//
//  TerminalLauncher.swift
//  FinderLauncher
//
//  Created by 启业云03 on 2026/9/1.
//

import AppKit

/// 终端启动器协议：不同终端实现 openTerminal。
protocol TerminalLauncher {
    func openTerminal(at directory: URL)
}

/// 系统 Terminal 实现：用 NSWorkspace 打开 Terminal 并传入目录 URL。
///
/// 复用 Lucus-Finder 已验证的方案：Terminal 会开一个新窗口并 `cd` 到该目录，
/// 不通过 Apple Events 控制 Terminal，因此无需对 Terminal 的自动化授权。
struct SystemTerminalLauncher: TerminalLauncher {
    func openTerminal(at directory: URL) {
        let terminalApp = URL(fileURLWithPath: "/System/Applications/Utilities/Terminal.app")
        let config = NSWorkspace.OpenConfiguration()
        config.activates = true
        NSWorkspace.shared.open([directory], withApplicationAt: terminalApp,
                                configuration: config) { _, error in
            if let error {
                print("[FinderLauncher] 打开终端失败：\(error)")
            }
        }
    }
}

/// iTerm2 实现：通过 NSWorkspace 打开 iTerm2 并传入目录。
/// 用 bundle id 动态定位 iTerm2，未安装时 guard 失败（调用方兜底或静默）。
struct ITermLauncher: TerminalLauncher {
    func openTerminal(at directory: URL) {
        guard let iterm = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.googlecode.iterm2") else {
            print("[FinderLauncher] 未检测到 iTerm2")
            return
        }
        let config = NSWorkspace.OpenConfiguration()
        config.activates = true
        NSWorkspace.shared.open([directory], withApplicationAt: iterm,
                                configuration: config) { _, error in
            if let error {
                print("[FinderLauncher] 打开 iTerm2 失败：\(error)")
            }
        }
    }
}

/// 终端工厂：按设置选择具体终端。
enum TerminalLauncherFactory {
    /// 按 UserDefaults 的 terminalKind 选择终端：0 = Terminal，1 = iTerm2。
    static func make() -> any TerminalLauncher {
        if UserDefaults.standard.integer(forKey: "terminalKind") == 1 {
            return ITermLauncher()
        }
        return SystemTerminalLauncher()
    }

    /// iTerm2 是否已安装（供设置页启用/禁用选项）。
    static func isITermInstalled() -> Bool {
        NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.googlecode.iterm2") != nil
    }
}
