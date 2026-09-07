//
//  AppMenuView.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import SwiftUI

/// 菜单栏图标的下拉菜单入口。
struct AppMenuView: View {
    var body: some View {
        Button("偏好设置…") { AppWindows.showSettings() }
        Button("使用说明…") { AppWindows.showUsage() }
        Divider()
        Button("打开系统服务面板") { SystemPanel.openServices() }
        Divider()
        Button("退出 Lucus-Finder") { NSApplication.shared.terminate(nil) }
    }
}
