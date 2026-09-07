//
//  PathFormatting.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import Foundation

/// 纯字符串/URL 格式化工具。全部 nonisolated，便于单测与在任何上下文使用。
enum PathFormatting {

    /// 文件名（含扩展名）
    nonisolated static func fileName(_ url: URL) -> String {
        url.lastPathComponent
    }

    /// 文件名（不含扩展名）。注意 `.gitignore` 这类点文件应原样返回。
    nonisolated static func baseName(_ url: URL) -> String {
        url.deletingPathExtension().lastPathComponent
    }

    /// 绝对 file:// 链接字符串（空格等会自动百分号编码）。
    nonisolated static func fileURLString(_ url: URL) -> String {
        url.absoluteString
    }

    /// 把 POSIX 路径包成 shell 单引号字符串：路径里的 `'` 转义为 `'\''`。
    /// 用于 `cd '路径'` 这类终端命令。
    nonisolated static func shellSingleQuote(_ s: String) -> String {
        "'" + s.replacingOccurrences(of: "'", with: "'\\''") + "'"
    }

    /// 转义成可嵌入 AppleScript 双引号字符串字面量的内容（含两侧双引号）。
    nonisolated static func appleScriptStringLiteral(_ s: String) -> String {
        let escaped = s
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
        return "\"\(escaped)\""
    }
}
