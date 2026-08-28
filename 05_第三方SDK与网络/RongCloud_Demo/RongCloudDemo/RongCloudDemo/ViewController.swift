//
//  ViewController.swift
//  RongCloudDemo
//
//  Created by 启业云03 on 2022/11/24.
//

import UIKit

import RongIMKit

import SnapKit

import Alamofire

import CommonCrypto

class ViewController: UIViewController {
    // 融云 App Key
    let RCAppKey = "0vnjpoad0mdqz"

    // 融云 App Secret
    let RCAppSecret = "Qha9tnJPT0pKkh"

    lazy var connectBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .green
        btn.setTitle("初始化SDK", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(connectBtnClick), for: .touchUpInside)
        return btn
    }()

    lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .green
        btn.setTitle("token登录", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        return btn
    }()

    lazy var disconnectBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .green
        btn.setTitle("断开连接（允许推送）", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(disconnectBtnClick), for: .touchUpInside)
        return btn
    }()

    lazy var privateChatBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .green
        btn.setTitle("Server API 发送单聊 2->1", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(privateChatBtnClick), for: .touchUpInside)
        return btn
    }()

    lazy var groupChatBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .green
        btn.setTitle("Server API 发送群聊 2->X", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(groupChatBtnClick), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.p_createView()
    }

    func p_createView() {
        view.backgroundColor = UIColor.white

        self.view.addSubview(self.connectBtn)
        self.view.addSubview(self.loginBtn)
        self.view.addSubview(self.disconnectBtn)
        self.view.addSubview(self.privateChatBtn)
        self.view.addSubview(self.groupChatBtn)

        self.connectBtn.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(2)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        self.loginBtn.snp.makeConstraints { make in
            make.width.height.centerX.equalTo(self.connectBtn)
            make.top.equalTo(self.connectBtn.snp.bottom).offset(30)
        }
        self.disconnectBtn.snp.makeConstraints { make in
            make.width.height.centerX.equalTo(self.connectBtn)
            make.top.equalTo(self.loginBtn.snp.bottom).offset(30)
        }
        self.privateChatBtn.snp.makeConstraints { make in
            make.width.height.centerX.equalTo(self.connectBtn)
            make.bottom.equalTo(self.groupChatBtn.snp.top).offset(-30)
        }
        self.groupChatBtn.snp.makeConstraints { make in
            make.width.height.centerX.equalTo(self.connectBtn)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }

    @objc func connectBtnClick() {
        print(#function)
        // 初始化RC SDK
        RCIM.shared().initWithAppKey(self.RCAppKey)
    }

    @objc func loginBtnClick() {
        print(#function)
        // 初始化RC SDK
        // 此token通过控制台->北极星->Server PAI生成
        let token = "34kV1kWSyFK5L8/3lg4r9kXZJSsYVUkl@he97.cn.rongnav.com;he97.cn.rongcfg.com"
        RCIM.shared().connect(withToken: token) { errorCode in
            print(errorCode)
            // 消息数据库打开，可以进入到主页面
        } success: { userId in
            if let userId = userId {
                print("当前登录UserId = " + userId)
                DispatchQueue.main.async {
                    // 连接成功,可跳转至会话列表页
                    let listVC = RCDConversationListViewController(displayConversationTypes: [1, 2], collectionConversationType: nil)
                    // 是否显示网络连接提示，默认为 YES。
                    listVC?.isShowNetworkIndicatorView = true
                    self.navigationController?.pushViewController(listVC!, animated: true)
                }
            }
        } error: { status in
            print(status)
            if status == .RC_CONN_TOKEN_INCORRECT {
                // 从 APP 服务获取新 token，并重连
            } else {
                // 无法连接到 IM 服务器，请根据相应的错误码作出对应处理
            }
        }
    }

    @objc func disconnectBtnClick() {
        // 1.断开连接 允许推送
        RCIM.shared().disconnect()
        // isReceivePush    BOOL    断开连接后，是否允许融云服务端进行远程推送。 YES 表示接收远程推送。NO 表示不接收远程推送。
        // or RCIM.shared().disconnect(true)

        // 2.断开连接 不允许推送
        RCIM.shared().logout()
        // or RCIM.shared().disconnect(false)
    }

    @objc func privateChatBtnClick() {
        self.p_ServerSendPrivateMsg()
    }

    @objc func groupChatBtnClick() {
        self.p_ServerSendGroupMsg()
    }
}

// MARK: - Server API

extension ViewController {
    /// 客户端通过服务器API发送消息
    func p_ServerSendPrivateMsg() {
        let appKey = "0vnjpoad0mdqz"
        let appSecret = "Qha9tnJPT0pKkh"

        // header
        // 随机数，不超过 18 个字符。
        let nonce = arc4random()
        // 时间戳
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        // 数据签名:（App Secret + Nonce + Timestamp）拼接成一个字符串，进行 SHA1 哈希计算。
        let signature = "\(appSecret)\(nonce)\(timeStamp)".sha1()
        //
        let headers: HTTPHeaders = ["App-Key": appKey,
                                    "Nonce": String(nonce), // 随机数
                                    "Timestamp": String(timeStamp), // 时间戳（毫秒）
                                    "Signature": signature,
                                    "Content-Type": "application/x-www-form-urlencoded"]

        // parameter
        let content: [String: String] = ["content": "hello",
                                         "extra": "helloExtra"]
        let parameters: [String: String] = [
            "fromUserId": "2", // 发送人用户 ID
            "toUserId": "1", // 接收用户 ID
            "objectName": "RC:TxtMsg", // 消息类型
            "content": convertDictionaryToJSONString(dict: content as NSDictionary), // 消息的内容
        ]

        /* 国内数据中心 API 地址：
          * api-cn.ronghub.com
          * api2-cn.ronghub.com
         */
        let url = "https://api-cn.ronghub.com/message/private/publish.json"
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseData { response in
            print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
            print(response.request?.headers ?? "")
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")

            let string = String(data: response.data!, encoding: String.Encoding.utf8)
            print(string!)
        }
    }

    func p_ServerSendGroupMsg() {
        let appKey = "0vnjpoad0mdqz"
        let appSecret = "Qha9tnJPT0pKkh"

        // header
        // 随机数，不超过 18 个字符。
        let nonce = arc4random()
        // 时间戳
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        // 数据签名:（App Secret + Nonce + Timestamp）拼接成一个字符串，进行 SHA1 哈希计算。
        let signature = "\(appSecret)\(nonce)\(timeStamp)".sha1()
        //
        let headers: HTTPHeaders = ["App-Key": appKey,
                                    "Nonce": String(nonce), // 随机数
                                    "Timestamp": String(timeStamp), // 时间戳（毫秒）
                                    "Signature": signature,
                                    "Content-Type": "application/x-www-form-urlencoded"]

        // parameter
        let content: [String: String] = ["content": "hello",
                                         "extra": "helloExtra"]
        let parameters: [String: String] = [
            "fromUserId": "2", // 发送人用户 ID
            "toGroupId": "110", // 接收群 ID   控制台->北极星创建
            "objectName": "RC:TxtMsg", // 消息类型
            "content": convertDictionaryToJSONString(dict: content as NSDictionary), // 消息的内容
        ]

        /* 国内数据中心 API 地址：
          * api-cn.ronghub.com
          * api2-cn.ronghub.com
         */
        let url = "https://api-cn.ronghub.com/message/group/publish.json"
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseData { response in
            print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
            print(response.request?.headers ?? "")
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")

            let string = String(data: response.data!, encoding: String.Encoding.utf8)
            print(string!)
        }
    }

    func convertDictionaryToJSONString(dict: NSDictionary?) -> String {
        let data = try? JSONSerialization.data(withJSONObject: dict!, options: JSONSerialization.WritingOptions(rawValue: 0))
        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return jsonStr! as String
    }
}

extension String {
    func sha1() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
