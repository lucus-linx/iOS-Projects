//
//  LoginViewModel.m
//  001--RAC映射
//
//  Created by linxiang on 2017/5/10.
//  Copyright © 2017年 TZ. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

-(instancetype)init {
    if (self = [super init]) {
        //初始化
        [self SetUp];
    }
    return self;
}


-(void)SetUp {
    
    //处理登录点击的信号
    _loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account),RACObserve(self, pwd)] reduce:^id _Nullable(NSString * accountStr,NSString * pwdStr){
        return @(accountStr.length && pwdStr.length);
    }];
    
    
    //RACCommand 创建命令
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //处理时间
        NSLog(@"准备发送请求 == %@",input);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            //密码加密。发送请求，获取登录结果
            [subscriber sendNext:@"请求登录的数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    //获取命令中的信号源
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //监听命令的执行过程
    [[_loginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        NSLog(@"执行过程 ：：%@",x);
        
        if ([x boolValue]) {
            //正在执行
            NSLog(@"显示菊花");
        }else{
            NSLog(@"干掉菊花");
        }
        
    }];


}

/*
//懒加载
-(RACCommand *)loginCommand {
    
}
 */




@end
