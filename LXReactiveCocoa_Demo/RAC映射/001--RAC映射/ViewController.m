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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //flattenMap 一般用于信号中的信号
    RACSubject * signalOfSignal = [RACSubject subject];
    RACSubject * signal = [RACSubject subject];
    
    //订阅信号
//    方式一：
//    [signalOfSignal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
//    方式二：
//    [signalOfSignal.switchToLatest subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
//    方式三：
    RACSignal * bindSignal = [signalOfSignal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        //这里的value是一个信号
        return value;
    }];
    
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //发送数据
    [signalOfSignal sendNext:signal];
    [signal sendNext:@"1234"];
    
}

-(void)demo_flattenMap {
    //创建信号
    RACSubject * subject = [RACSubject subject];
    
    //绑定信号 ： 是为了将发过来的信号进行处理，然后在作为一个信号传递出去
    RACSignal * bindsignal = [subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        // block ：只要源信号发送内容，就会调用
        
        //value就是源信号发送的内容
        NSLog(@"Value == %@",value);
        
        //处理数据
        value = [NSString stringWithFormat:@"处理数据%@",value];
        
        //返回信号
        return [RACReturnSignal return:value];
    }];
    
    //订阅绑定信号，也就是处理过的值
    [bindsignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"修改过的 == %@",x);
    }];
    
    //发送数据
    [subject sendNext:@"ACB"];
    
}


-(void)demo_Map {
    //创建信号
    RACSubject * subject = [RACSubject subject];
    
    //绑定
    [[subject map:^id _Nullable(id  _Nullable value) {
        //返回的数据就是需要处理的数据
        
        return [NSString stringWithFormat:@"AAA %@",value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"CCC == %@",x);
    }];
    
    //发送信号
    [subject sendNext:@"ABC"];
    [subject sendNext:@"123"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
