//
//  ProjectModel.swift
//  LXSwift
//
//  Created by 林祥 on 2021/2/5.
//  Copyright © 2021 LX. All rights reserved.
//

import Foundation

class ProjectModel: NSObject ,Codable {
    var project_name: String = ""
    var project_manager: String = ""
    var project_create_time: String = ""
    var app_name: String = ""
    var ios_android: String = ""
    var ios_manager: String = ""
    var android_manager: String = ""
    var ios_update_time: String = ""
    var android_update_time: String = ""
    var ios_branch: String = ""
    var android_branch: String = ""
    var ios_download: String = ""
    var android_download: String = ""
    var test_account: String = ""
    var apple_account_password_owner: String = ""
    var ios_custom_made: String = ""
    var android_custom_made: String = ""
    var ios_feature: String = ""
    var android_feature: String = ""
    var ios_release_platform: String = ""
    var android_release_platform: String = ""
    
    // initialize
    init(project_name: String = "default",
         project_manager: String = "default",
         project_create_time: String = "Something is Missing!",
         app_name: String = "default",
         ios_android: String = "default" ) {
        self.project_name = project_name
        self.project_manager = project_manager
        self.project_create_time = project_create_time
        self.app_name = app_name
        self.ios_android = ios_android
    }
}
