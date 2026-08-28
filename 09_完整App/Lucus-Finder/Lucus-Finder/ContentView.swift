//
//  ContentView.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Lucus-Finder", systemImage: "finder")
                .font(.title.bold())

            Text("在 Finder 中右键任意文件或文件夹，从「服务」菜单选择操作。")
                .foregroundStyle(.secondary)

            Divider()

            InstructionRow(
                icon: "terminal",
                title: "在此处打开终端",
                detail: "右键文件夹会在该目录打开 Terminal；右键文件则在它所在的父目录打开。"
            )
            InstructionRow(
                icon: "doc.on.doc",
                title: "复制路径",
                detail: "把所选文件/文件夹的完整路径复制到剪贴板。"
            )

            Divider()

            Text("菜单里没看到？请到「系统设置 → 键盘 → 键盘快捷键 → 服务」勾选对应项，并确认本 App 已启动过一次。")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .frame(minWidth: 440, minHeight: 260)
    }
}

/// 一条操作说明：图标 + 名称 + 详细描述。
private struct InstructionRow: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundStyle(.tint)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(detail)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
}
