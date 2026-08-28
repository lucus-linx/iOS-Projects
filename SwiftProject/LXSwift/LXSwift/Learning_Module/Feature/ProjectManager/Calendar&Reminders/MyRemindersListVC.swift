//
//  MyRemindersListVC.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/2/25.
//  Copyright © 2021 LX. All rights reserved.
//
//  提醒事项列表

import UIKit
import EventKit
import SVProgressHUD

class MyRemindersListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //
    var tableView: UITableView!
    //
    var eventStore: EKEventStore!
    // 数据源
    var reminders: [EKReminder]!
    
    
    override func viewDidLoad() {
        title = "我的提醒"
        view.backgroundColor = .white
        
        // 导航栏左侧按钮
        let rightBarButtonItem1 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonItemClick(sender:)))
        rightBarButtonItem1.tag = 100
        let rightBarButtonItem2 = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(barButtonItemClick(sender:)))
        rightBarButtonItem2.tag = 101
        let rightBarButtonItem3 = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(barButtonItemClick(sender:)))
        rightBarButtonItem3.tag = 102
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem1, rightBarButtonItem2, rightBarButtonItem3]
        
        // 初始化
        eventStore = EKEventStore()
        reminders = [EKReminder]()
        
        //创建表视图
        tableView = UITableView(frame: self.view.frame, style:.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(self.tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 申请权限，异步运行
        eventStore.requestAccess(to: .reminder) { (granted, error) in
            if granted && (error == nil) {
                // SVProgressHUD.lx_showSuccess("授权成功")
                // 获取所有提醒事项
                let predicate = self.eventStore.predicateForReminders(in: nil)
                self.eventStore.fetchReminders(matching: predicate) { (results: [EKReminder]?) in
                    Log("result = \(String(describing: results?.count))")
                    self.reminders = results
                    // 主线程
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else if !granted && (error == nil) {
                let alertVC = UIAlertController(title: "提示", message: "请在iPhone的\"设置->隐私->日历\"选项中,允许APP 访问你的日历。", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let sureAction = UIAlertAction(title: "设置", style: .default, handler: { (action) in
                    //跳转到系统设置主页
                    OpenURL(urlString: UIApplication.openSettingsURLString)
                })
                alertVC.addAction(cancelAction)
                alertVC.addAction(sureAction)
                self.present(alertVC, animated: true, completion: nil)
            } else {
                SVProgressHUD.lx_showSuccess("授权失败：\(String(describing: error))")
            }
        }
    }
    
    deinit {
        Log("")
    }

    // MARK: - ========== UI ==========

    // MARK: - ====== Actions ======
    @objc func barButtonItemClick(sender:UIBarButtonItem) {
        if sender.tag == 100 {
            // 新建提醒事项页面
            let VC = NewReminderVC()
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(VC, animated: true)
            self.hidesBottomBarWhenPushed = true
        } else if sender.tag == 101 {
            // 清理全部
            ReminderManager.shared.removeAllReminder()
            // 重新加载
            ReminderManager.shared.getAllReminders { (isSucc, array) in
                if isSucc {
                    self.reminders = array
                    // 主线程
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    self.reminders.removeAll()
                    // 主线程
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        } else if sender.tag == 102 {
            // 重新加载
            ReminderManager.shared.getAllReminders { (isSucc, array) in
                if isSucc {
                    self.reminders = array
                    // 主线程
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - ========== Delegate ==========
    //在本例中，只有一个分区
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminders.count
    }
         
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "myCell")
        let reminder:EKReminder! = self.reminders![indexPath.row]
         
        //提醒事项的内容
        cell.textLabel?.text = reminder.title
         
        //提醒事项的时间
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        if let dueDate = reminder.dueDateComponents?.date {
            cell.detailTextLabel?.text = formatter.string(from: dueDate)
            if ((reminder.notes?.isEmpty) != nil) {
                cell.detailTextLabel?.text! += "   " + reminder.notes!
            }
        } else {
            cell.detailTextLabel?.text = "N/A   "
            cell.detailTextLabel?.text! += reminder.notes ?? ""
        }
        
        // 是否已经完成
        if reminder.isCompleted {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 设置完成状态
        let reminder: EKReminder = reminders[indexPath.row]
        reminder.isCompleted = !reminder.isCompleted
        do {
            try self.eventStore.save(reminder, commit: true)
            self.tableView .reloadRows(at: [indexPath], with: .automatic)
        } catch {
              Log("Error creating and saving new reminder : \(error)")
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // 删除操作
        return UITableViewCell.EditingStyle.delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let reminder: EKReminder = reminders[indexPath.row]
        do {
            try eventStore.remove(reminder, commit: true)
            self.reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        } catch {
            SVProgressHUD.lx_showError("提醒移除失败")
        }
    }
}
