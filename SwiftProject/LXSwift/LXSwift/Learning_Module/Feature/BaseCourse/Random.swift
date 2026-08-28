//
//  Random.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/1/29.
//  Copyright © 2021 LX. All rights reserved.
//
//  随机数生成

import Foundation

/// 获取随机Bool值
/// - Returns: true / false
func LX_RandomBool() -> Bool {
    // 取[0,2)随机数
    let num = arc4random() % 2
    if num == 1 {
        return true
    }
    return false
}

