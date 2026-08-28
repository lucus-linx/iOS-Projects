//
//  MVC_Optimize.swift
//  LXSwift
//
//  Created by 启业云03 on 2022/5/5.
//  Copyright © 2022 LX. All rights reserved.
//
//  MVC优化
//  https://gist.github.com/onevcat/9e08111cebb1967cb96a737ed40f9f14

import UIKit

extension Notification {
    struct UserInfoKey<ValueType>: Hashable {
        let key: String
    }
    
    func getUserInfo<T>(for key: Notification.UserInfoKey<T>) -> T {
        return userInfo![key] as! T
    }
}

extension Notification.Name {
    static let toDoStoreDidChangedNotification = Notification.Name(rawValue: "com.onevcat.app.ToDoStoreDidChangedNotification")
}

extension Notification.UserInfoKey {
    static var toDoStoreDidChangedChangeBehaviorKey: Notification.UserInfoKey<ToDoStore.ChangeBehavior> {
        return Notification.UserInfoKey(key: "com.onevcat.app.ToDoStoreDidChangedNotification.ChangeBehavior")
    }
}

extension NotificationCenter {
    func post<T>(name aName: NSNotification.Name, object anObject: Any?, typedUserInfo aUserInfo: [Notification.UserInfoKey<T>: T]? = nil) {
        post(name: aName, object: anObject, userInfo: aUserInfo)
    }
}

struct ToDoItem_1 {
    typealias ItemId = UUID
    
    let id: ItemId
    let title: String
    
    init(title: String) {
        self.id = ItemId()
        self.title = title
    }
}

class ToDoStore {
    enum ChangeBehavior {
        case add([Int])
        case remove([Int])
        case reload
    }
    
    static let shared = ToDoStore()
    
    static func diff(original: [ToDoItem_1], now: [ToDoItem_1]) -> ChangeBehavior {
        let originalSet = Set(original)
        let nowSet = Set(now)
        
        if originalSet.isSubset(of: nowSet) { // Appended
            let added = nowSet.subtracting(originalSet)
            let indexes = added.compactMap { now.firstIndex(of: $0) }
            return .add(indexes)
        } else if nowSet.isSubset(of: originalSet) { // Removed
            let removed = originalSet.subtracting(nowSet)
            let indexes = removed.compactMap { original.firstIndex(of: $0) }
            return .remove(indexes)
        } else { // Both appended and removed
            return .reload
        }
    }
    
    private var items: [ToDoItem_1] = [] {
        didSet {
            let behavior = ToDoStore.diff(original: oldValue, now: items)
            NotificationCenter.default.post(
                name: .toDoStoreDidChangedNotification,
                object: self,
                typedUserInfo: [.toDoStoreDidChangedChangeBehaviorKey: behavior]
            )
        }
    }
    
    private init() {}
    
    func append(item: ToDoItem_1) {
        items.append(item)
    }
    
    func append(newItems: [ToDoItem_1]) {
        items.append(contentsOf: newItems)
    }
    
    func remove(item: ToDoItem_1) {
        guard let index = items.firstIndex(of: item) else { return }
        remove(at: index)
    }
    
    func remove(at index: Int) {
        items.remove(at: index)
    }
    
    func edit(original: ToDoItem_1, new: ToDoItem_1) {
        guard let index = items.firstIndex(of: original) else { return }
        items[index] = new
    }
    
    var count: Int {
        return items.count
    }
    
    func item(at index: Int) -> ToDoItem_1 {
        return items[index]
    }
}

extension ToDoItem_1: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}

extension ToDoItem_1: Equatable {
    public static func == (lhs: ToDoItem_1, rhs: ToDoItem_1) -> Bool {
        return lhs.id == rhs.id
    }
}

private let cellIdentifier = "ToDoItem_1Cell"

class ToDoListViewController_1: UITableViewController {
    weak var addButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        addButton = navigationItem.rightBarButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(ToDoItem_1sDidChange), name: .toDoStoreDidChangedNotification, object: nil)
    }
    
    private func syncTableView(for behavior: ToDoStore.ChangeBehavior) {
        switch behavior {
        case .add(let indexes):
            let indexPathes = indexes.map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPathes, with: .automatic)
        case .remove(let indexes):
            let indexPathes = indexes.map { IndexPath(row: $0, section: 0) }
            tableView.deleteRows(at: indexPathes, with: .automatic)
        case .reload:
            tableView.reloadData()
        }
    }
    
    private func updateAddButtonState() {
        addButton?.isEnabled = ToDoStore.shared.count < 10
    }

    @objc func ToDoItem_1sDidChange(_ notification: Notification) {
        let behavior = notification.getUserInfo(for: .toDoStoreDidChangedChangeBehaviorKey)
        syncTableView(for: behavior)
        updateAddButtonState()
    }
    
    @objc func addButtonPressed(_ sender: Any) {
        let store = ToDoStore.shared
        let newCount = store.count + 1
        let title = "ToDo Item \(newCount)"
        
        store.append(item: .init(title: title))
    }
}

extension ToDoListViewController_1 {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ToDoStore.shared.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = ToDoStore.shared.item(at: indexPath.row).title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, done in
            ToDoStore.shared.remove(at: indexPath.row)
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
