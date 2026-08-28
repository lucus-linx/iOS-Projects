//
//  AppDelegate.swift
//  RongCloudDemo
//
//  Created by 启业云03 on 2022/11/24.
//

import NotificationToast
import RongIMKit
import UIKit

#if DEBUG
import DoraemonKit
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        #if DEBUG
        DoraemonManager.shareInstance().install()
        #endif

        // 融云配置
        configRCIM()

        // 连接状态监听器，设置代理委托
        RCIM.shared().connectionStatusDelegate = self

        return true
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

extension AppDelegate {
    func configRCIM() {
        // 输入状态功能
        RCKitConfig.default().message.enableTypingStatus = true

        // 启用多端阅读状态同步
        RCKitConfig.default().message.enableSyncReadStatus = true

        // 消息引用配置
        RCKitConfig.default().message.enableMessageReference = true

        // 消息撤回配置
        RCKitConfig.default().message.enableMessageRecall = true
        RCKitConfig.default().message.maxRecallDuration = 50 // 消息可撤回的最大时间，单位是秒，默认值是 120 秒，可配置。
        RCKitConfig.default().message.reeditDuration = 20 // 消息撤回后可重新编辑的时间，单位是秒，默认值是 300 秒。仅文本消息支持撤回再编辑。

        // 消息回执
        RCKitConfig.default().message.enabledReadReceiptConversationTypeList = []

        // @ 配置
        RCKitConfig.default().message.enableMessageMentioned = false

        /*!
         是否支持暗黑模式，默认值是NO，开启之后 UI 支持暗黑模式，可以跟随系统切换
         @discussion 开启该属性后， 如果想控制 App 不随系统暗黑模式转变，请参考 https://support.rongcloud.cn/ks/MTE0Mg==
         */
        RCKitConfig.default().ui.enableDarkMode = true

        // 头像显示大小默认值为 46*46。注意高度必须大于或者等于 36
        RCKitConfig.default().ui.globalConversationPortraitSize = CGSize(width: 40, height: 40)
        RCKitConfig.default().ui.globalNavigationBarTintColor = .systemPink

        // 设置头像为圆形
        RCKitConfig.default().ui.globalMessageAvatarStyle = RCUserAvatarStyle.USER_AVATAR_CYCLE
        RCKitConfig.default().ui.globalConversationAvatarStyle = RCUserAvatarStyle.USER_AVATAR_CYCLE
    }
}

/*!
 IMKit连接状态的监听器
 @param status  SDK与融云服务器的连接状态
 @discussion 如果您设置了IMKit 连接监听之后，当SDK与融云服务器的连接状态发生变化时，会回调此方法。
 */
extension AppDelegate: RCIMConnectionStatusDelegate {
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        switch status {
        case .ConnectionStatus_Connected:
            ToastView(title: "融云已连接").show()
        case .ConnectionStatus_SignOut:
            ToastView(title: "融云断开连接").show()
        default:
            ToastView(title: "融云连接状态变化啦").show()
        }
    }
}
