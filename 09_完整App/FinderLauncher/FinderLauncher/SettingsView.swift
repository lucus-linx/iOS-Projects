//
//  SettingsView.swift
//  FinderLauncher
//
//  Created by 启业云03 on 2026/9/1.
//

import SwiftUI
import Carbon.HIToolbox
import ServiceManagement

/// 设置窗口：全局快捷键、终端选择（Terminal / iTerm2）、开机自启、自动化授权入口。
struct SettingsView: View {

    @AppStorage("hotkeyEnabled") private var hotkeyEnabled = true
    /// 存 Int（AppStorage 不支持 UInt32），使用时转 UInt32。
    @AppStorage("hotkeyKeyCode") private var hotkeyKeyCode = Int(kVK_ANSI_T)
    @AppStorage("hotkeyModifiers") private var hotkeyModifiers = Int(cmdKey | shiftKey)

    @AppStorage("terminalKind") private var terminalKind = 0
    @AppStorage("launchAtLogin") private var launchAtLogin = false

    @State private var isITermInstalled = TerminalLauncherFactory.isITermInstalled()
    @StateObject private var recorder = HotkeyRecorder()

    var body: some View {
        Form {
            Section("快捷键") {
                Toggle("启用全局快捷键", isOn: $hotkeyEnabled)
                    .onChange(of: hotkeyEnabled) { _, _ in
                        HotkeyManager.shared.applySettings()
                    }

                if hotkeyEnabled {
                    HStack {
                        Text("快捷键")
                        Spacer()
                        Button(recorder.isRecording
                               ? "请按下组合键…"
                               : KeycodeTable.displayString(
                                   keyCode: UInt32(hotkeyKeyCode),
                                   modifiers: UInt32(hotkeyModifiers))) {
                            recorder.begin()
                        }
                    }
                }
            }

            Section("终端") {
                Picker("打开方式", selection: $terminalKind) {
                    Text("Terminal（系统）").tag(0)
                    if isITermInstalled {
                        Text("iTerm2").tag(1)
                    }
                }
                .onChange(of: terminalKind) { _, newValue in
                    if newValue == 1 && !isITermInstalled {
                        terminalKind = 0   // iTerm2 未安装则回退
                    }
                }
                Text("将在 Finder 当前目录打开一个新的\(terminalKind == 1 ? "iTerm2" : "Terminal")窗口。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("启动") {
                Toggle("开机自动启动", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { _, enabled in
                        setLaunchAtLogin(enabled)
                    }
            }

            Section("权限") {
                Button("打开系统「自动化」授权设置…") {
                    let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation")!
                    NSWorkspace.shared.open(url)
                }
                Text("首次使用需授权本 App 控制 Finder，以便读取当前目录。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .frame(width: 380)
        .padding(20)
        .onAppear {
            // 同步开机自启状态（用户可能在系统设置里手动改过）。
            launchAtLogin = SMAppService.mainApp.status == .enabled
            recorder.onRecorded = { keyCode, modifiers in
                hotkeyKeyCode = Int(keyCode)
                hotkeyModifiers = Int(modifiers)
                HotkeyManager.shared.applySettings()
            }
        }
    }

    // MARK: - 开机自启

    /// 注册 / 注销登录项。需要 App 位于 /Applications 且签名有效。
    private func setLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("[FinderLauncher] 设置开机自启失败：\(error)")
        }
    }
}
