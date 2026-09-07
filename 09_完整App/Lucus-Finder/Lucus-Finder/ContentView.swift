//
//  ContentView.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import SwiftUI

/// 使用说明窗口（首次启动自动带出，也可从菜单栏再次打开）。
struct ContentView: View {
    private let groupOrder = ["打开", "复制", "信息", "分享"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Label("Lucus-Finder", systemImage: "finder")
                    .font(.title.bold())
                Spacer()
                Button {
                    AppWindows.showSettings()
                } label: {
                    Label("偏好设置…", systemImage: "gearshape")
                }
            }

            Text("在 Finder 里选中任意文件或文件夹后右键，从「服务」菜单选择操作。动作总数多于约 5 个时会自动收进二级「服务」子菜单。")
                .foregroundStyle(.secondary)

            ForEach(groupOrder, id: \.self) { group in
                VStack(alignment: .leading, spacing: 4) {
                    Text(group)
                        .font(.headline)
                    ForEach(ActionID.allCases.filter { $0.groupName == group }) { action in
                        InstructionRow(icon: action.systemImage,
                                       title: action.displayName,
                                       detail: Self.detail(for: action))
                    }
                }
            }

            Divider()

            Text("本 App 常驻菜单栏（图标）。通过 Finder 服务被冷启动时不会弹窗。某动作想彻底隐藏：偏好设置 → 打开系统服务面板，在系统设置的服务列表里取消勾选。")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(22)
        .frame(minWidth: 540)
    }

    private static func detail(for action: ActionID) -> String {
        switch action {
        case .openTerminalHere: "用偏好设置里的默认终端打开（文件→在其所在目录打开）。"
        case .openInEditor: "用默认编辑器打开（目录作为工作区 / 文件开标签）。"
        case .openInXcode: "打开工程；纯目录则扫描其中的 .xcodeproj/.xcworkspace。"
        case .copyPath: "复制 POSIX 绝对路径。"
        case .copyFileName: "复制文件名（含扩展名）。"
        case .copyBaseName: "复制文件名（不含扩展名）。"
        case .copyFileURL: "复制为 file:// 链接（自动百分号编码）。"
        case .copyMD5: "计算文件 MD5 并复制。"
        case .copySHA256: "计算文件 SHA-256 并复制。"
        case .showInfoPanel: "打开系统的「显示简介」面板；未授权时降级为在 Finder 中定位。"
        case .airDropFile: "把所选文件通过隔空投送分享。"
        }
    }
}

/// 一条操作说明：图标 + 名称 + 详细描述。
private struct InstructionRow: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundStyle(.tint)
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.callout.weight(.medium))
                Text(detail)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
}
