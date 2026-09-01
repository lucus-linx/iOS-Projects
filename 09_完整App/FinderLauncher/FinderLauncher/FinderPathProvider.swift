//
//  FinderPathProvider.swift
//  FinderLauncher
//
//  Created by 启业云03 on 2026/9/1.
//

import AppKit
import OSLog

private let logger = Logger(subsystem: "com.linx.FinderLauncher", category: "FinderPath")

/// 获取 Finder 目录时的错误。
enum FinderPathError: LocalizedError {
    /// 用户拒绝了「控制 Finder」的自动化授权（-1743）。
    case tccDenied
    /// Apple Event 超时 / Finder 忙（-609 / -608）。
    case finderBusy
    /// 其它错误。
    case unknown(Int)

    var errorDescription: String? {
        switch self {
        case .tccDenied:
            return "没有读取 Finder 目录的权限。请在「系统设置 → 隐私与安全性 → 自动化」中允许本 App 控制 Finder，然后重试。"
        case .finderBusy:
            return "Finder 没有响应，请稍后重试。"
        case .unknown(let code):
            return "获取 Finder 目录失败（错误码 \(code)）。"
        }
    }
}

/// 读取当前 Finder 窗口的目标目录；无窗口或 Finder 未运行时回退到桌面。
///
/// 用 `osascript` 子进程（而非 NSAppleScript）发送 Apple Event：
/// LSUIElement 菜单栏 App 直接发 Apple Events 时，系统不会弹出 TCC 授权框而是静默拒绝（-1743）；
/// 从本 App 启动的 osascript 子进程能正常触发授权弹窗，授权归因到本 App。
enum FinderPathProvider {

    /// 取 Finder 前窗目录；front window 取不到时枚举所有窗口兜底；
    /// 全失败才回退桌面。TCC 授权拒绝（-1743）会抛出，不吞掉。
    private static let script = """
    tell application "Finder"
        try
            return POSIX path of (target of front window as alias)
        on error errMsg number errNum
            if errNum is -1743 then error errMsg number errNum
            try
                repeat with w in windows
                    try
                        return POSIX path of (target of w as alias)
                    on error
                    end try
                end repeat
            end try
            return POSIX path of (path to desktop folder)
        end try
    end tell
    """

    /// 当前 Finder 前窗目录；无窗口 / Finder 未运行 → 桌面。
    static func currentDirectory() throws -> URL {
        // Finder 未运行时直接返回桌面，避免脚本自动拉起 Finder。
        guard isFinderRunning else {
            let desktop = desktopURL()
            logger.warning("Finder 未运行，回退桌面：\(desktop.path, privacy: .public)")
            return desktop
        }

        // 用 osascript 子进程发 Apple Event。
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
        task.arguments = ["-e", Self.script]

        let outPipe = Pipe()
        let errPipe = Pipe()
        task.standardOutput = outPipe
        task.standardError = errPipe

        do {
            try task.run()
            task.waitUntilExit()
        } catch {
            logger.error("启动 osascript 失败：\(String(describing: error), privacy: .public)")
            throw FinderPathError.unknown(-2)
        }

        let errText = String(data: errPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
        let outText = String(data: outPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
        logger.debug("osascript exit=\(task.terminationStatus)")

        // 非 0 退出码：错误在 stderr，形如 "… (-1743)"。
        if task.terminationStatus != 0 {
            if errText.contains("-1743") || outText.contains("-1743") {
                throw FinderPathError.tccDenied
            }
            if errText.contains("-609") || errText.contains("-608") {
                throw FinderPathError.finderBusy
            }
            logger.error("osascript 错误：\(errText.trimmingCharacters(in: .whitespacesAndNewlines), privacy: .public)")
            throw FinderPathError.unknown(Int(task.terminationStatus))
        }

        let path = outText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !path.isEmpty else {
            throw FinderPathError.unknown(-3)
        }
        logger.info("取到 Finder 目录：\(path, privacy: .public)")
        return URL(fileURLWithPath: path, isDirectory: true)
    }

    private static var isFinderRunning: Bool {
        NSWorkspace.shared.runningApplications.contains { $0.bundleIdentifier == "com.apple.finder" }
    }

    private static func desktopURL() -> URL {
        FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Desktop", isDirectory: true)
    }
}
