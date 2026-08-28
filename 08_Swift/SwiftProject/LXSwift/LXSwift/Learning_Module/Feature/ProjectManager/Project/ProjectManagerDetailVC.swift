//
//  ProjectManagerDetailVC.swift
//  LXSwift
//
//  Created by 林祥 on 2021/2/19.
//  Copyright © 2021 LX. All rights reserved.
//

import UIKit
import EventKit
import Toast_Swift
import SVProgressHUD

class ProjectManagerDetailVC: UIViewController {
    // 外部属性传值
    var model: ProjectModel!
    // Cell ID
    private static let identifier = "ProjectManagerDetailVC_CellId"
    // 日历对象
    let eventStore = EKEventStore()
    
    
    // MARK: - ========== LifeCycle ==========
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.title = model.project_name
        
        // TestFlight发布90天过期，需要及时通知
        // 1.进入详情页，本地通知；
        // 2.右上角按钮，设置日历通知。
        if model.ios_release_platform == "TestFlight" {
            setUpNaviBtn()
        }
        setUpTableView()
    }

    deinit {
        Log("")
    }
    
    // MARK: - ========== UI ==========
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        // Set layout for tableView.
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    func setUpNaviBtn() {
        // 导航栏右侧侧按钮
        let rightBarButtonItem1 = UIBarButtonItem(title: "新建提醒", style: .plain, target: self, action: #selector(barButtonItemClick(sender:)))
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem1]
    }
    
    // MARK: - ====== Actions ======
    @objc func barButtonItemClick(sender:UIBarButtonItem) {
        // 添加提醒事项
        p_addReminder()
    }
    
    // MARK: - ========== Private ==========
    func p_addReminder() {
        // 1.申请权限
        eventStore.requestAccess(to: .reminder) { (granted, error) in
            if granted && (error == nil) {
                Log("granted = \(granted)")
                Log("error = \(String(describing: error))")
                // 新建一个事件
                let reminder:EKReminder = EKReminder(eventStore: self.eventStore)
                reminder.title = self.model.app_name
                reminder.priority = 2  // 优先级
                // TF过期时间，90天过期
                let updateDate = self.p_stringConvertDate(string: self.model.ios_update_time)
                let nextTime: TimeInterval = TimeInterval(24*60*60*90)  // 这是90天后的时间
                let expiredDate = updateDate.addingTimeInterval(nextTime)
                // Create Date Formatter
                let dateFormatter = DateFormatter()
                // Set Date Format
                dateFormatter.dateFormat = "yyyy/MM/dd"
                // Convert Date to String
                reminder.notes = "TF到期时间：" + dateFormatter.string(from: expiredDate)
                // 设置提醒日期为，TF到期前三天
                let nextTime1: TimeInterval = TimeInterval(24*60*60*87)  // 这是87天后的时间
                let expiredDate1 = updateDate.addingTimeInterval(nextTime1)
                let dueDateComponents = self.p_dateComponentFromNSDate(date: expiredDate1)
                reminder.dueDateComponents = dueDateComponents
                reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
                do {
                    try self.eventStore.save(reminder, commit: true)
                    DispatchQueue.main.async {
                        // 设置成功，进入提醒列表页
                        let VC = MyRemindersListVC()
                        self.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(VC, animated: true)
                        self.hidesBottomBarWhenPushed = true
                    }
                } catch {
                    SVProgressHUD.lx_showError("设置提醒事项失败！")
                }
            } else {
                Log("未授权")
            }
        }
        
    }
    
    func p_stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)
        return date!
    }
    
    // 根据NSDate获取对应的DateComponents对象
    func p_dateComponentFromNSDate(date: Date)-> DateComponents{
        let cal = Calendar.current
        let dateComponents = cal.dateComponents([.minute, .hour, .day, .month, .year], from: date)
        return dateComponents
    }

    // MARK: - ========== Set&Get ==========
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        // separator
        tv.separatorStyle = .none //.singleLine
        tv.separatorColor = UIColor.orange
        
        tv.estimatedRowHeight = 50
        tv.estimatedSectionHeaderHeight = 0
        tv.estimatedSectionFooterHeight = 0
        
        tv.rowHeight = UITableView.automaticDimension
        
        tv.tableHeaderView = UIView()
        tv.tableFooterView = UIView()
        
        // register
        tv.register(UITableViewCell.self, forCellReuseIdentifier: ProjectManagerDetailVC.identifier)
        return tv
    }()
}


