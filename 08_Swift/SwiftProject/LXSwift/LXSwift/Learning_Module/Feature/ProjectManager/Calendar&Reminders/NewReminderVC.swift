//
//  NewReminderVC.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/2/25.
//  Copyright © 2021 LX. All rights reserved.
//
//  新建提醒事项

import UIKit
import EventKit
import SnapKit
import SVProgressHUD

class NewReminderVC: UIViewController {
    //
    let eventStore = EKEventStore()
    
    // MARK: - ========== LifeCycle ==========
    override func viewDidLoad() {
        title = "新建提醒事项"
        view.backgroundColor = .white
        if #available(iOS 13.0, *) {
            // 该页面固定暗黑模式
            self.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        //
        createView()
    }
    
    deinit {
        Log("")
    }
    
    // MARK: - ========== UI ==========
    func createView() {
        view.addSubview(titleTF)
        view.addSubview(nodesTF)
        view.addSubview(dateLabel)
        view.addSubview(datePicker)
        view.addSubview(commitBtn)
        // Layout
        titleTF.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        nodesTF.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(titleTF)
            make.top.equalTo(titleTF.snp.bottom).offset(10)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(titleTF)
            make.top.equalTo(nodesTF.snp.bottom).offset(10)
        }
        datePicker.snp.makeConstraints { (make) in
            make.left.right.equalTo(nodesTF)
            make.height.equalTo(150)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
        }
        commitBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(titleTF)
            make.top.equalTo(datePicker.snp.bottom).offset(50)
        }
    }
    
    // MARK: - ========== Action ==========
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.becomeFirstResponder()
        view.endEditing(true)
    }
    
    @objc func commitBtnClick(sender: UIButton) {
        if titleTF.text?.count == 0 {
            SVProgressHUD.lx_showError("Title 不能为空！")
            return
        }
        // 新建提醒事项
        let reminder = EKReminder(eventStore: self.eventStore)
        reminder.title = titleTF.text
        if nodesTF.text?.count ?? 0 > 0 {
            reminder.notes = nodesTF.text
        }
        if dateLabel.text!.contains("年") {
            let dueDateComponents = self.p_dateComponentFromNSDate(date: datePicker.date)
            reminder.dueDateComponents = dueDateComponents
        }
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        do {
            try self.eventStore.save(reminder, commit: true)
            navigationController?.popViewController(animated: true)
        } catch {
              Log("Error creating and saving new reminder : \(error)")
        }
    }
    
    @objc func datePickerValueChange(_ picker: UIDatePicker) {
        Log("datePickerValueChange")
        // 日期样式
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        // 更新提醒时间文本框
        dateLabel.text = formatter.string(from: datePicker.date)
    }
    
    // MARK: - ========== Private ==========
    // 根据NSDate获取对应的DateComponents对象
    func p_dateComponentFromNSDate(date: Date)-> DateComponents{
        let cal = Calendar.current
        let dateComponents = cal.dateComponents([.minute, .hour, .day, .month, .year], from: date)
        return dateComponents
    }
    
    // MARK: - ========== Set&Get ==========
    lazy var titleTF: UITextField = {
        var TF = UITextField()
        TF.placeholder = "标题"
        TF.borderStyle = .roundedRect
        TF.textAlignment = .left
        TF.textColor = UIColor.blue
        TF.keyboardType = .default
        return TF
    }()
    lazy var nodesTF: UITextField = {
        var TF = UITextField()
        TF.placeholder = "备注"
        TF.borderStyle = .roundedRect
        TF.textAlignment = .left
        TF.textColor = UIColor.blue
        TF.keyboardType = .default
        return TF
    }()
    lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.text = "请选择时间⬇️"
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    lazy var datePicker: UIDatePicker = {
        var picker = UIDatePicker()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        picker.datePickerMode = UIDatePicker.Mode.dateAndTime
        picker.addTarget(self, action: #selector(datePickerValueChange(_:)), for: UIControl.Event.valueChanged)
        return picker
    }()
    lazy var commitBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .blue
        btn.setTitle("提  交", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(commitBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
}
