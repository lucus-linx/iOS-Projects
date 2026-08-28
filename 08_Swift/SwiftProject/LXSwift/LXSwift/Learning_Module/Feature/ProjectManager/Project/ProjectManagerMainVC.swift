//
//  ProjectManagerMainVC.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/1/29.
//  Copyright © 2021 LX. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD
import Alamofire

class ProjectManagerMainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // Cell ID
    private static let identifier = "CellId"
    // MJ顶部刷新
    private let header = MJRefreshNormalHeader()
    // MJ底部刷新
    private let footer = MJRefreshAutoNormalFooter()
    // 数据源
    private var dataSource = [ProjectModel]()
    //
    private var currentPage: Int = 0
    // 排序规则
    private var sortType: ComparisonResult = .orderedDescending
    
    // MARK: - ========== LifeCycle ==========
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.title = "项目管理列表"
        
        // 导航栏
        setUpBarButtonItem()
        
        // tableView
        setUpTableView()
        
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(p_headerRefresh))
        tableView.mj_header = header
        // 上拉加载
        footer.setRefreshingTarget(self, refreshingAction: #selector(p_footerRefresh))
        tableView.mj_footer = footer
        
        // 开始加载数据
        header.beginRefreshing()
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(p_reloadVC), name: NSNotification.Name( rawValue:Global_NotificationKey.k_refresh_ProjectManagerMainVC), object: nil)
    }

    deinit {
        Log("")
    }
    
    // MARK: - ========== UI ==========
    func setUpBarButtonItem() {
        // 导航栏左侧按钮
        let leftBarButtonItem1 = UIBarButtonItem(title: "提醒", style: .plain, target: self, action: #selector(barButtonItemClick(sender:)))
        leftBarButtonItem1.tag = 200
        let leftBarButtonItem2 = UIBarButtonItem(title: "排序", style: .plain, target: self, action: #selector(barButtonItemClick(sender:)))
        leftBarButtonItem2.tag = 201
        let leftBarButtonItem3 = UIBarButtonItem(title: "全置", style: .plain, target: self, action: #selector(barButtonItemClick(sender:)))
        leftBarButtonItem3.tag = 202
        self.navigationItem.leftBarButtonItems = [leftBarButtonItem1, leftBarButtonItem2, leftBarButtonItem3]
        // 导航栏右侧按钮
        let rightBarButtonItem1 = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(barButtonItemClick(sender:)))
        rightBarButtonItem1.tag = 100
        let rightBarButtonItem2 = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(barButtonItemClick(sender:)))
        rightBarButtonItem2.tag = 101
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem1, rightBarButtonItem2]
    }
    
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

    // MARK: - ====== Private ======
    // MARK: ===== HTTP
    func queryAllProject_HTTP(isHeaderRefresh: Bool) {
        if isHeaderRefresh {
            currentPage = 0
        } else {
            currentPage += 1
        }
        
        let parameters: [String: String] = [
            "method": "queryAllProject",
            "page": String(currentPage),
            "limit": "30",
        ]
        AF.request(ProjectManagerURL.BaseURL_Proj, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).responseJSON(completionHandler: { (response) in
            switch(response.result) {
            case .success(_):
                if response.response?.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let resultArr = try decoder.decode([ProjectModel].self, from: response.data!)
                        
                        if isHeaderRefresh {
                            // 覆盖
                            self.dataSource = resultArr
                            // 刷新视图
                            self.p_reloadVCBySort(defaultSort: true)
                            self.header.endRefreshing()
                        } else {
                            // 拼接
                            self.dataSource.append(contentsOf: resultArr)
                            // 刷新视图
                            self.tableView.reloadData()
                            // 若数据不足，表示已经全部加载完毕！
                            if resultArr.count < 2 {
                                self.footer.endRefreshingWithNoMoreData()
                            } else {
                                self.footer.endRefreshing()
                            }
                        }
                    } catch let error {
                        print(error)
                        SVProgressHUD.lx_showError("数据处理异常！！！")
                        if isHeaderRefresh {
                            self.header.endRefreshing()
                        } else {
                            self.footer.endRefreshing()
                        }
                    }
                } else {
                    SVProgressHUD.lx_showError("请求成功，数据异常！")
                    if isHeaderRefresh {
                        self.header.endRefreshing()
                    } else {
                        self.footer.endRefreshing()
                    }
                }
            case .failure(let error):
                let message = error.localizedDescription
                SVProgressHUD.lx_showError(message)
                if isHeaderRefresh {
                    self.header.endRefreshing()
                } else {
                    self.footer.endRefreshing()
                }
            }
        })
    }
    
    // MARK: - ====== Actions ======
    @objc func barButtonItemClick(sender:UIBarButtonItem) {
        if sender.tag == 201 {
            // 根据更新日期排序
            p_reloadVCBySort(defaultSort: false)
            return
        }
        if sender.tag == 202 {
            p_setAllTFReminders()
            return
        }
        var VC: UIViewController
        if sender.tag == 200 {
            // 提醒列表
            VC = MyRemindersListVC()
        } else if sender.tag == 100 {
            // 用户列表
            VC = UserListVC()
        } else {
            // F&Q:Frequently Asked Questions
            VC = FQVC()
        }
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(VC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    // MARK: - ====== Private ======
    // MARK: ===== Reminders
    /// 一键设置TF提醒
    func p_setAllTFReminders() {
        ReminderManager.shared.getAllReminders { (isSucc, array) in
            if isSucc {
                self.dataSource.forEach { (model) in
                    if model.ios_release_platform == "TestFlight" {
                        var isExist = false
                        array?.forEach({ (reminder) in
                            if reminder.title == model.app_name {
                                isExist = true
                                // 更新
                                ReminderManager.shared.updateReminder(reminder: reminder, updateTime: model.ios_update_time)
                            }
                        })
                        // 若不存在，则新增
                        if !isExist {
                            ReminderManager.shared.addReminder(model: model)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: ===== Sort
    func p_reloadVCBySort(defaultSort: Bool) {
        if defaultSort {
            sortType = .orderedAscending
        } else {
            if sortType == .orderedAscending {
                sortType = .orderedDescending
            } else {
                sortType = .orderedAscending
            }
        }
        
        self.dataSource = self.dataSource.sorted(by: { (obj1: ProjectModel, obj2: ProjectModel) -> Bool in
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date1 = dateFormater.date(from: (obj1.ios_update_time))
            let date2 = dateFormater.date(from: (obj2.ios_update_time))
            return date1?.compare(date2!) == sortType
        })
        tableView.reloadData()
    }
    
    // MARK: ===== MJ
    @objc func p_reloadVC() {
        self.tableView.mj_header?.beginRefreshing()
    }
    
    @objc func p_headerRefresh() {
        // 重置顶部刷新状态
        tableView.mj_footer?.resetNoMoreData()
        queryAllProject_HTTP(isHeaderRefresh: true)
    }
    
    @objc func p_footerRefresh() {
        queryAllProject_HTTP(isHeaderRefresh: false)
    }
    
    //
    func createModel() -> ProjectModel {
        let num = arc4random() % 50
        return ProjectModel(project_name: "AAA"+String(num), project_manager: "赵这次", project_create_time: "2020-11-11 12:22:12", app_name: "HES管理", ios_android: "iOS&Android")
    }
    
    // MARK: - ========== Delegate ==========
    // MARK: ===== UITableViewDataSource
    /// Section number
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    /// Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProjectCell = tableView.dequeueReusableCell(withIdentifier: ProjectManagerMainVC.identifier, for: indexPath) as! ProjectCell
        // 附件视图
        cell.accessoryType = .disclosureIndicator
        // 点击
        cell.selectionStyle = .none
        // set model
        let model = self.dataSource[indexPath.row]
        
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detailVC = ProjectManagerDetailVC()
        detailVC.model = self.dataSource[indexPath.row]
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
        
    // MARK: - ========== Set&Get ==========
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        // separator
        tv.separatorStyle = .none //.singleLine
        tv.separatorColor = UIColor.orange
        
        tv.estimatedRowHeight = 200
        tv.estimatedSectionHeaderHeight = 0
        tv.estimatedSectionFooterHeight = 0
        
        tv.rowHeight = UITableView.automaticDimension
        
        tv.tableHeaderView = UIView()
        tv.tableFooterView = UIView()
        
        // register
        tv.register(ProjectCell.self, forCellReuseIdentifier: ProjectManagerMainVC.identifier)
        return tv
    }()
    
}


