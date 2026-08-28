//
//  FirstViewController.m
//  LXReactiveCocoa_Demo
//
//  Created by linxiang on 2017/5/3.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "FirstViewController.h"

#import <ReactiveObjC/ReactiveObjC.h>

#import "GreenView.h"


#import "NSObject+RACKVOWrapper.h"

@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet GreenView *GreenView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1、RAC代替代理 : RACSubject
//    [self demo_1];
    
    //2、代替监听KVO
//    [self demo_2];
    
    //3、监听事件
//    [self demo_3];
    
    
    //4、代替通知
//    [self demo_4];
  
    //5、监听文本框
    [self demo_5];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _GreenView.frame =CGRectMake(0, 0, 100, 100);
}


- (void)demo_1 {
    //1、RAC代替代理 : RACSubject
    //原理：监听greenview中的方法调用btnOnclick
    [[_GreenView rac_signalForSelector:@selector(btnOnclick:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"AAAAAA == %@",x);
    }];
    
    [[_GreenView rac_signalForSelector:@selector(PassValue::)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"AAAAAA == %@ == %@ == %@",x,x[0],x[1]);
    }];
}

- (void)demo_2 {
    //2、代替监听KVO
    
    //方法一：
    // observer 这里可以直接为 nil
    [_GreenView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        //回调
        NSLog(@"变化了 Value = %@ ; Change = %@",value,change);
    }];
    
    //方法二：
    // 前面是创建信息，然后直接订阅这个信号
    [[_GreenView rac_valuesForKeyPath:@"frame" observer:nil] subscribeNext:^(id  _Nullable x) {
        NSLog(@"BBBBBB == %@",x);
    }];
}

- (void)demo_3 {
    //3、监听事件
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        //打印出的就是按钮的本身
        NSLog(@"CCCC == %@",x);
        
    }];
}

-(void)demo_4 {
    //4、代替通知
    //键盘弹出 通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"DDDDD == %@",x);
    }];
    
}

-(void)demo_5 {
    //5、监听文本框
    // * 文本信号 *
    [_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"EEEEE == %@",x);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