/// 代理扩展
extension ProjectManagerDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        } else if section == 1 {
            return 8
        } else if section == 2 {
            return 7
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init(frame: .init(x: 0, y: 0, width: 10, height: 100))
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //declare a tableViewCell as an implicitly unwrapped optional...
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: ProjectManagerDetailVC.identifier)

        //you CAN check this against nil, if nil then create a cell (don't redeclare like you were doing...
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default ,
                                   reuseIdentifier:ProjectManagerDetailVC.identifier)
        }
        // 附件视图
        cell.accessoryType = .none
        cell.backgroundColor = Specs.color.white
        cell.textLabel?.textColor = Specs.color.black
        
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.textLabel?.text = "项目名:" + model.project_name
        } else if indexPath.section == 0 && indexPath.row == 1 {
            cell.textLabel?.text = "项目经理：" + model.project_manager
        } else if indexPath.section == 0 && indexPath.row == 2 {
            cell.textLabel?.text = "项目创建时间：" + model.project_create_time
        } else if indexPath.section == 0 && indexPath.row == 3 {
            cell.textLabel?.text = "app名称：" + model.app_name
        } else if indexPath.section == 0 && indexPath.row == 4 {
            cell.textLabel?.text = "app类型：" + model.ios_android
        } else if indexPath.section == 0 && indexPath.row == 5 {
            cell.textLabel?.text = "测试账号：" + model.test_account
        }
        
        else if indexPath.section == 1 && indexPath.row == 0 {
            cell.textLabel?.text = "iOS开发：" + model.ios_manager
        } else if indexPath.section == 1 && indexPath.row == 1 {
            cell.textLabel?.text = "iOS分支：" + model.ios_branch
        } else if indexPath.section == 1 && indexPath.row == 2 {
            cell.textLabel?.text = "iOS发布平台：" + model.ios_release_platform
        } else if indexPath.section == 1 && indexPath.row == 3 {
            cell.textLabel?.text = "iOS更新时间：" + model.ios_update_time
        } else if indexPath.section == 1 && indexPath.row == 4 {
            cell.textLabel?.text = "iOS下载地址：" + model.ios_download
            cell.accessoryType = .detailButton
        } else if indexPath.section == 1 && indexPath.row == 5 {
            cell.textLabel?.text = "iOS定制：" + model.ios_custom_made
        } else if indexPath.section == 1 && indexPath.row == 6 {
            cell.textLabel?.text = "iOS迭代：" + model.ios_feature
        } else if indexPath.section == 1 && indexPath.row == 7 {
            cell.textLabel?.text = "苹果账号相关：" + model.apple_account_password_owner
            cell.accessoryType = .disclosureIndicator
        }
        
        else if indexPath.section == 2 && indexPath.row == 0 {
            cell.textLabel?.text = "Android开发：" + model.android_manager
        } else if indexPath.section == 2 && indexPath.row == 1 {
            cell.textLabel?.text = "Android分支：" + model.android_branch
        } else if indexPath.section == 2 && indexPath.row == 2 {
            cell.textLabel?.text = "Android发布平台：" + model.android_release_platform
        } else if indexPath.section == 2 && indexPath.row == 3 {
            cell.textLabel?.text = "Android更新时间：" + model.android_update_time
        } else if indexPath.section == 2 && indexPath.row == 4 {
            cell.textLabel?.text = "Android下载地址：" + model.android_download
            cell.accessoryType = .detailButton
        } else if indexPath.section == 2 && indexPath.row == 5 {
            cell.textLabel?.text = "Android定制：" + model.android_custom_made
        } else if indexPath.section == 2 && indexPath.row == 6 {
            cell.textLabel?.text = "Android迭代：" + model.android_feature
        }
        else {
            cell.textLabel?.text = "\(indexPath.row)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)

        if indexPath.section == 1 && indexPath.row == 4 {
            OpenURL(urlString: model.ios_download)
        }
        if indexPath.section == 1 && indexPath.row == 7 {
            let alertVC = UIAlertController.init(title: "苹果账号", message: model.apple_account_password_owner, preferredStyle: .alert)
            let action = UIAlertAction(title: "知道了", style: .cancel)
            alertVC.addAction(action)
            self.present(alertVC, animated: true, completion: nil)
        }
        if indexPath.section == 2 && indexPath.row == 4 {
            OpenURL(urlString: model.android_download)
        }
     
        // 复制到剪切板
        UIPasteboard.general.string = cell?.textLabel?.text
        self.view.makeToast("复制到剪切板", duration: 1.0, position: .bottom)
    }
    
}
