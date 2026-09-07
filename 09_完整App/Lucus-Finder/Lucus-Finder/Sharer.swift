//
//  Sharer.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import AppKit

/// 系统分享封装。
@MainActor
enum Sharer {

    /// 把选中的文件通过隔空投送分享。必须在服务回调里当场调用（文件读权限只在回调期有效）。
    static func airDrop(urls: [URL]) {
        guard let service = NSSharingService(named: .sendViaAirDrop) else {
            print("[Lucus] 当前设备/系统不支持 AirDrop")
            return
        }
        let items: [Any] = urls
        guard service.canPerform(withItems: items) else {
            print("[Lucus] 所选文件无法通过 AirDrop 分享（可能缺少读权限或类型不支持）")
            return
        }
        // accessory 态下先激活本 App，让 AirDrop 面板能正常弹出。
        NSApp.activate(ignoringOtherApps: true)
        service.perform(withItems: items)
    }
}
