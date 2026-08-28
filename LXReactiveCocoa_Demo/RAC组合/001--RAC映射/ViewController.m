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
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //组合的应用
    
//    _nameTextField.rac_textSignal
    //reduceBlock的参数：根据组合的信号来的，必须一一对应
    RACSignal * signal = [RACSignal combineLatest:@[_nameTextField.rac_textSignal,_pwdTextField.rac_textSignal] reduce:^id _Nullable(NSString * nameStr,NSString * pwdStr){
        NSLog(@"name == %@ pwd == %@",nameStr,pwdStr);
        return @(nameStr.length && pwdStr.length);
    }];
    
    //方法一：
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@#",x);
//        _loginBtn.enabled = [x boolValue];
//    }];
    
    //方法二：
    RAC(_loginBtn,enabled) = signal;

}

-(void)demo_concat {
    //组合
    //创建信号
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送信号A");
        //发送数据
        [subscriber sendNext:@"数据AA"];
        
        //提交完成
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送信号A");
        //发送数据
        [subscriber sendNext:@"数据BB"];
        
        //提交完成
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal * signalC = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送信号C");
        //发送数据
        [subscriber sendNext:@"数据CC"];
        
        //提交完成
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    //concat : 按顺序组合！！！
    //创建组合信号！！合并成一个新的信号
    //方法一：
    //    RACSignal * concatSignal = [[signalA concat:signalB] concat:signalC];
    //方法二：
    RACSignal * concatSignal = [RACSignal concat:@[signalA,signalB,signalC]];
    
    //订阅组合信号
    [concatSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
}

-(void)demo_then {
    
    //创建信号
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送信号A");
        //发送数据
        [subscriber sendNext:@"数据AA"];
        
        //提交完成
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送信号B");
        //发送数据
        [subscriber sendNext:@"数据BB"];
        
        //提交完成
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    
    //then : 忽略掉第一个信号的所有的值！
    // A信号发送完毕了，接收B信号的数据  不需要A的数据，即：B依赖A的完成，但不需要A的数据。
    RACSignal * thenSignal = [signalA then:^RACSignal * _Nonnull{
        return signalB;
    }];
    
    //订阅信号
    [thenSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

-(void)demo_merge {
    //创建信号
    RACSubject * signalA = [RACSubject subject];
    RACSubject * signalB = [RACSubject subject];
    RACSubject * signalC = [RACSubject subject];
    
    //组合信号
//方式一：
//    RACSignal * mergeSignal = [signalA merge:signalB];
//方式二：
    RACSignal * mergeSignal = [RACSignal merge:@[signalA,signalB,signalC]];
    
    //订阅
    [mergeSignal subscribeNext:^(id  _Nullable x) {
        //任意一二信号发送内容就会来这个Block
        NSLog(@"%@",x);
    }];
    
    
    //发送数据
    [signalA sendNext:@"数据AA"];
    [signalB sendNext:@"数据BB"];
    [signalC sendNext:@"数据CC"];
    
}

-(void)demo_zip {
    //zipWith: 把两个信号压缩成一个信号，只有当两个信号同时发出信号，并将内容合并成一个元祖给你
    //创建信号
    RACSubject * signalA = [RACSubject subject];
    RACSubject * signalB = [RACSubject subject];
    
    //压缩
    RACSignal * zipSignal = [signalA zipWith:signalB];
    
    [zipSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [signalA sendNext:@"AA"];
    [signalB sendNext:@"BB"];
    
    [signalA sendNext:@"AA_1"];
    [signalB sendNext:@"BB_1"];
    
    [signalA sendNext:@"AA_2"];
    //    [signalB sendNext:@"BB_2"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
