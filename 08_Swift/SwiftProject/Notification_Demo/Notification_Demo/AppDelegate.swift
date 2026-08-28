//
//  AppDelegate.swift
//  Notification_Demo
//
//  Created by 启业云03 on 2022/12/9.
//

import UIKit

import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // 应用程序需要用户授权才能通过『本地和远程』通知使用UNUserNotificationCenter
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        /*
         * alert 通知到达时弹窗权限
         * badge 更新应用角标的权限
         * sound 通知到达时的提示音权限
         * carPlay 车载设备通知权限
         *
         * iOS12
         * criticalAlert 严重警报，无视静音和勿打扰模式，通知到达时会有提示音，此权限要通过苹果审核
         */
        let options: UNAuthorizationOptions = [.alert, .badge, .sound, .carPlay]
        center.requestAuthorization(options: options) { granted, error in
            if granted {
                // 必须主线程
                DispatchQueue.main.async {
                    // 注册远程通知
                    application.registerForRemoteNotifications()
                }
            } else {
                print(error ?? "")
            }
        }

        // 获取通知设置
        center.getNotificationSettings { settings in
            print(settings)
        }

        // 获取通知已添加的category
        center.getNotificationCategories { categorySet in
            print(categorySet)
        }

        // apn 内容获取
        if let launch = launchOptions {
            // 如果 launchOptions 包含 UIApplicationLaunchOptionsRemoteNotificationKey 表示用户点击 apn 通知导致 app 被启动运行；
            if let notiDic = launch[UIApplication.LaunchOptionsKey.remoteNotification] {
                print(notiDic)
            }
        }

        return true
    }

    // deviceToken获取成功的回调
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("远程推送，注册成功")
    }

    // deviceToken获取失败的回调
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("远程推送，注册失败")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 仅当应用程序位于前台时，设置通知是否可见
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        print(#function)
        return .badge
    }

    // 当用户点击了通知时，必须在应用程序从 application:didFinishLaunchingWithOptions: 返回之前设置委托。
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        // 点击了通知
        print(#function)
    }

    // iOS(12.0)，当从应用外部通知界面或通知设置界面进入应用时，该方法将回调。
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        print(#function)
        if notification != nil {
            // 从通知界面直接进入应用
        } else {
            // 从通知设置界面进入应用
        }
    }
}


