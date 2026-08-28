//
//  ViewController.m
//  001--RAC映射
//
//  Created by H on 2017/4/28.
//  Copyright © 2017年 TZ. All rights reserved.
//  flattenMap  Map

#import "ViewController.h"

#import <ReactiveObjC.h>
#import <RACReturnSignal.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //按钮是否可点击的信号
    RACSignal * loginEnableSignal = [RACSignal combineLatest:@[_accountField.rac_textSignal,_pwdField.rac_textSignal] reduce:^id _Nullable(NSString * accountStr, NSString * pwdStr){
        return @(accountStr.length && pwdStr.length);
    }];
    
    //设置按钮
    RAC(_loginBtn,enabled) = loginEnableSignal;
    
    //RACCommand 创建命令
    RACCommand * command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
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
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //监听命令的执行过程
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        NSLog(@"执行过程 ：：%@",x);
        
        if ([x boolValue]) {
            //正在执行
            NSLog(@"显示菊花");
        }else{
            NSLog(@"干掉菊花");
        }
        
    }];
    
    //监听登录按钮的点击事件
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"点击了登录按钮");
        
        //处理登录事件
        [command execute:@"账户 ： 密码"];
        
    }];
    
    
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
