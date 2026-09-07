//
//  PathFormattingTests.swift
//  Lucus-FinderTests
//
//  Created by 启业云03 on 2026/8/28.
//

import Testing
import Foundation
@testable import Lucus_Finder

/// 纯格式化函数测试（fileName / baseName / 终端与 AppleScript 转义）。
struct PathFormattingTests {

    @Test func fileNameAndBaseName() {
        let url = URL(fileURLWithPath: "/Users/qiyeyun/Desktop/report.md")
        #expect(PathFormatting.fileName(url) == "report.md")
        #expect(PathFormatting.baseName(url) == "report")
    }

    @Test func dotfileKeepsName() {
        let url = URL(fileURLWithPath: "/Users/qiyeyun/.gitignore")
        #expect(PathFormatting.fileName(url) == ".gitignore")
        // 点文件的"无后缀"就是它自己（不应被误删）
        #expect(PathFormatting.baseName(url) == ".gitignore")
    }

    @Test func fileURLEncodesSpaces() {
        let url = URL(fileURLWithPath: "/Users/qiyeyun/My Folder/a.txt")
        #expect(PathFormatting.fileURLString(url).hasPrefix("file://"))
        #expect(PathFormatting.fileURLString(url).contains("%20"))
    }

    @Test func shellSingleQuotePlain() {
        #expect(PathFormatting.shellSingleQuote("/Users/a b/c") == "'/Users/a b/c'")
    }

    @Test func shellSingleQuoteEscapesApostrophe() {
        // 路径里的单引号要转成 '\'' 以保持 shell 单引号配对
        #expect(PathFormatting.shellSingleQuote("/Users/o'brien/x") == "'/Users/o'\\''brien/x'")
    }

    @Test func appleScriptLiteralWrapsAndEscapes() {
        #expect(PathFormatting.appleScriptStringLiteral("/plain/path") == "\"/plain/path\"")
        // 内嵌双引号需转义
        #expect(PathFormatting.appleScriptStringLiteral("ab\"c") == "\"ab\\\"c\"")
        // 反斜杠需转义
        #expect(PathFormatting.appleScriptStringLiteral("a\\b") == "\"a\\\\b\"")
    }
}
