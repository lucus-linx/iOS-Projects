//
//  FinderBridge.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import AppKit

/// 通过 AppleScript 驱动 Finder。
/// 沙盒不拦 osascript 子进程；拦的是 TCC 自动化授权（首次会弹「允许 Lucus-Finder 控制 Finder」）。
/// 授权被拒/脚本失败时降级为在 Finder 中选中并高亮（走 LS，零授权成本）。
@MainActor
enum FinderBridge {

    static func showInfoPanel(for url: URL) {
        // 实测：须带 `as alias` 才是 Finder 认识的 file 引用；否则报 -1728。
        let literal = PathFormatting.appleScriptStringLiteral(url.path)
        let script = "tell application \"Finder\" to open information window of (POSIX file \(literal) as alias)"
        ProcessRunner.runAsync(executable: URL(fileURLWithPath: "/usr/bin/osascript"),
                               arguments: ["-e", script]) { code in
            if code != 0 {
                print("[Lucus] 显示简介失败（授权未允许？），降级为在 Finder 中定位")
                NSWorkspace.shared.activateFileViewerSelecting([url])
            }
        }
    }
}
