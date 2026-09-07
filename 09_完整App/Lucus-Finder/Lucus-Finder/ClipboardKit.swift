//
//  ClipboardKit.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import AppKit

/// 剪贴板封装。
enum ClipboardKit {
    @MainActor
    static func copy(_ string: String) {
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(string, forType: .string)
        print("[Lucus] 已复制：\(string)")
    }
}
