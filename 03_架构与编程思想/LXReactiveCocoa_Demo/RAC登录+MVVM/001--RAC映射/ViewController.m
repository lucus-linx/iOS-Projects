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

#import "LoginViewModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

/** VM */
@property (nonatomic, strong) LoginViewModel * loginVM;

@end

@implementation ViewController

/**
 懒加载

 @return LoginViewModel
 */
-(LoginViewModel *)loginVM {
    if (_loginVM == nil) {
        _loginVM = [[LoginViewModel alloc]init];
    }
    return _loginVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //MVVM -- M 模型 V 视图+控制器 VM 视图模型
    //VM(给C瘦身) : 这就是MVVM框架的一个亮点！！ 代替控制器做很多的逻辑处理！！
    
    //1、给视图模型的账号绑定信号
    RAC(self.loginVM,account) = _accountField.rac_textSignal;
    RAC(self.loginVM,pwd) = _pwdField.rac_textSignal;
    
    //2、设置按钮
    RAC(_loginBtn,enabled) = self.loginVM.loginEnableSignal;
    
    //监听登录按钮的点击事件
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"点击了登录按钮");
        
        //处理登录事件
        [self.loginVM.loginCommand execute:@"账户 ： 密码"];
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
