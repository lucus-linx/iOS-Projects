//
//  SwiftDate.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/2/24.
//  Copyright © 2021 LX. All rights reserved.
//

import UIKit

class DateUsage: NSObject {
    
    static var shared: DateUsage = {
        let instance = DateUsage()
        return instance
    }()
    
    func Cocoa_Date() {
        // 类方法
        Log("2001年1月1日世界标准时间00:00:00与当前日期和时间之间的间隔（类方法）：\(Date.timeIntervalSinceReferenceDate)")
        Log("从1970年1月1日到参考日期2001年1月1日的秒数（类方法）：\(Date.timeIntervalBetween1970AndReferenceDate)")
        
        // 初始化
        let date1 = Date()
        let date2 = Date.init()
        let date3 = Date.init(timeInterval: 600, since: date1)
        let date4 = Date.init(timeIntervalSince1970: 600)
        let date5 = Date.init(timeIntervalSinceReferenceDate: 600)
        let date6 = Date.init(timeIntervalSinceNow: 600)
        Log("初始化1：当前标准时间：       \(date1.description)")
        Log("初始化2：当前标准时间：       \(date2.description)")
        Log("初始化3：自日期对象后600秒：   \(date3.description)")
        Log("初始化4：自1970.1.1后600秒： \(date4.description)")
        Log("初始化5：自2001.1.1后600秒： \(date5.description)")
        Log("初始化6：自当前时间后600秒：   \(date6.description)")
        
        // 对象方法
        let date = Date().addingTimeInterval(20)
        Log("日期对象与1970年1月1日世界标准时间00:00:00之间的间隔：\(date.timeIntervalSince1970)")
        Log("日期对象与2001年1月1日世界标准时间00:00:00之间的间隔：\(date.timeIntervalSinceReferenceDate)")
        
        let dateCom = DateComponents.init()
        Log("\(String(describing: dateCom.date?.description))")
    }
    
}

/// Singletons should not be cloneable.
extension DateUsage: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}



class DateUsageVC: UIViewController {
    override func viewDidLoad() {
        self.title = "Date与SwiftDate日常使用"
        self.view.backgroundColor = .white
        
        DateUsage.shared.Cocoa_Date()
        
    }
    
    deinit {
        
    }
}

