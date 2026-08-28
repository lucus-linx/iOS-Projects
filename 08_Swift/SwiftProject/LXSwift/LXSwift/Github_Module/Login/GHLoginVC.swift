//
//  GHLoginVC.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/9/7.
//  Copyright © 2021 LX. All rights reserved.
//
// https://github.com/zagahr/Explorer-for-GitHub

import UIKit
import Alamofire

// TODO: 填入你自己的 GitHub Personal Access Token（切勿提交真实 token）
let access_token = ""

class GHLoginVC: UIViewController {
    
    
    override func viewDidLoad() {
        p_createView()
    }
    
    deinit {
        
    }
    
    func p_createView() {
        view.backgroundColor = .white
        view.addSubview(self.loginBtn)
        
        self.loginBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }
    }
    
    @objc func loginClick() {
        //
        print("lgo")
        //
        let parameters = ["Authorization": "token " + access_token]
        AF.request("https://api.github.com/repos", parameters: parameters)
            .response { response in
                Log(response.request?.url)
                Log(response.request?.httpBody)
            }
    }
    
    lazy var loginBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("登  录", for: .normal)
        btn.backgroundColor = .lightGray
        btn.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        return btn
    }()
}
