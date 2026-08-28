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
        WindowGroup {
            ContentView()
        }
    }
}

/// 应用代理：负责把服务提供者注册给 NSApp，
/// 使 Finder 右键“服务”菜单能回调到本应用。
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.servicesProvider = ServicesProvider()
        // 开发阶段 Info.plist 变更后强制刷新系统服务缓存。
        NSUpdateDynamicServices()
    }
}
