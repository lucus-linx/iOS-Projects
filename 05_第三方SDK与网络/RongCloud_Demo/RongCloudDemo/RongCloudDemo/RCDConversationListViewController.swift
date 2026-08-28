//
//  RCDConversationListViewController.swift
//  RongCloudDemo
//
//  Created by 启业云03 on 2022/11/24.
//

import Foundation

import RongIMKit
import UIKit

class RCDConversationListViewController: RCConversationListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 自定义空视图
        let emptyView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        emptyView.center = self.view.center
        emptyView.backgroundColor = .red
        self.emptyConversationView = emptyView
    }

    // 即将加载数据源
    // 您可以在回调中修改、添加、删除数据源的元素来定制显示的内容，会话列表会根据您返回的修改后的数据源进行显示。数据源中存放的元素为会话 Cell 的数据模型，即 RCConversationModel 对象。
    override func willReloadTableData(_ dataSource: NSMutableArray!) -> NSMutableArray! {
        return dataSource
    }

    // 重写自定义 Cell
    override func rcConversationListTableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath!) -> RCConversationBaseCell! {
        print(#function)
        return nil
    }

    // 重写自定义 Cell 高度的方法。
    override func rcConversationListTableView(_ tableView: UITableView!, heightForRowAt indexPath: IndexPath!) -> CGFloat {
        return 200
    }

    // 收到新消息
    override func didReceiveMessageNotification(_ notification: Notification!) {
        print(#function)
    }

    // 即将更新未读消息数
    // 当收到消息或删除会话时，会调用此回调，您可以在此回调中执行未读消息数相关的操作。
    // 注意：该方法在非主线程回调，如果想在本方法中操作 UI，请手动切换到主线程。
    override func notifyUpdateUnreadMessageCount() {
        print(#function)
    }

    // 即将显示 Cell
    // 您可以在此回调中修改 Cell 的一些显示属性，如对会话列表自带 Cell 样式如字体颜色，字体大小进行修改。不建议修改 Cell 的布局。如果对 UI 比较高的定制需求，建议自定义会话列表 Cell。
    override func willDisplayConversationTableCell(_ cell: RCConversationBaseCell!, at indexPath: IndexPath!) {
        print(#function)
    }

    // 点击头像
    override func didTapCellPortrait(_ model: RCConversationModel!) {
        print(#function)
    }

    // 长按头像
    override func didLongPressCellPortrait(_ model: RCConversationModel!) {
        print(#function)
    }

    // Cell Click - 自定义
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        print(#function)

        // 自定义
        if let chatVC = RCDChatViewController(conversationType: model.conversationType, targetId: model.targetId) {
            chatVC.title = "title: " + model.targetId
            // 配置
            chatVC.unReadMessage = model.unreadMessageCount
            chatVC.enableNewComingMessageIcon = true // 是否显示新消息提醒
            chatVC.enableUnreadMessageIcon = false // 是否显示未读消息数提醒
            chatVC.enableUnreadMentionedIcon = true // 是否显示未读 @ 消息数提醒
            chatVC.locatedMessageSentTime = model.sentTime // 定位到指定消息
            if model.conversationType == .ConversationType_PRIVATE {
                chatVC.displayUserNameInCell = true // 显示发送方用户名
            }
            //
            self.navigationController?.pushViewController(chatVC, animated: true)
            return
        }
    }

    // 删除会话
    override func didDeleteConversationCell(_ model: RCConversationModel!) {
        print(#function)
    }
}
