//
//  LoginRAC_ViewModel.h
//  TodayNews
//
//  Created by 林祥 on 2019/3/12.
//  Copyright © 2019 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginRAC_ViewModel : NSObject

/// 按钮能否点击
@property (nonatomic, strong, readonly) RACSignal * validLoginSignal;
/// 登录按钮点击执行的命令
@property (nonatomic, strong, readonly) RACCommand * loginCommond;

@property (nonatomic, copy, readwrite) NSString * username;
@property (nonatomic, copy, readwrite) NSString * password;

@property (nonatomic, copy, readwrite) NSString * avatarUrlString;

@end

NS_ASSUME_NONNULL_END
