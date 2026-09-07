//
//  SettingsView.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import SwiftUI

/// 设置窗口：默认应用 + 动作开关（行为门控）+ 系统服务面板入口。
struct SettingsView: View {
    @ObservedObject private var config = ActionConfig.shared
    private let groupOrder = ["打开", "复制", "信息", "分享"]

    var body: some View {
        Form {
            Section("默认应用") {
                Picker("默认终端", selection: terminalBinding) {
                    ForEach(AppRegistry.installed(AppRegistry.terminals)) { app in
                        Text(app.name).tag(app.bundleID)
                    }
                }
                Picker("默认编辑器", selection: editorBinding) {
                    ForEach(AppRegistry.installed(AppRegistry.editors)) { app in
                        Text(app.name).tag(app.bundleID)
                    }
                }
            }

            Section {
                ForEach(groupOrder, id: \.self) { group in
                    ForEach(ActionID.allCases.filter { $0.groupName == group }) { action in
                        Toggle(isOn: enabledBinding(for: action)) {
                            Label(action.displayName, systemImage: action.systemImage)
                        }
                    }
                }
            } header: {
                Text("启用动作")
            } footer: {
                Text("开关只控制动作是否执行。NSServices 菜单项编译期写入 Info.plist，无法在运行时移除：想让它彻底不出现在右键菜单，请到系统设置的服务列表里取消勾选。")
            }

            Section("系统服务") {
                Button("打开系统服务面板") { SystemPanel.openServices() }
                Text("在打开的键盘设置里点「键盘快捷键 → 服务」，可看到每个动作并勾选显示 / 隐藏。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("关于") {
                VStack(alignment: .leading, spacing: 6) {
                    Label("后台常驻菜单栏：被 Finder 服务冷启动时不会弹窗。", systemImage: "menubar.rectangle")
                    Label("动作的 NSMessage 与代码方法名严格同名；改动后需重新构建并重注册。", systemImage: "checkmark.seal")
                    Label("沙盒内可读取所选文件（哈希/分享当场完成），但不会写回源文件旁。", systemImage: "lock.shield")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .frame(minWidth: 500)
        .padding(16)
    }

    // MARK: - Bindings

    private var terminalBinding: Binding<String> {
        Binding(get: { config.defaultTerminalID },
                set: { config.defaultTerminalID = $0 })
    }

    private var editorBinding: Binding<String> {
        Binding(get: { config.defaultEditorID },
                set: { config.defaultEditorID = $0 })
    }

    private func enabledBinding(for action: ActionID) -> Binding<Bool> {
        Binding(get: { config.isEnabled(action) },
                set: { config.setEnabled(action, $0) })
    }
}
