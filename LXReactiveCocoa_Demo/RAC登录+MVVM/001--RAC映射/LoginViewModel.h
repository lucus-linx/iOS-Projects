//
//  LoginViewModel.h
//  001--RAC映射
//
//  Created by linxiang on 2017/5/10.
//  Copyright © 2017年 TZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface LoginViewModel : NSObject

/* 账号 摩玛 */
@property (nonatomic, strong) NSString * account;
@property (nonatomic, strong) NSString * pwd;

/**
 处理登录按钮能否点击的信号
 */
@property (nonatomic, strong) RACSignal * loginEnableSignal;


/**
 处理登录的命令
 */
@property (nonatomic, strong) RACCommand * loginCommand;


-(void)SetUp;

@end
