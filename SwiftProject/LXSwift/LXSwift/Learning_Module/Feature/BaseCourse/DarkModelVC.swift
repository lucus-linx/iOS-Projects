//
//  DarkModelVC.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/2/26.
//  Copyright © 2021 LX. All rights reserved.
//
//  暗黑模式


/*
 https://www.jianshu.com/p/fdf2b85accd3
 https://blog.csdn.net/Mazy_ma/article/details/106164894
 1. Info.plist设置属性User Interface Style值为Light或者Dark；
 2. 按『窗口』设置暗黑模式：window.overrideUserInterfaceStyle = .dark
 3. 按『视图控制器』设置暗黑模式：self.overrideUserInterfaceStyle = .dark
 4. 按『视图』设置暗黑模式：view.overrideUserInterfaceStyle = .dark
 5. 使用系统颜色：view.backgroundColor = .systemBackground   or  UIColor.label
    eg: 文本颜色UIColor.label
        辅助内容的文本标签颜色UIColor.secondaryLabel
        三级UIColor.tertiaryLabel
        超链接标签颜色UIColor.link
        分隔符（细边框或者分割线）UIColor.separator或UIColor.opaqueSeparator
        界面背景色UIColor.systemBackground
 */


import UIKit

class DarkModelVC: UIViewController {

    override func viewDidLoad() {
        self.title = "深色模式"
        
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = DarkUtil.colorLightDark(light: .white, dark: .gray) //UIColor.systemBackground
        } else {
            // Fallback on earlier versions
        }
        
        let switchBtn = UISwitch.init(frame: .init(x: 0, y: 100, width: 300, height: 500))
//        switchBtn.target(forAction: #selector(switchChanged:), withSender: self)
        switchBtn.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        self.view .addSubview(switchBtn)
        
        let lightBtn = UIButton.init(type: .infoLight)
        lightBtn.frame = CGRect(x: 0, y: 200, width: 300, height: 50)
        lightBtn.backgroundColor = .blue
        lightBtn.addTarget(self, action: #selector(lightBtnClick), for: .touchUpInside)
        self.view .addSubview(lightBtn)
        
        let darkBtn = UIButton.init(type: .detailDisclosure)
        darkBtn.frame = CGRect(x: 0, y: 300, width: 300, height: 50)
        darkBtn.backgroundColor = .blue
        darkBtn.addTarget(self, action: #selector(darkBtnClick), for: .touchUpInside)
        self.view .addSubview(darkBtn)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        Log("switch status : \(mySwitch.isOn)")
        // 取反
        mySwitch.setOn(mySwitch.isOn, animated: true)
        // 更改状态
        if mySwitch.isOn {
            followSystem = true
        } else {
            followSystem = false
        }
    }
    
    @objc func lightBtnClick() {
        Log("A")
        isLight = true
    }
    
    @objc func darkBtnClick() {
        Log("B")
        isLight = false
    }
}






// Key
let Key_DarkToSystem = "DarkToSystem"
let Key_LightDark = "LightDark"

// true 跟随系统 false 自选模式
var followSystem: Bool {
    get {
        // 默认跟随系统
        let value = UserDefaults.standard.value(forKey: Key_DarkToSystem)
        if var _: Bool = value as? Bool {
            return UserDefaults.standard.bool(forKey: Key_DarkToSystem)
        }
        // 第一次不存在
        return true
    }
    set(newValue){
        DarkUtil.shared.setSystemDark()
        UserDefaults.standard.set(newValue, forKey: Key_DarkToSystem)
        UserDefaults.standard.synchronize()
    }
}

// true light false dark
var isLight: Bool {
    get {
        //默认light
        let value = UserDefaults.standard.value(forKey: Key_LightDark)
        if var _: Bool = value as? Bool {
            return UserDefaults.standard.bool(forKey: Key_LightDark)
        }
        //第一次不存在
        return true
    }
    set(newValue){
        DarkUtil.shared.setCustomDark(newValue)
        UserDefaults.standard.set(newValue, forKey: Key_LightDark)
        UserDefaults.standard.synchronize()
    }
}



class DarkUtil {
    
    // 单例
    static let shared: DarkUtil = {
        let instance = DarkUtil()
        return instance
    }()
    
    init() {
        
    }
    
    /*
    // 获取SceneDelegate
    lazy var screnDelegate: SceneDelegate? = {
        var uiScreen: UIScene?
        UIApplication.shared.connectedScenes.forEach { (screen) in
            uiScreen = screen
        }
        return (uiScreen?.delegate as? SceneDelegate)
    }()
     */
    
    lazy var _keyWindow: UIWindow = {
        return UIApplication.shared.keyWindow!
    }()
    
    // 跟随系统暗黑模式
    func setSystemDark() {
        if #available(iOS 13.0, *) {
            _keyWindow.overrideUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
        }
    }
    
    // 自定义暗黑
    func setCustomDark(_ b: Bool){
        if(b){
            //light
            if #available(iOS 13.0, *) {
                _keyWindow.overrideUserInterfaceStyle = .light
            }
        } else {
            //dark
            if #available(iOS 13.0, *) {
                _keyWindow.overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    static func colorLightDark(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.init { (trainCollection) -> UIColor in
                if trainCollection.userInterfaceStyle == .light {
                    return light
                } else {
                    if followSystem {
                        return dark
                    } else {
                        if isLight {
                            return light
                        } else {
                            return dark
                        }
                    }
                }
            }
        }
        return light
    }
}



extension DarkUtil {
    
    
}
