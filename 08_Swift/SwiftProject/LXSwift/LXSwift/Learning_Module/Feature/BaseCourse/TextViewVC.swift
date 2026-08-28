//
//  TextViewVC.swift
//  LXSwift
//
//  Created by 启业云03 on 2021/8/5.
//  Copyright © 2021 LX. All rights reserved.
//

import Foundation

/*
 上一段是通过控制TextField输入输出
 下一段自定义Label通过KVC给UITextView私有变量_placeholderLabel赋值
 */

/*
 import QYYExtension
 import QYYIconFont_Base
 import QYYToast
 import SnapKit
 import UIKit

 private let MaxWords: Int = 40
 private let PlaceholderText: String = "请输入，最多40个字"

 @objc public class PersonalSignatureViewController: UIViewController {
    //
    @objc public var editText: String = ""
    // 定义一个Block
    public typealias Block = (Bool, String) -> Void
    // 声明block属性
    @objc public var textChangeBlock: Block?

    // MARK: - ========== LifeCycle ==========

    override open func viewDidLoad() {
        view.backgroundColor = KQYYColorHex(0xf6f7f8, 0x121212)
        title = "个性签名"
        //
        p_initSubViews()
    }

    override public func viewWillAppear(_ animated: Bool) {
        editTextView.becomeFirstResponder()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        editTextView.resignFirstResponder()
    }

    deinit {}

    // MARK: - ========== Private ==========

    func p_initSubViews() {
        if responds(to: #selector(getter: edgesForExtendedLayout)) {
            self.edgesForExtendedLayout = []
        }
        //
        let finishItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(finishItemClick(sender:)))
        finishItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: 0xffffff)], for: .normal)
        finishItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: 0xc2c6ff)], for: .disabled)
        navigationItem.rightBarButtonItem = finishItem
        navigationItem.rightBarButtonItem?.isEnabled = false
        //
        view.addSubview(editTextView)
        editTextView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(8)
            make.height.equalTo(180)
        }
        // 赋值
        if editText.isEmpty {
            editTextView.text = PlaceholderText
            editTextView.textColor = .lightGray
            editTextView.selectedTextRange = editTextView.textRange(from: editTextView.beginningOfDocument, to: editTextView.beginningOfDocument)
        } else {
            editTextView.text = editText
        }
    }

    // MARK: - ========== Action ==========

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        editTextView.resignFirstResponder()
    }

    /// 完成按钮点击事件
    /// - Parameter sender:
    @objc func finishItemClick(sender: UIBarButtonItem) {
        QYCUserInfoUpdatemanager.updateUserInfoType(.typeSign, parama: editTextView.text) { success, _ in
            guard success else {
                QYYToast.showToast(withMessage: "更改失败" , type: .error)
                return
            }
            QYYToast.showToast(withMessage: "更改成功", type: .success)
            if self.textChangeBlock != nil {
                self.textChangeBlock!(success, self.editTextView.text)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - ========== Setter & Getter ==========

    lazy var editTextView: UITextView = {
        let _textView = UITextView()
        _textView.backgroundColor = KQYYColorHex(0xffffff, 0x1e1e1e)
        _textView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: -12)
        _textView.font = UIFont.systemFont(ofSize: 15)
        _textView.delegate = self
        _textView.textColor = KQYYColorHex(0x333333, 0xc4c4c4)
        return _textView
    }()
 }

 extension PersonalSignatureViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        // 回车键值失效
        if text.elementsEqual("\n") {
            return false
        }
        // 占位符
        if updatedText.isEmpty {
            textView.text = PlaceholderText
            textView.textColor = .lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == .lightGray, !text.isEmpty {
            textView.textColor = .black
            textView.text = ""
        }
        // 限制字符数
        if updatedText.count > MaxWords {
            return false
        }
        return true
    }

    public func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.text.elementsEqual(PlaceholderText) {
            navigationItem.rightBarButtonItem?.isEnabled = !editText.isEmpty
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = !textView.text.elementsEqual(editText)
        }
        // 光标
        if textView.textColor == .lightGray {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
 }

 extension PersonalSignatureViewController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if item.rightBarButtonItem?.isEnabled == true {
            editTextView.resignFirstResponder()
            // showAlert in QYYExtension
            showAlert(title: "您的个性签名尚未保存，是否返回？", message: "", actionTitles: ["继续编辑", "返回"], preferIndex: nil) { [weak self] index in
                if index == 0 {
                    self?.editTextView.becomeFirstResponder()
                } else if index == 1 {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            return false
        }
        return true
    }
 }








import QYYExtension
import QYYIconFont_Base
import QYYToast
import SnapKit
import UIKit

private let MaxWords: Int = 40
private let PlaceholderText: String = "请输入，最多40个字"

@objc public class PersonalSignatureViewController: UIViewController {
    //
    @objc public var editText: String = ""
    // 定义一个Block
    public typealias Block = (Bool, String) -> Void
    // 声明block属性
    @objc public var textChangeBlock: Block?

    // MARK: - ========== LifeCycle ==========

    override open func viewDidLoad() {
        view.backgroundColor = KQYYColorHex(0xf6f7f8, 0x121212)
        title = "个性签名"
        //
        p_initSubViews()
    }

    override public func viewWillAppear(_ animated: Bool) {
        editTextView.becomeFirstResponder()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        editTextView.resignFirstResponder()
    }

    deinit {}

    // MARK: - ========== Private ==========

    func p_initSubViews() {
        if responds(to: #selector(getter: edgesForExtendedLayout)) {
            self.edgesForExtendedLayout = []
        }
        //
        let finishItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(finishItemClick(sender:)))
        finishItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: 0xffffff)], for: .normal)
        finishItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: 0xc2c6ff)], for: .disabled)
        navigationItem.rightBarButtonItem = finishItem
        navigationItem.rightBarButtonItem?.isEnabled = false
        //
        view.addSubview(editTextView)
        editTextView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(8)
            make.height.equalTo(180)
        }
        // 赋值
        editTextView.text = editText
    }

    // MARK: - ========== Action ==========

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        editTextView.resignFirstResponder()
    }

    /// 完成按钮点击事件
    /// - Parameter sender:
    @objc func finishItemClick(sender: UIBarButtonItem) {
        QYCUserInfoUpdatemanager.updateUserInfoType(.typeSign, parama: editTextView.text) { success, _ in
            guard success else {
                QYYToast.showToast(withMessage: "更改失败", type: .error)
                return
            }
            QYYToast.showToast(withMessage: "更改成功", type: .success)
            if self.textChangeBlock != nil {
                self.textChangeBlock!(success, self.editTextView.text)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - ========== Setter & Getter ==========

    lazy var editTextView: UITextView = {
        let _textView = UITextView()
        _textView.backgroundColor = KQYYColorHex(0xffffff, 0x1e1e1e)
        _textView.font = UIFont.systemFont(ofSize: 15)
        _textView.delegate = self
        _textView.textColor = KQYYColorHex(0x333333, 0xc4c4c4)
        // 占位符
        let placeHolderLabel = UILabel()
        placeHolderLabel.text = PlaceholderText
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.textColor = .lightGray
        placeHolderLabel.sizeToFit()
        placeHolderLabel.font = .systemFont(ofSize: 15)
        _textView.addSubview(placeHolderLabel)
        _textView.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        // 内边距
        _textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return _textView
    }()
}

extension PersonalSignatureViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        // 回车键值失效
        if text.elementsEqual("\n") {
            return false
        }
        // 限制字符数
        if updatedText.count > MaxWords {
            return false
        }
        return true
    }

    public func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.text.elementsEqual(PlaceholderText) {
            navigationItem.rightBarButtonItem?.isEnabled = !editText.isEmpty
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = !textView.text.elementsEqual(editText)
        }
    }
}

extension PersonalSignatureViewController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if item.rightBarButtonItem?.isEnabled == true {
            editTextView.resignFirstResponder()
            // showAlert in QYYExtension
            showAlert(title: "您的个性签名尚未保存，是否返回？", message: "", actionTitles: ["继续编辑", "返回"], preferIndex: nil) { [weak self] index in
                if index == 0 {
                    self?.editTextView.becomeFirstResponder()
                } else if index == 1 {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            return false
        }
        return true
    }
}

*/
