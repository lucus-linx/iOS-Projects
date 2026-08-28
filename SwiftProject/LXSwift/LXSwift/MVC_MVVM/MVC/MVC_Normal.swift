//
//  MVC_Normal.swift
//  LXSwift
//
//  Created by 启业云03 on 2022/5/5.
//  Copyright © 2022 LX. All rights reserved.
//

//  OneCat: 关于 MVC 的一个常见的误用
//  https://onevcat.com/2018/05/mvc-wrong-use/
//
//  https://gist.github.com/onevcat/4042d4d0f156b986e4755a7d4370bb9c

import UIKit

// 定义简单的 ToDo Model
struct ToDoItem {
    let id: UUID
    let title: String

    init(title: String) {
        self.id = UUID()
        self.title = title
    }
}

private let cellIdentifier = "ToDoItemCell"

class ToDoListViewController: UITableViewController {
    // 保存当前待办事项
    var items: [ToDoItem] = []
    weak var addButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "MVC通常模式"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        addButton = navigationItem.rightBarButtonItem
    }

    // 点击添加按钮
    @objc func addButtonPressed(_ sender: Any) {
        let newCount = items.count + 1
        let title = "ToDo Item \(newCount)"

        // 更新 `items`
        items.append(.init(title: title))

        // 为 table view 添加新行
        let indexPath = IndexPath(row: newCount - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)

        // 确定是否达到列表上限，如果达到，禁用 addButton
        if newCount >= 10 {
            addButton?.isEnabled = false
        }
    }
}

extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }

    // 实现滑动 cell 删除的功能
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, done in
            self.items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            if self.items.count < 10 {
                self.addButton?.isEnabled = true
            }
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
