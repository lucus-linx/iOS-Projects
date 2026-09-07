//
//  AppWindows.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import AppKit
import SwiftUI

/// 菜单栏(accessory)应用在 .accessory / .regular 激活策略间切换的辅助。
/// macOS 下 .accessory 应用仅 activate() 往往不足以把窗口带到前台，
/// 稳定做法是「先临时切 .regular → activate → 打开窗口」；最后一个窗口关闭后由观察器 demote。
@MainActor
enum AppWindows {

    static func promote() {
        if NSApp.activationPolicy() != .regular {
            NSApp.setActivationPolicy(.regular)
        }
        NSApp.activate(ignoringOtherApps: true)
    }

    static func demoteIfNoVisibleWindow() {
        guard NSApp.activationPolicy() == .regular else { return }
        let hasVisibleMainWindow = NSApp.windows.contains { $0.isVisible && $0.canBecomeMain }
        if !hasVisibleMainWindow {
            NSApp.setActivationPolicy(.accessory)
        }
    }

    // MARK: - 两个被托管的窗口

    static let usage = HostedWindow(title: "Lucus-Finder 使用说明",
                                    minSize: NSSize(width: 540, height: 460)) {
        ContentView()
    }

    static let settings = HostedWindow(title: "Lucus-Finder 偏好设置",
                                       minSize: NSSize(width: 500, height: 560)) {
        SettingsView()
    }

    static func showUsage() { usage.show() }
    static func showSettings() { settings.show() }
}

/// 把一段 SwiftUI 内容装进一个可复用、可复用复用打开的 NSWindow。
@MainActor
final class HostedWindow<Content: View> {
    private var window: NSWindow?
    private let title: String
    private let content: Content
    private let minSize: NSSize

    init(title: String, minSize: NSSize, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
        self.minSize = minSize
    }

    func show() {
        AppWindows.promote()
        if window == nil {
            let hosting = NSHostingView(rootView: content)
            let fitting = hosting.fittingSize
            var size = NSSize(width: max(minSize.width, fitting.width),
                              height: max(minSize.height, fitting.height))
            if let screen = NSScreen.main?.visibleFrame {
                size.height = min(size.height, screen.height * 0.92)
                size.width = min(size.width, screen.width * 0.95)
            }
            let style: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]
            let w = NSWindow(contentRect: NSRect(origin: .zero, size: size),
                             styleMask: style, backing: .buffered, defer: false)
            w.title = title
            w.contentView = hosting
            w.minSize = minSize
            w.isReleasedWhenClosed = false
            window = w
        }
        if let window {
            window.center()
            window.makeKeyAndOrderFront(nil)
        }
    }
}
