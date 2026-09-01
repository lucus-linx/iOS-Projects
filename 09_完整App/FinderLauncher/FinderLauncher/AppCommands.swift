//
//  AppCommands.swift
//  FinderLauncher
//
//  Created by 启业云03 on 2026/9/1.
//

import AppKit

/// 所有用户动作的唯一入口（菜单点击 / 全局热键都走这里）。
@MainActor
final class AppCommands {

    static let shared = AppCommands()

    /// 按设置动态选择终端（Terminal / iTerm2）。
    private var launcher: any TerminalLauncher {
        TerminalLauncherFactory.make()
    }

    private init() {}

    /// 在当前 Finder 目录打开 Terminal。
    func openTerminalHere() {
        do {
            let url = try FinderPathProvider.currentDirectory()
            launcher.openTerminal(at: url)
        } catch {
            presentError(error)
        }
    }

    /// 复制当前 Finder 目录的路径到剪贴板。
    func copyCurrentPath() {
        do {
            let url = try FinderPathProvider.currentDirectory()
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(url.path, forType: .string)
        } catch {
            presentError(error)
        }
    }

    /// 在 Finder 中定位当前目录（新窗口打开）。
    func revealInFinder() {
        do {
            let url = try FinderPathProvider.currentDirectory()
            NSWorkspace.shared.open(url)
        } catch {
            presentError(error)
        }
    }

    // MARK: - 错误呈现

    private func presentError(_ error: Error) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "FinderLauncher"
        alert.informativeText = error.localizedDescription

        if case FinderPathError.tccDenied = error {
            alert.addButton(withTitle: "打开授权设置")
            alert.addButton(withTitle: "取消")
            if alert.runModal() == .alertFirstButtonReturn {
                let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation")!
                NSWorkspace.shared.open(url)
            }
        } else {
            alert.addButton(withTitle: "好")
            alert.runModal()
        }
    }
}
