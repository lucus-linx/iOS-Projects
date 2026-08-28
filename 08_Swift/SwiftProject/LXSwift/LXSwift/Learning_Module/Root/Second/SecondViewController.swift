//
//  SecondViewController.swift
//  LXSwift
//
//  Created by 林祥 on 2020/6/7.
//  Copyright © 2020 LX. All rights reserved.
//

import UIKit

import LXScan_Swift

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private static let identifier = "CellId"
    
    // MARK: - ========== LifeCycle ==========

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.blue
        self.navigationItem.title = "日常代码"
        
        // 导航栏是否半透明
        self.navigationController?.navigationBar.isTranslucent = false
        
        // 导航栏构建
        self.setUpNavigationBar()
        
        self.setUpTableView()
    }
    
    deinit {
        Log("")
    }
    
    // MARK: - ========== UI ==========

    func setUpNavigationBar() {
        let leftBarButtonItem1 = UIBarButtonItem(title: "常用代码", style: .plain, target: self, action: #selector(self.leftBarButtonClick(sender:)))
        self.navigationItem.leftBarButtonItems = [leftBarButtonItem1]
        
        let rightBarButtonItem1 = UIBarButtonItem(title: "扫一扫", style: .plain, target: self, action: #selector(self.rightBarButtonClick(sender:)))
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem1]
    }
    
    func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        view.addSubview(self.tableView)
        
        // Set layout for tableView.
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    // MARK: - ========== Action ==========

    @objc func leftBarButtonClick(sender: UIBarButtonItem) {
        let stringVC = StringVC()
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(stringVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    @objc func rightBarButtonClick(sender: UIBarButtonItem) {
        let scanVC = LXScanViewController()
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(scanVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }

    // MARK: - ========== Delegate ==========

    // MARK: ===== UITableViewDataSource

    /// Section number
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    /// Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // declare a tableViewCell as an implicitly unwrapped optional...
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: SecondViewController.identifier)

        // you CAN check this against nil, if nil then create a cell (don't redeclare like you were doing...
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default,
                                   reuseIdentifier: SecondViewController.identifier)
        }
        // 附件视图
        cell.accessoryType = .disclosureIndicator
        
        var text: String = ""
        switch indexPath.row {
        case 0:
            text = "FB"
        case 1:
            text = "计时器"
        case 2:
            text = "WKWebView 基础版"
        case 3:
            text = "Date Usage"
        case 4:
            text = "AF.request"
        case 5:
            text = "获取屏幕相关UI尺寸"
        case 6:
            text = "KVC"
        case 7:
            text = "Mardkown"
        case 8:
            text = "获取当前定位，无地图"
        case 9:
            text = "显示指定定位，有地图"
        case 10:
            text = "显示当前定位，有地图"
        case 11:
            text = "选取定位，有地图"
        default:
            text = "\(indexPath.row)"
        }
        cell.textLabel?.text = String(indexPath.row) + ". " + text
        cell.imageView?.image = UIImage(named: "fb_games")
        return cell
    }
    
    // MARK: ===== UITableViewDelegate

    /// didSelect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var VC: UIViewController?
        switch indexPath.row {
        case 0:
            VC = FBMeViewController()
        case 1:
            VC = StopWatchVC()
        case 2:
            VC = BaseWKWebViewVC()
            self.hidesBottomBarWhenPushed = true
            if LX_RandomBool() {
                self.navigationController?.pushViewController(VC!, animated: true)
            } else {
                let navi = UINavigationController(rootViewController: VC!)
                self.present(navi, animated: true, completion: nil)
            }
            self.hidesBottomBarWhenPushed = false
            return
        case 3:
            VC = DateUsageVC()
        case 4:
            makeRequest()
        case 5:
            VC = SafeAreaTestVC()
        case 6:
            VC = KVC()
            fallthrough
        case 7:
            VC = MarkDownTestVC()
        case 8:
            VC = GetLocationViewController()
        case 9:
            /*{
                x = "118.802045";
                address = "";
                scale = 28;
                y = "32.067192";
                mark = "江苏省南京市玄武区鸡鸣寺路1号";
                type = "wgs84";
                spaceId = "APICeShiQiYe";
            }*/
            let VC1 = LocationViewController()
            VC1.paramDic = ["x": 118.802045,
                            "y": 32.067192,
                            "scale": 12,
                            "mark": "江苏省南京市玄武区鸡鸣寺路1号",
                            "type": "wgs84",
                            "spaceId": "APICeShiQiYe"]
            VC = VC1
        case 10:
            VC = GetShowLocationViewController()
        case 11:
            let VC1 = LocationViewController2()
            VC1.paramDic = ["x": 118.802045,
                            "y": 32.067192,
                            "scale": 12,
                            "mark": "江苏省南京市玄武区鸡鸣寺路1号",
                            "type": "wgs84",
                            "spaceId": "APICeShiQiYe"]
            VC = VC1
        default:
            Log("\(indexPath.row)")
        }
        if VC != nil {
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(VC ?? UIViewController(), animated: true)
            self.hidesBottomBarWhenPushed = false
        }
    }
        
    // MARK: - ========== Set&Get ==========

    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.tableFooterView = UIView()
        // separator
        tv.separatorStyle = .singleLine
        tv.separatorColor = UIColor.orange
        // register
        tv.register(UITableViewCell.self, forCellReuseIdentifier: SecondViewController.identifier)
        return tv
    }()
}
