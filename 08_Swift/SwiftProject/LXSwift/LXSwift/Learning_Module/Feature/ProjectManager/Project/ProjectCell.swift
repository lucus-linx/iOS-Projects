//
//  ProjectCell.swift
//  LXSwift
//
//  Created by 林祥 on 2021/2/19.
//  Copyright © 2021 LX. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {
    // 存储属性 占用内存
    private var _model: ProjectModel?
    // 计算属性 不占用内存
    var model: ProjectModel? {
        set {
            // 给存储属性赋值
            self._model = newValue
            
            // 刷新
            var app_name: String = self._model?.app_name ?? ""
            if app_name.isEmpty {
                app_name = "XXX"
            }
            firstLabel.text = "APP名称：" + app_name
            
            var image_name: String
            if app_name == "AAA" {
                image_name = "fb_education"
            } else if app_name == "" {
                image_name = "fb_events"
            } else if app_name == "" {
                image_name = "fb_friends"
            } else {
                image_name = "default_avatar"
            }
            avatarImageView.image = UIImage(named: image_name)
            
            var project_manager: String = self._model?.project_manager ?? ""
            if project_manager.isEmpty {
                project_manager = "XXX"
            }
            secondLabel.text = "项目经理：" + project_manager
            
            let ios_android: String = self._model?.ios_android ?? "none"
            thirdLabel.text = "类型：" + ios_android
            
            var ios_release_platform: String = self._model?.ios_release_platform ?? ""
            if ios_release_platform.isEmpty {
                ios_release_platform = "未发布"
            }
            forthLabel.text = "iOS发布平台：" + ios_release_platform

            var ios_update_time: String = self._model?.ios_update_time ?? ""
            if ios_update_time.isEmpty {
                ios_update_time = ""
            }
            // 时间格式
            let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let updateDate = dateFormatter.date(from: ios_update_time)
            //
            let shortFormatter = DateFormatter.init()
            shortFormatter.dateFormat = "yyyy-MM-dd"
            // 视图区分
            if self._model?.ios_release_platform == "TestFlight" {
                // TF过期时间，90天过期
                let nextTime: TimeInterval = TimeInterval(24*60*60*90)  // 这是90天后的时间
                let expiredDate = updateDate?.addingTimeInterval(nextTime)
                fifthLabel.text = "iOS过期时间：" + shortFormatter.string(from: expiredDate ?? Date())
                self.backgroundColor = .lightGray
            } else {
                fifthLabel.text = "iOS更新时间：" + shortFormatter.string(from: updateDate ?? Date())
                self.backgroundColor = .white
            }
        }
        get {
            // 返回新的存储属性
            return self._model
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ========== UI ==========
    func setupView() {
        self.backgroundColor = Specs.color.white
        // addSubview
        self.addSubview(avatarImageView)
        self.addSubview(firstLabel)
        addSubview(secondLabel)
        addSubview(thirdLabel)
        addSubview(forthLabel)
        addSubview(fifthLabel)
        addSubview(lineView)
        // Layout
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        firstLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp_rightMargin).offset(20)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        secondLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(firstLabel)
            make.top.equalTo(firstLabel.snp.bottom)
        }
        thirdLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(firstLabel)
            make.top.equalTo(secondLabel.snp.bottom)
        }
        forthLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(firstLabel)
            make.top.equalTo(thirdLabel.snp.bottom)
        }
        fifthLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(firstLabel)
            make.top.equalTo(forthLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(-10)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp_leftMargin)
            make.height.equalTo(0.5)
            make.bottom.right.equalToSuperview()
        }
        
        firstLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        secondLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        thirdLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        forthLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        fifthLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
    }

    // MARK: - ========== Set&Get ==========
    let avatarImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.backgroundColor = UIColor.clear
        imageview.image = UIImage(named: "default_avatar")
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    let firstLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "XXX"
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.textColor = Specs.color.black
        label.font = Specs.font.largeBold
        label.numberOfLines = 0
        return label
    }()
    let secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "XXX"
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.textColor = Specs.color.black
        label.font = Specs.font.largeBold
        label.numberOfLines = 0
        return label
    }()
    let thirdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "XXX"
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.textColor = Specs.color.black
        label.font = Specs.font.largeBold
        label.numberOfLines = 0
        return label
    }()
    let forthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "XXX"
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.textColor = Specs.color.black
        label.font = Specs.font.largeBold
        label.numberOfLines = 0
        return label
    }()
    let fifthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "XXX"
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.textColor = Specs.color.black
        label.font = Specs.font.largeBold
        label.numberOfLines = 0
        return label
    }()
    let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Specs.color.gray
        return view
    }()
}

