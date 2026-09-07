//
//  Lucus_FinderApp.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import SwiftUI
import AppKit

@main
struct Lucus_FinderApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        // 后台化的"菜单栏 App"：没有 Dock 图标、没有常驻主窗口，
        // 唯一常驻 UI 是菜单栏图标；设置与使用说明窗口按需由菜单栏唤起。
        MenuBarExtra {
            AppMenuView()
        } label: {
            Image(systemName: "cursorarrow.click.2")
        }
        .menuBarExtraStyle(.menu)
    }
}

/// 应用代理：注册服务提供者 + 维护后台(accessory)激活策略。
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var services = ServicesProvider()

    func applicationWillFinishLaunching(_ notification: Notification) {
        // 尽早转成后台模式，避免冷启动瞬间 Dock 图标闪现。
        NSApp.setActivationPolicy(.accessory)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 最先同步注册服务提供者。服务消息在 didFinishLaunching 返回、主 run loop 起跑后才派发，
        // 因此这里同步赋值严格先于任何服务回调，无竞态；切勿把注册推迟到异步任务里。
        NSApp.servicesProvider = services

        #if DEBUG
        // 开发期 Info.plist 变更后强制刷新系统服务缓存；并自检 NSMessage 与 @objc 方法是否同名。
        NSUpdateDynamicServices()
        ServicesProvider.verifyPlistMessagesMatch()
        #endif

        observeWindowCloseToDemote()

        // 首次启动：带出使用说明窗口，让用户知道入口与去哪开启服务。
        if !ActionConfig.shared.hasLaunchedOnce {
            ActionConfig.shared.hasLaunchedOnce = true
            AppWindows.showUsage()
        }
    }

    // MARK: - 窗口关闭后回到后台

    private var closeObserver: NSObjectProtocol?

    private func observeWindowCloseToDemote() {
        closeObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: nil,
            queue: .main
        ) { _ in
            Task { @MainActor in
                AppWindows.demoteIfNoVisibleWindow()
            }
        }
    }
}
