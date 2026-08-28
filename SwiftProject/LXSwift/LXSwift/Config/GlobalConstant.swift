//
//  GlobalConstant.swift
//  LXSwift
//
//  Created by 启业云03 on 2020/6/8.
//  Copyright © 2020 LX. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

// 样例
struct Constants {
    static let someNotification = "TEST"
}

struct APPURL {
    private struct Domains {
        static let Local = "http://localhost:8081/"
        static let Dev = "http://test-dev.cloudapp.net"
        static let UAT = "http://test-UAT.com"
        static let QA = "testAddress.qa.com"
    }

    private struct Routes {
        static let Api = "/api/mobile"
    }

    private static let Domain = Domains.Dev
    private static let Route = Routes.Api
    private static let BaseURL = Domain + Route

    static var FacebookLogin: String {
        return BaseURL  + "/auth/facebook"
    }
}

struct ProjectManagerURL {
    private struct Domains {
        static let Local_home = "http://localhost:8080/QYCManager_war_exploded"
        static let Local_work = "http://localhost:8081/QYCManager_war_exploded"
        static let remote_Lan = "http://10.0.16.46:8081/QYCManager_war"
        static let remote_Wan = "http://p6maky.natappfree.cc/QYCManager_war"
    }
    private struct Routes {
        static let Api_User = "/user"
        static let Api_Proj = "/project"
    }
    
    private static let Domain = { () -> String in
        // 读取Defaults
        let domain = Defaults.projectManagerDomain
        if domain.isEmpty {
            // 更新Defaults
            Defaults.projectManagerDomain = Domains.remote_Wan
            return Defaults.projectManagerDomain
        }
        return domain
    }()
    
    // URL
    static var BaseURL_User: String {
        return Domain + Routes.Api_User
    }
    static var BaseURL_Proj: String {
        return Domain + Routes.Api_Proj
    }
}


// 三方的key，例如：百度key，融云key
struct VendorKey {
    static let DoraemonKit_Key = "809c3ab8a549f6f1630dd34a9399ae68"
}

// 常用沙盒路径
struct Global_Path {
    static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    static let Temp = NSTemporaryDirectory()
}

// 通知 Key
struct Global_NotificationKey {
    static let k_refresh_ProjectManagerMainVC = "k_refresh_ProjectManagerMainVC"
}

// UserDefaults Key
struct Global_UserDefaultsKey {
    // 是否为第一次登录
    static let k_App_Running_FirstTime = "userRunningAppFirstTime"
    // 记录登录状态
    static let k_ISLogin = "isLogin"
}

//ColorConstants.swift
struct Global_AppColor {
    private struct Alphas {
        static let Opaque = CGFloat(1)
        static let SemiOpaque = CGFloat(0.8)
        static let SemiTransparent = CGFloat(0.5)
        static let Transparent = CGFloat(0.3)
    }

    static let appPrimaryColor =  UIColor.white.withAlphaComponent(Alphas.SemiOpaque)
    static let appSecondaryColor =  UIColor.blue.withAlphaComponent(Alphas.Opaque)

    struct TextColors {
        static let Error = Global_AppColor.appSecondaryColor
        static let Success = UIColor(red: 0.1303, green: 0.9915, blue: 0.0233, alpha: Alphas.Opaque)
    }

    struct TabBarColors{
        static let Selected = UIColor.white
        static let NotSelected = UIColor.black
    }

    struct OverlayColor {
        static let SemiTransparentBlack = UIColor.black.withAlphaComponent(Alphas.Transparent)
        static let SemiOpaque = UIColor.black.withAlphaComponent(Alphas.SemiOpaque)
        static let demoOverlay = UIColor.black.withAlphaComponent(0.6)
    }
}

// 杂七杂八 Key
struct Global_Key {
    static let DeviceType = "iOS"
    struct Beacon{
        static let ONEXUUID = "xxxx-xxxx-xxxx-xxxx"
    }

    struct Headers {
        static let Authorization = "Authorization"
        static let ContentType = "Content-Type"
    }
    struct Google{
        static let placesKey = "some key here"//for photos
        static let serverKey = "some key here"
    }

    struct ErrorMessage{
        static let listNotFound = "ERROR_LIST_NOT_FOUND"
        static let validationError = "ERROR_VALIDATION"
    }
}
