//
//  RegisterVC.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/2/4.
//  Copyright © 2021 LX. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class RegisterVC: UIViewController {
    // MARK: - ========== LifeCycle ==========
    override func viewDidLoad() {
        self.view.backgroundColor = Specs.color.white
        createView()
    }

    deinit {
        
    }
    
    // MARK: - ========== UI ==========
    func createView() {
        view.addSubview(usernameTF)
        view.addSubview(passwordTF)
        view.addSubview(verifyCodeTF)
        view.addSubview(registerBtn)
        
        // Layout
        usernameTF.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.top.equalTo(view.snp.bottom).multipliedBy(0.2)
        }
        passwordTF.snp.makeConstraints { (make) in
            make.centerX.height.width.equalTo(usernameTF)
            make.top.equalTo(usernameTF.snp.bottom).offset(20)
        }
        verifyCodeTF.snp.makeConstraints { (make) in
            make.centerX.height.width.equalTo(usernameTF)
            make.top.equalTo(passwordTF.snp.bottom).offset(20)
        }
        registerBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(verifyCodeTF.snp.bottom).offset(30)
            make.width.equalTo(usernameTF)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - ====== HTTP ======
    func register_HTTP(_ username:String, password: String, verifyCode: String) {
        if (username.isEmpty || password.isEmpty || verifyCode.isEmpty) {
            SVProgressHUD.lx_showError("请检测输入")
            return
        }
        
        let parameters: [String: String] = [
            "method": "register",
            "username": username,
            "password": password,
            "verifyCode": verifyCode
        ]
        AF.request(ProjectManagerURL.BaseURL_User, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).responseString { [self]response in
            switch(response.result) {
            case .success:
                let JSON = response.result
                Log("JSON: \(JSON)")
                
                let B = response.data
                let newStr = String(data: B!, encoding: String.Encoding.utf8)
                Log(newStr)
                
                let dict = convertJSONStringToDictionary(text: response.value ?? "")
                Log(response.value)
                Log(dict)
                SVProgressHUD.lx_showSuccess(dict?["msg"] as! String)
                
                // 取值
                let code = dict?["code"] as! String
                if Int(code) == 200 {
                    SVProgressHUD.lx_showSuccess(dict?["msg"] as! String) {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    SVProgressHUD.lx_showError(dict?["msg"] as! String)
                }
                
            case .failure(let error):
                let message: String
                if let status = response.response?.statusCode {
                    switch status {
                    case 404:
                        message = "404"
                    case 500:
                        message = "500"
                    default:
                        message = "5XX"
                    }
                } else {
                    message = error.localizedDescription
                }
                SVProgressHUD.lx_showError(message)
            }
        }
    }
    
    // MARK: - ====== Actions ======
    @objc func registerBtnClick(sender: UIButton) {
        // 发送网络请求
        register_HTTP(usernameTF.text ?? "", password: passwordTF.text ?? "", verifyCode: verifyCodeTF.text ?? "")
    }
    
    // MARK: - ========== Set&Get ==========
    lazy var usernameTF: UITextField = {
        var TF = UITextField()
        TF.placeholder = "请输入用户名"
        TF.borderStyle = .roundedRect
        TF.textAlignment = .left
        TF.textColor = UIColor.blue
        return TF
    }()
    
    lazy var passwordTF: UITextField = {
        var TF = UITextField()
        TF.placeholder = "请输入密码"
        TF.borderStyle = .roundedRect
        TF.textAlignment = .left
        TF.textColor = UIColor.blue
        TF.isSecureTextEntry = true
        TF.keyboardType = .default
        return TF
    }()
    
    lazy var verifyCodeTF: UITextField = {
        var TF = UITextField()
        TF.placeholder = "请输入验证码，联系管理员获取。"
        TF.borderStyle = .roundedRect
        TF.textAlignment = .left
        TF.textColor = UIColor.blue
        TF.keyboardType = .default
        return TF
    }()
    
    lazy var registerBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.green
        btn.setTitle("注   册", for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.addTarget(self, action: #selector(registerBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
}
