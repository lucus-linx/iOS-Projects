//
//  Height_Width.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/4/8.
//  Copyright © 2021 LX. All rights reserved.
//
//  获取宽高

import UIKit

var LX_Window: UIWindow? {
    get {
        if let app = UIApplication.shared.delegate as? AppDelegate {
            return app.window
        }
        return nil
    }
}


/*
 iOS 13以前，全面屏的状态栏高度为44
 从iOS 14开始，全面屏iPhone的状态栏高度不一定是44了
 
    设备(>iOS 13)                             状态栏高度
 iPhone XR | 11                                 48
 iPhone X  | 11 Pro | 11 Pro Max | 12 mini      44
 iPhone 12 | 12 Pro | 12 Pro Max                47
 */
func getStatusBarHeight() -> CGFloat {
    var statusBarHeight: CGFloat = 0.0
    if #available(iOS 13.0, *) {
        let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
        statusBarHeight = statusBarManager?.statusBarFrame.size.height ?? CGRect.zero.height
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statusBarHeight
}


/// 判断是否为全面屏
/// 方法一（不完美）：根据状态栏高度判读，弊端：隐藏状态栏时，高度为0
/// - Returns: true / false
func isFullScreen() -> Bool {
    let statusBarH = getStatusBarHeight()
    if statusBarH > 20 {
        return true
    }
    return false;
}




/// 测试视图
class SafeAreaTestVC: UIViewController {
    override func viewDidLoad() {
        title = "UI测试"
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        Log("\(isFullScreen())")
        
    }
    
    deinit {
        
    }
    
}



public class QYCUtility: NSObject {
    
    /*
     iOS 13以前，全面屏的状态栏高度为44
     从iOS 14开始，全面屏iPhone的状态栏高度不一定是44了
     
     设备(>iOS 13)                                状态栏高度
     iPhone XR | 11                                 48
     iPhone X  | 11 Pro | 11 Pro Max | 12 mini      44
     iPhone 12 | 12 Pro | 12 Pro Max                47
     */
    /// 获取状态栏高度
    @objc public class func StatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0.0
        if #available(iOS 13.0, *) {
            let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
            statusBarHeight = statusBarManager?.statusBarFrame.size.height ?? CGRect.zero.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    /// 屏幕宽高
    @objc public class func ScreenH() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    @objc public class func ScreenW() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// 判断是否为IPhoneX系列
    /// 方法：iPhone刘海屏系列 竖屏高宽比约等于216，横屏高宽比约等于46
    @objc public class func ISIPhoneXSeries() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return false
        }
        let size = UIScreen.main.bounds.size
        let notchValue: Int = Int(size.width / size.height * 100)
        if 216 == notchValue || 46 == notchValue {
            return true
        }
        return false
    }
}
