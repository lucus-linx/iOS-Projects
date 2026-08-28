//
//  LoginVC.swift
//  LXSwift
//
//  Created by 启业云03 on 2020/6/8.
//  Copyright © 2020 LX. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SVProgressHUD
import SnapKit
import Alamofire

class LoginVC: UIViewController {

    // MARK: - ========== LifeCycle ==========
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setUpView()
    }
    
    // MARK: - ========== UI ==========
    func setUpView() {
        self.view.addSubview(headIMV)
        view.addSubview(usernameTF)
        view.addSubview(passwordTF)
        view.addSubview(loginBtn)
        view.addSubview(registerBtn)
        
        // Layout
        headIMV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(view.snp.height).multipliedBy(0.2)
            make.top.equalTo(view.snp.bottom).multipliedBy(0.1)
        }
        usernameTF.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.top.equalTo(view.snp.bottom).multipliedBy(0.4)
        }
        passwordTF.snp.makeConstraints { (make) in
            make.centerX.height.width.equalTo(usernameTF)
            make.top.equalTo(usernameTF.snp.bottom).offset(20)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTF.snp.bottom).offset(30)
            make.width.equalTo(passwordTF)
            make.height.equalTo(50)
        }
        registerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(20)
            make.right.equalTo(loginBtn)
            make.width.equalTo(loginBtn).multipliedBy(0.3)
            make.height.equalTo(30)
        }
    }

    // MARK: - ====== Actions ======
    @objc func loginBtnClick(sender: UIButton) {
        let username = usernameTF.text ?? ""
        let password = passwordTF.text ?? ""
        // 单机版
        if username.contains("1") {
            SVProgressHUD.show(withStatus: "《单机版》正在登录...")
            // 延迟执行
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                SVProgressHUD.dismiss {
                    SVProgressHUD.lx_showSuccess("登录成功")
                    // 设置标识
                    UserDefaults.standard.set(true, forKey: Global_UserDefaultsKey.k_ISLogin)
                    Defaults.username = self.usernameTF.text
                    Defaults.password = self.passwordTF.text

                    if let window = UIApplication.shared.delegate?.window {
                        window?.rootViewController  = RootTabbarController()
                    }
                }
            }
            return
        }
        
        // 联网版本
        if username.isEmpty || password.isEmpty {
            SVProgressHUD.lx_showError("请输入用户名和密码")
            return
        }
        
        SVProgressHUD.show(withStatus: "正在登录...")
        let parameters: [String: String] = [
            "method": "login",
            "username": username,
            "password": password,
        ]
        AF.request(ProjectManagerURL.BaseURL_User, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).responseString { response in
            switch(response.result) {
            case .success:
                let dict = convertJSONStringToDictionary(text: response.value ?? "")
                // 取值
                let code = dict?["code"] as! String
                if Int(code) == 200 {
                    SVProgressHUD.lx_showSuccess(dict?["msg"] as! String)
                    // 设置标识
                    UserDefaults.standard.set(true, forKey: Global_UserDefaultsKey.k_ISLogin)
                    Defaults.username = self.usernameTF.text
                    Defaults.password = self.passwordTF.text
                    
                    if let window = UIApplication.shared.delegate?.window {
                        window?.rootViewController  = RootTabbarController()
                    }
                } else {
                    SVProgressHUD.lx_showError(dict?["msg"] as! String)
                }
            case .failure(let error):
                let message = error.localizedDescription
                SVProgressHUD.lx_showError(message)
            }
        }
    }
    
    @objc func registerBtnClick(sender: UIButton) {
        let VC = RegisterVC()
        // VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
    }
    
    // MARK: - ========== Set&Get ==========
    lazy var headIMV = { () -> UIImageView in
        var imageV = UIImageView()
        imageV.image = UIImage(named: "default_avatar")
        return imageV
    }()

    lazy var usernameTF: UITextField = {
        var TF = UITextField()
        TF.placeholder = "请输入用户名"
        TF.borderStyle = .roundedRect
        TF.textAlignment = .left
        TF.textColor = UIColor.blue
        TF.text = Defaults.username
        return TF
    }()
    
    lazy var passwordTF: UITextField = {
        var TF = UITextField()
        TF.placeholder = "请输入密码"
        TF.borderStyle = .roundedRect
        TF.textAlignment = .left
        TF.textColor = UIColor.blue
        TF.isSecureTextEntry = true
        TF.text = Defaults.password
        return TF
    }()
    
    lazy var loginBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.blue
        btn.setTitle("登  录", for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitleColor(UIColor.green, for: .selected)
        btn.layer.cornerRadius = 5.0
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.green.cgColor
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var registerBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.green
        btn.setTitle("注 册", for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.addTarget(self, action: #selector(registerBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
}
