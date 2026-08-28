//
//  DoKitPlugin_ChangeURL.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/3/3.
//  Copyright © 2021 LX. All rights reserved.
//

import UIKit
import DoraemonKit
import SwiftyUserDefaults

@objc(DoKitPlugin_ChangeURL)
class DoKitPlugin_ChangeURL: NSObject, DoraemonPluginProtocol {
    @objc func pluginDidLoad() {
        let vc = DoKitPlugin_ChangeURLVC()
        DoraemonHomeWindow.openPlugin(vc)
    }
}


class DoKitPlugin_ChangeURLVC: UIViewController {
    var tableView: UITableView!
    private static let Cell_ID = "identifier"
    
    override func viewDidLoad() {
        view.backgroundColor = .orange
        title = "切换环境"
        
        // 创建表视图
        tableView = UITableView(frame: self.view.frame, style:.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(self.tableView)
    }
    
    deinit {
        Log("")
    }
    
}

extension DoKitPlugin_ChangeURLVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //declare a tableViewCell as an implicitly unwrapped optional...
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: DoKitPlugin_ChangeURLVC.Cell_ID)

        //you CAN check this against nil, if nil then create a cell (don't redeclare like you were doing...
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default ,
                                   reuseIdentifier:DoKitPlugin_ChangeURLVC.Cell_ID)
        }
        // 附件视图
        cell.accessoryType = .detailButton
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "环境：\n" + Defaults.projectManagerDomain
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alertVC = UIAlertController(title: "当前环境", message: "可直接输入新环境，并退出重启！", preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            textField.text = Defaults.projectManagerDomain
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { (alertAction) in
            let firstTF_Text = alertVC.textFields?.first?.text ?? "";
            Defaults.projectManagerDomain = firstTF_Text
            abort()
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(confirmAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

