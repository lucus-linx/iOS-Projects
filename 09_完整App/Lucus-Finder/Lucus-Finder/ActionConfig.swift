//
//  ActionConfig.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import Foundation
import Combine

/// 右键动作清单。
/// 重要约定：`rawValue` 必须与 Info.plist `NSServices` 的 `NSMessage`、
/// 以及 `ServicesProvider` 里的 `@objc` 方法名一字不差（同源三处）。
enum ActionID: String, CaseIterable, Identifiable, Sendable {
    case openTerminalHere
    case openInEditor
    case openInXcode
    case copyPath
    case copyFileName
    case copyBaseName
    case copyFileURL
    case copyMD5
    case copySHA256
    case showInfoPanel
    case airDropFile

    var id: String { rawValue }

    /// 设置页行内名称（不带分组前缀，前缀由 Finder 菜单本身使用）。
    nonisolated var displayName: String {
        switch self {
        case .openTerminalHere: "在此处打开终端"
        case .openInEditor: "在此处打开编辑器"
        case .openInXcode: "用 Xcode 打开工程"
        case .copyPath: "复制路径"
        case .copyFileName: "复制文件名"
        case .copyBaseName: "复制文件名（无后缀）"
        case .copyFileURL: "复制为 file:// 链接"
        case .copyMD5: "计算并复制 MD5"
        case .copySHA256: "计算并复制 SHA-256"
        case .showInfoPanel: "显示简介（Get Info）"
        case .airDropFile: "隔空投送…"
        }
    }

    nonisolated var groupName: String {
        switch self {
        case .openTerminalHere, .openInEditor, .openInXcode: "打开"
        case .copyPath, .copyFileName, .copyBaseName, .copyFileURL: "复制"
        case .copyMD5, .copySHA256, .showInfoPanel: "信息"
        case .airDropFile: "分享"
        }
    }

    nonisolated var systemImage: String {
        switch self {
        case .openTerminalHere: "terminal"
        case .openInEditor: "chevron.left.forwardslash.chevron.right"
        case .openInXcode: "hammer"
        case .copyPath: "doc.on.doc"
        case .copyFileName: "textformat"
        case .copyBaseName: "textformat.abc"
        case .copyFileURL: "link"
        case .copyMD5: "number.circle"
        case .copySHA256: "function"
        case .showInfoPanel: "info.circle"
        case .airDropFile: "square.and.arrow.up"
        }
    }
}

/// 动作与默认应用的开关配置。设置页与动作门控的唯一真源，基于 UserDefaults。
@MainActor
final class ActionConfig: ObservableObject {
    static let shared = ActionConfig()

    private let defaults: UserDefaults

    private enum Keys {
        static let enabledPrefix = "action.enabled."
        static let defaultTerminalID = "default.terminalBundleID"
        static let defaultEditorID = "default.editorBundleID"
        static let hasLaunchedOnce = "app.hasLaunchedOnce"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - 首启标记

    var hasLaunchedOnce: Bool {
        get { defaults.bool(forKey: Keys.hasLaunchedOnce) }
        set { defaults.set(newValue, forKey: Keys.hasLaunchedOnce) }
    }

    // MARK: - 默认应用（"在此处打开终端/编辑器"用）

    var defaultTerminalID: String {
        get { defaults.string(forKey: Keys.defaultTerminalID) ?? "com.apple.Terminal" }
        set {
            defaults.set(newValue, forKey: Keys.defaultTerminalID)
            objectWillChange.send()
        }
    }

    var defaultEditorID: String {
        get {
            // 未设置过时自动落到第一个"已安装"的编辑器并持久化，避免默认指向没装的 App。
            if let stored = defaults.string(forKey: Keys.defaultEditorID), !stored.isEmpty { return stored }
            let firstInstalled = AppRegistry.installed(AppRegistry.editors).first?.bundleID ?? ""
            defaults.set(firstInstalled, forKey: Keys.defaultEditorID)
            return firstInstalled
        }
        set {
            defaults.set(newValue, forKey: Keys.defaultEditorID)
            objectWillChange.send()
        }
    }

    // MARK: - 动作开关（行为门控）

    /// 默认全部开启；用户关闭后该项仍在 Finder 菜单里，但点击不再执行。
    func isEnabled(_ action: ActionID) -> Bool {
        let key = Keys.enabledPrefix + action.rawValue
        if defaults.object(forKey: key) == nil { return true }
        return defaults.bool(forKey: key)
    }

    func setEnabled(_ action: ActionID, _ on: Bool) {
        defaults.set(on, forKey: Keys.enabledPrefix + action.rawValue)
        objectWillChange.send()
    }
}
