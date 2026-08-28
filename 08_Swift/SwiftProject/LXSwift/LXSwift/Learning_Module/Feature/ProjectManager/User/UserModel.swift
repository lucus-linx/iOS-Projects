//
//  UserModel.swift
//  LXSwift
//
//  Created by 林祥 on 2021/2/5.
//  Copyright © 2021 LX. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserModel: Codable {
    var username: String
    var password: String
    var verifyCode: String
    
    // initialize
    init(username: String = "default username",
         password: String = "default password",
         verifyCode: String = "default verifyCode") {
        self.username = username
        self.password = password
        self.verifyCode = verifyCode
    }
    
    init(_ jsonData: JSON) {
        username = jsonData["username"].stringValue
        password = jsonData["password"].stringValue
        verifyCode = jsonData["verifyCode"].stringValue
    }
}
