//
//  AppDelegate.swift
//  LXSwift
//
//  Created by 林祥 on 2020/6/7.
//  Copyright © 2020 LX. All rights reserved.
//

import Onboard
import SwiftyUserDefaults
import UIKit
#if DEBUG
    import DoraemonKit
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // 由于iOS13后window托给scene，iOS12及以下需要在AppDelegate中重新声明
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        #if DEBUG
            // add plugin
            DoraemonManager.shareInstance().addPlugin(withTitle: "切换环境",
                                                      image: UIImage(named: "Logo")!,
                                                      desc: "切换环境",
                                                      pluginName: "DoKitPlugin_ChangeURL",
                                                      atModule: "自定义专区")
            // init
            DoraemonManager.shareInstance().install(withStartingPosition: CGPoint(x: 0, y: 500))
            DoraemonManager.shareInstance().pId = VendorKey.DoraemonKit_Key
        #endif

        // 缓存标记
        Defaults.launchCount += 1
        Log("当前是第\(Defaults.launchCount)次启动！")

        //
        var controller = UIViewController()
        let cur_mode = 2
        switch cur_mode {
        case 0:
            let isLogin = UserDefaults.standard.bool(forKey: Global_UserDefaultsKey.k_ISLogin)
            if isLogin {
                controller = RootTabbarController()
            }
            else {
                controller = LoginVC()
            }
        case 1:
            controller = GHLoginVC()
        case 2:
//            let navigationViewController = UINavigationController(rootViewController: ToDoListViewController())
            let navigationViewController = UINavigationController(rootViewController: ToDoListViewController_1())
            controller = navigationViewController
        default:
            break
        }

        // 创建window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        // 设置window的rootViewController
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
        return true
    }

    // MARK: - ========== Private ==========

    // 样式一：标准样式  未完成
    func generateStandardOnboardingVC() -> OnboardingViewController {
        let firstPage = OnboardingContentViewController(title: "来源", body: "大爷", image: UIImage(named: "tabbar_person_normal@2x"), buttonText: "点击") {
            Log("点击了")
        }
        let secondPage = OnboardingContentViewController(title: "来源1", body: "大爷2", image: UIImage(named: "tabbar_person_normal@2x"), buttonText: "点击") {
            Log("点击了1")
        }

        // Image
        let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "tabbar_person_normal"), contents: [firstPage, secondPage])
        return onboardingVC ?? OnboardingViewController()
    }

    /*
     // 样式二
     func generateMovieOnboardingVC() -> OnboardingViewController {

     }

     // 样式三
     func generateVideoOnboardingVC() -> OnboardingViewController {
         // Video
         let bundle = NSBundle.mainBundle()
         let moviePath = bundle.pathForResource("yourVid", ofType: "mp4")
         let movieURL = NSURL(fileURLWithPath: moviePath!)

         let onboardingVC = OnboardingViewController(backgroundVideoURL: movieUrl, contents: [firstPage, secondPage, thirdPage])
     }
      */
}

// MARK: - ========== Variable ==========

// MARK: - ========== UI Component ==========

// MARK: - ========== LifeCycle ==========

// MARK: - ========== UI ==========

// MARK: - ========== Delegate ==========

// MARK: ===== UITableViewDataSource

// MARK: - ========== Private ==========

// MARK: - ========== Public ==========

// MARK: - ========== Action ==========

// MARK: - ========== Set&Get ==========
