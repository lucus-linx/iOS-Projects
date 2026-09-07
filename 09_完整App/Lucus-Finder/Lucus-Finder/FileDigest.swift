//
//  FileDigest.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import Foundation
import CryptoKit

/// 文件校验和。分块增量计算，避免大文件一次性整进内存。
/// 沙盒认知：NSServices 回调里读取"用户选中"的文件是被隐式授权的，
/// 因此必须在回调当场算完，不能存路径稍后再读。
enum FileDigest {

    @MainActor
    static func md5Hex(of url: URL) -> String? {
        guard let handle = try? FileHandle(forReadingFrom: url) else { return nil }
        defer { try? handle.close() }
        var hasher = Insecure.MD5()
        appendChunks(from: handle) { hasher.update(data: $0) }
        return hex(hasher.finalize())
    }

    @MainActor
    static func sha256Hex(of url: URL) -> String? {
        guard let handle = try? FileHandle(forReadingFrom: url) else { return nil }
        defer { try? handle.close() }
        var hasher = SHA256()
        appendChunks(from: handle) { hasher.update(data: $0) }
        return hex(hasher.finalize())
    }

    private static func appendChunks(from handle: FileHandle, update: (Data) -> Void) {
        while true {
            guard let chunk = try? handle.read(upToCount: 1 << 20), !chunk.isEmpty else { break }
            update(chunk)
        }
    }

    private static func hex(_ digest: some Sequence<UInt8>) -> String {
        digest.map { String(format: "%02x", $0) }.joined()
    }
}
