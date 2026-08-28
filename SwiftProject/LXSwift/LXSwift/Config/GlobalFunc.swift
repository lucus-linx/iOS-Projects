//
//  GlobalFunc.swift
//  LXSwift
//
//  Created by 启业云03 on 2020/6/8.
//  Copyright © 2020 LX. All rights reserved.
//
//  Swift 支持全局函数

import UIKit

// MARK: - 封装的日志输出功能（T表示不指定日志信息参数类型）

///
/// - Parameters:
///   - message:
///   - file: 文件名
///   - function: 方法名
///   - line: 行数
func Log<T>(_ message:T, file:String = #file, function:String = #function, line:Int = #line) {
    #if DEBUG
    // 获取文件名
    let fileName = (file as NSString).lastPathComponent
    // 打印日志内容
    print("File:\(fileName), Line:\(line), Function:\(function), \(message)")
    #endif
}

/// 更具多信息的日志输出
func DLog<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    // 获取文件名
    let fileName = (file as NSString).lastPathComponent
    // 创建一个日期格式器
    let dformatter = DateFormatter()
    // 为日期格式器设置格式字符串
    dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    // 使用日期格式器格式化当前日期、时间
    let datestr = dformatter.string(from: Date())
    // 打印日志内容
    print("***** log start *****")
    print(datestr)
    print("File:\(fileName), Line:\(line), Function:\(function)")
    print(message)
    print("*****  log end  *****")
    #endif
}

