//
//  SystemPanel.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import AppKit

/// 跳转系统设置的入口。
@MainActor
enum SystemPanel {
    /// 打开键盘设置。注意：URL 深链无法直达「服务」子页，
    /// 用户需在键盘设置里点「键盘快捷键 → 服务」进行真正的勾选显隐。
    static func openServices() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.Keyboard-Settings.extension") else { return }
        NSWorkspace.shared.open(url)
    }
}
