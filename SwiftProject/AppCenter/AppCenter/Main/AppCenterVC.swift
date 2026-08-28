//
//  AppCenterVC.swift
//  AppCenter
//
//  Created by linxiang on 2023/5/14.
//

import SnapKit
import UIKit

class AppCenterVC: UIViewController {
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.p_createView()
    }
    
    deinit {
        print(#function)
    }
    
    // MARK: - Private
    
    // MARK: UI
    
    func p_createView() {
        self.view.backgroundColor = .green
        
        // 
        self.tableHeaderView.addSubview(self.headerSearchBar)
        self.view.addSubview(self.tableView)
        
        
        
        self.tableView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        //
        self.headerSearchBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        self.tableHeaderView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
        }
        
        // 刷新，自动布局
        self.tableHeaderView.layoutIfNeeded()
        self.tableView.tableHeaderView = self.tableHeaderView
    }

    lazy var tableHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    lazy var headerSearchBar: UISearchBar = {
        let bar = UISearchBar()
        return bar
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.tableHeaderView = self.tableHeaderView
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell_ID")
        // iOS15后。UITableView多了一个属性sectionHeaderTopPadding，该值默认为22
        if #available(iOS 15.0, *) {
            tv.sectionHeaderTopPadding = 0
        }
        return tv
    }()
}

extension AppCenterVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .purple
//        headerView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
//        headerView.snp.makeConstraints { make in
//            make.top.top.right.bottom.equalTo()
//            make.height.equalTo(99)
//        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_ID", for: indexPath) as UITableViewCell
        cell.backgroundColor = .orange
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
