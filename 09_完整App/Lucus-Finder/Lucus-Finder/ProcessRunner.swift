//
//  ProcessRunner.swift
//  Lucus-Finder
//
//  Created by 启业云03 on 2026/8/28.
//

import Foundation

/// 极简外部进程运行器：沙盒 App 可以 spawn 子进程（继承自身沙盒）。
enum ProcessRunner {

    /// 异步运行，完成后在主线程回调退出码。用于需要感知成功/失败的场景。
    @MainActor
    static func runAsync(executable: URL,
                         arguments: [String],
                         completion: @escaping @MainActor (Int32) -> Void) {
        let p = Process()
        p.executableURL = executable
        p.arguments = arguments
        p.terminationHandler = { proc in
            let code = proc.terminationStatus
            Task { @MainActor in completion(code) }
        }
        do {
            try p.run()
        } catch {
            print("[Lucus] 无法运行 \(executable.path)：\(error)")
            completion(-1)
        }
    }

    /// 直接运行并忘记（fire-and-forget）。
    @MainActor
    static func run(executable: URL, arguments: [String]) {
        let p = Process()
        p.executableURL = executable
        p.arguments = arguments
        do {
            try p.run()
        } catch {
            print("[Lucus] 无法运行 \(executable.path)：\(error)")
        }
    }
}
