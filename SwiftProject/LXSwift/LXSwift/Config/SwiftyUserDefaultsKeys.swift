//
//  SwiftyUserDefaultsKeys.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/2/23.
//  Copyright © 2021 LX. All rights reserved.
//

import SwiftyUserDefaults

// 扩展 自定义Key
extension DefaultsKeys {
    // 用户名、密码
    var username: DefaultsKey<String?> { .init("username") }
    var password: DefaultsKey<String?> { .init("password") }
    // 启动次数，默认：0
    var launchCount: DefaultsKey<Int> { .init("launchCount", defaultValue: 0) }
    // 项目管理模块Domain
    var projectManagerDomain: DefaultsKey<String> { .init("projectManagerDomain", defaultValue: "") }

}
