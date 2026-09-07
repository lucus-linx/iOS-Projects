//
//  AppRegistry.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import AppKit

/// 一个候选 App：bundle id + 展示名。
struct InstalledApp: Identifiable, Hashable, Sendable {
    let bundleID: String
    let name: String
    var id: String { bundleID }
}

/// 已安装应用的探测表。
/// 沙盒下不能用枚举 /Applications 来发现 App，正确姿势是拿着已知 bundle id
/// 逐个问 LaunchServices（XPC，不受 file-read 沙盒限制）。查到 URL 后别再深读其 bundle 内部。
/// 结果做进程内缓存，避免每次右键都反复查 LS。
@MainActor
enum AppRegistry {
    static let terminals: [InstalledApp] = [
        InstalledApp(bundleID: "com.apple.Terminal", name: "Terminal"),
        InstalledApp(bundleID: "com.googlecode.iterm2", name: "iTerm2"),
        InstalledApp(bundleID: "dev.warp.Warp-Stable", name: "Warp"),
        InstalledApp(bundleID: "com.mitchellh.ghostty", name: "Ghostty"),
    ]

    static let editors: [InstalledApp] = [
        InstalledApp(bundleID: "com.microsoft.VSCode", name: "Visual Studio Code"),
        InstalledApp(bundleID: "com.todesktop.230313mzl4w4u92", name: "Cursor"),
        InstalledApp(bundleID: "com.sublimetext.4", name: "Sublime Text"),
        InstalledApp(bundleID: "com.coteditor.CotEditor", name: "CotEditor"),
    ]

    private static var urlCache: [String: URL] = [:]
    private static var checked = Set<String>()

    /// 返回在系统中已安装（被 LaunchServices 登记）的那部分。
    static func installed(_ apps: [InstalledApp]) -> [InstalledApp] {
        apps.filter { url(for: $0.bundleID) != nil }
    }

    static func url(for bundleID: String) -> URL? {
        if checked.contains(bundleID) { return urlCache[bundleID] }
        let found = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID)
        urlCache[bundleID] = found
        checked.insert(bundleID)
        return found
    }

    static func displayName(for bundleID: String, candidates: [InstalledApp]) -> String {
        candidates.first { $0.bundleID == bundleID }?.name ?? bundleID
    }
}
