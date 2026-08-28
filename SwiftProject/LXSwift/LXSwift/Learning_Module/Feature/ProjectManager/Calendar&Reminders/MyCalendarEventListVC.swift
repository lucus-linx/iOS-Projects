//
//  MyCalendarEventListVC.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/2/26.
//  Copyright © 2021 LX. All rights reserved.
//

import UIKit

class MyCalendarEventListVC: UIViewController {
    override func viewDidLoad() {
        
    }
    
    deinit {
        
    }
    
    /*
    func p_addCalendarEvent() -> Bool {
        // 1.申请权限
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && (error == nil) {
                Log("granted = \(granted)")
                Log("error = \(String(describing: error))")
                // 新建一个事件
                let event: EKEvent = EKEvent(eventStore: self.eventStore)
                event.title = "新增一个测试事件"
                event.startDate = Date()
                event.endDate = Date()
                event.notes = "这是个备注"
     
     let alarmTime = Date().addingTimeInterval(10)
     let alarm = EKAlarm(absoluteDate: alarmTime)
                event.calendar = self.eventStore.defaultCalendarForNewReminders()  //defaultCalendarForNewEvents
                do {
                    try self.eventStore.save(event, span: .thisEvent)
                    Log("Saved Event")
                } catch let err {
                    Log("异常:\(err)")
                }
                // 获取所有的事件（前后90天）
                let startDate = Date().addingTimeInterval(-3600*24*90)
                let endDate = Date().addingTimeInterval(3600*24*90)
                let predicate2 = self.eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
                print("查询范围 开始:\(startDate) 结束:\(endDate)")
                if let eV = self.eventStore.events(matching: predicate2) as [EKEvent]? {
                    for i in eV {
                        print("标题  \(i.title)" )
                        print("开始时间: \(i.startDate)" )
                        print("结束时间: \(i.endDate)" )
                    }
                }
            } else {
            }
        }
     }
     */
        
}
