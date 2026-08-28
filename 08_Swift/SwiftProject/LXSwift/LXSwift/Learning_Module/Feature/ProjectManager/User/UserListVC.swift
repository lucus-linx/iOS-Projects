//
//  UserListVC.swift
//  LXSwift
//
//  Created by 林祥 on 2021/2/5.
//  Copyright © 2021 LX. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class UserListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private static let identifier = "CellId"
    
    public var dataSource = [UserModel]()

    // MARK: - ========== LifeCycle ==========
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        self.title = "所有用户"
        
        setUpTableView()
        // 请求数据
        getAllUser_HTTP()
    }
    
    deinit {
        Log("dealloc")
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
    
    func getAllUser_HTTP() {
        SVProgressHUD.show(withStatus: "正在加载...")
        let parameters: [String: String] = [
            "method": "queryAllUser",
            "page": "0",
            "limit": "100",
        ]
        AF.request(ProjectManagerURL.BaseURL_User, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).responseString { response in
            switch(response.result) {
            case .success(let value):
                /*
                let json = JSON(value)
                print("JSON: \(json)")
                 */
                if response.response?.statusCode == 200 {
                    let jsonArr = try! JSON(data: response.data!)
                    for index in 0...jsonArr.count-1 {
                        let _username = jsonArr[index]["username"].stringValue
                        let _password = jsonArr[index]["password"].stringValue
                        let _verifyCode = jsonArr[index]["verifyCode"].stringValue
                        Log("\(_username)\(_password)\(_verifyCode)")
                        let model = UserModel.init(username: _username, password: _password, verifyCode: _verifyCode)
                        self.dataSource.append(model)
                    }
                    // 刷新视图
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.lx_showError("请求成功，数据异常！")
                }
            case .failure(let error):
                let message = error.localizedDescription
                SVProgressHUD.lx_showError(message)
            }
            SVProgressHUD.dismiss()
        }
    }
    
    // MARK: - ========== Delegate ==========
    // MARK: ===== UITableViewDataSource
    /// Section number
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    /// Row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    /// Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //declare a tableViewCell as an implicitly unwrapped optional...
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: UserListVC.identifier)
        
        //you CAN check this against nil, if nil then create a cell (don't redeclare like you were doing...
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default ,reuseIdentifier: UserListVC.identifier)
        }
        // 附件视图
        cell.accessoryType = .disclosureIndicator
        
        let model = self.dataSource[indexPath.row]
        cell.textLabel?.text = "用户名：".appending(model.username.appending("，密码").appending(model.password))
        return cell
    }
    
    // MARK: ===== UITableViewDelegate
    /// didSelect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        //
        tv.rowHeight = 40
        // register
        tv.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        return tv
    }()
}
