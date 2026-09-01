//
//  AppDelegate.swift
//  FinderLauncher
//
//  Created by 启业云03 on 2026/9/1.
//

import AppKit
import OSLog

private let logger = Logger(subsystem: "com.linx.FinderLauncher", category: "AppLifecycle")

final class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 全局热键触发 → 打开终端。
        HotkeyManager.shared.onTrigger = {
            AppCommands.shared.openTerminalHere()
        }
        // 按 UserDefaults 配置注册热键。
        HotkeyManager.shared.applySettings()
        logger.debug("热键注册完成")

        // 预检一次自动化授权：首次运行主动弹出「控制 Finder」授权框，
        // 避免用户之后点击时困惑于「路径一直是桌面」。
        Task { @MainActor in
            NSApp.activate(ignoringOtherApps: true)
            do {
                let url = try FinderPathProvider.currentDirectory()
                logger.debug("预检取到目录：\(url.path, privacy: .public)")
            } catch {
                logger.error("预检失败：\(String(describing: error), privacy: .public)")
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        HotkeyManager.shared.unregister()
    }
}
