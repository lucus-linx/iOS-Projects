//
//  ReminderManager.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/3/11.
//  Copyright © 2021 LX. All rights reserved.
//

import Foundation
import EventKit
import SVProgressHUD

class ReminderManager: NSObject {
    //
    var eventStore: EKEventStore!
    // 数据源
    var reminders: [EKReminder]!
    
    public typealias getRemindersBlock = (_ isSucc: Bool, [EKReminder]?) -> Void

    
    static var shared: ReminderManager = {
        let instance = ReminderManager()
        return instance
    }()
    
    override init() {
        // 初始化
        eventStore = EKEventStore()
        reminders = [EKReminder]()
    }
    
    /// 获取所有提醒
    /// - Parameter completion11: 回调
    func getAllReminders(completion11: @escaping getRemindersBlock) {
        // 申请权限，异步运行
        eventStore.requestAccess(to: .reminder) { (granted, error) in
            if granted && (error == nil) {
                // 获取所有提醒事项
                let predicate = self.eventStore.predicateForReminders(in: nil)
                self.eventStore.fetchReminders(matching: predicate) { (results: [EKReminder]?) in
                    completion11(true, results)
                }
            } else if !granted && (error == nil) {
                SVProgressHUD.lx_showError("请前往设置打开权限")
                completion11(false, nil)
            } else {
                SVProgressHUD.lx_showError("授权失败：\(String(describing: error))")
                completion11(false, nil)
            }
        }
    }
    
    func addReminder(model: ProjectModel) {
        // 新建一个事件
        let reminder:EKReminder = EKReminder(eventStore: self.eventStore)
        reminder.title = model.app_name
        reminder.priority = 2  // 优先级
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // TF过期时间，90天过期
        let updateDate = dateFormatter.date(from: model.ios_update_time)
        let nextTime: TimeInterval = TimeInterval(24*60*60*90)  // 这是90天后的时间
        let expiredDate = updateDate?.addingTimeInterval(nextTime)
        // Create Date Formatter
        let dateFormatter1 = DateFormatter()
        // Set Date Format
        dateFormatter1.dateFormat = "yyyy/MM/dd"
        // Convert Date to String
        reminder.notes = "TF到期时间：" + dateFormatter1.string(from: expiredDate!)
        // 设置提醒日期为，TF到期前三天
        let nextTime1: TimeInterval = TimeInterval(24*60*60*87)  // 这是87天后的时间
        let expiredDate1 = updateDate!.addingTimeInterval(nextTime1)
        let cal = Calendar.current
        let dueDateComponents = cal.dateComponents([.minute, .hour, .day, .month, .year], from: expiredDate1)
        reminder.dueDateComponents = dueDateComponents
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        // 重置
        reminder.isCompleted = false
        do {
            try self.eventStore.save(reminder, commit: true)
        } catch {
            SVProgressHUD.lx_showError("新增提醒失败")
        }
    }
    
    func updateReminder(reminder: EKReminder, updateTime: String) {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // TF过期时间，90天过期
        let updateDate = dateFormatter.date(from: updateTime)
        let nextTime: TimeInterval = TimeInterval(24*60*60*90)  // 这是90天后的时间
        let expiredDate = updateDate?.addingTimeInterval(nextTime)
        // Create Date Formatter
        let dateFormatter1 = DateFormatter()
        // Set Date Format
        dateFormatter1.dateFormat = "yyyy/MM/dd"
        // Convert Date to String
        reminder.notes = "TF到期时间：" + dateFormatter1.string(from: expiredDate!)
        // 设置提醒日期为，TF到期前三天
        let nextTime1: TimeInterval = TimeInterval(24*60*60*87)  // 这是87天后的时间
        let expiredDate1 = updateDate!.addingTimeInterval(nextTime1)
        let cal = Calendar.current
        let dueDateComponents = cal.dateComponents([.minute, .hour, .day, .month, .year], from: expiredDate1)
        reminder.dueDateComponents = dueDateComponents
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        // 重置
        reminder.isCompleted = false
        do {
            try self.eventStore.save(reminder, commit: true)
        } catch {
            SVProgressHUD.lx_showError("更新提醒失败")
        }
    }
    
    func removeAllReminder() {
        ReminderManager.shared.getAllReminders { (isSucc, array) in
            if isSucc {
                array?.forEach({ (reminder) in
                    do {
                        try self.eventStore.remove(reminder, commit: true)
                    } catch {
                        SVProgressHUD.lx_showError("移除提醒失败")
                    }
                })
            }
        }
    }
    
}

/// Singletons should not be cloneable.
extension ReminderManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
