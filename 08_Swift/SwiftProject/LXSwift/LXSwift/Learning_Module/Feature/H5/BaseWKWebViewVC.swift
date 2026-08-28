//
//  BaseWKWebViewVC.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/1/29.
//  Copyright © 2021 LX. All rights reserved.
//

import UIKit
import WebKit


class BaseWKWebViewVC: UIViewController, WKUIDelegate {

    private var webView: WKWebView!
    private var progressView: UIProgressView!
    private var observation: NSKeyValueObservation? = nil
    
// MARK: - ========== LifeCycle ==========
    override func loadView() {
        // init webview
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 导航栏按钮
        setupNaviBtn()
        
        // 添加进度条
        progressView = UIProgressView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        progressView?.progress = 0.05   // 默认值
        progressView?.trackTintColor = UIColor.white    // 默认颜色
        progressView?.progressTintColor = UIColor.green // 进度颜色
        self.view.addSubview(progressView)
                
        // add observer to update estimated progress value
        observation = webView.observe(\.estimatedProgress, options: [.new]) { (_, _) in
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
        
        // load
        let url = URL(string: "http://www.baidu.com")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    deinit {
        observation = nil
    }
    
    func setupNaviBtn() -> Void {
        // 返回按钮
        let backBtn = UIButton.init(type: .custom)
        backBtn.setTitle("back", for: .normal)
        backBtn.setTitleColor(UIColor.black, for: .normal)
        backBtn.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        // 返回Item
        let backItem = UIBarButtonItem.init(customView: backBtn)
        
        // 返回按钮
        let forwardItem = UIBarButtonItem(title: "Forward", style: .plain, target: self, action: #selector(forwardClick))
        
        // 关闭按钮
        let closeBtn = UIButton.init(type: .custom)
        closeBtn.setTitle("close", for: .normal)
        closeBtn.setTitleColor(UIColor.black, for: .normal)
        closeBtn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        // 关闭Item
        let closeItem = UIBarButtonItem.init(customView: closeBtn)
        
        // 导航栏赋值
        self.navigationItem.leftBarButtonItems = [backItem, forwardItem, closeItem]
    }
    
    
// MARK: - ========== Action ==========
    @objc func backClick() {
        if webView.canGoBack {
            webView.goBack()
        }
        else {
            closeClick()
        }
    }
    
    @objc func forwardClick() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc func closeClick() {
        if self.presentingViewController == nil {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


// MARK: - ========== Delegate ==========
extension BaseWKWebViewVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Log("didStart")
    }
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        Log("decidePolicyFor")
//    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Log("didFinish")
        // 加载完成，隐藏进度条
        progressView.isHidden = true;
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Log(error.localizedDescription)
    }
}
