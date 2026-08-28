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
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
   
}

-(void)demo_skip {
    //skip：
    //1、创建信号
    RACSubject * subject = [RACSubject subject];
    
    //skip:跳过几个值，取后面的
    [[subject skip:2]subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //发送数据
    [subject sendNext:@"AA"];
    [subject sendNext:@"AA"];
    [subject sendNext:@"BB"];
    [subject sendNext:@"CC"];
    [subject sendNext:@"BB"];
}

-(void)demo_distinct {
    //1、创建信号
    RACSubject * subject = [RACSubject subject];
    
    // 忽略掉重复数据
    [[subject distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //发送数据
    [subject sendNext:@"AA"];
    [subject sendNext:@"AA"];
    [subject sendNext:@"BB"];
    [subject sendNext:@"CC"];
    [subject sendNext:@"BB"];
}

-(void)demo_take {
    //take:
    RACSubject * subject = [RACSubject subject];
    
    //创建一个专门的标记信号
    RACSubject * signal = [RACSubject subject];
    
    //1、take :指定拿前面的哪几条数据！！（从前往后）
    //2、takeLast : 指定拿后面的哪几条数据！！（从后往前） 注意：必须加上sendCompleted
//    [[subject takeLast:2] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    //3、takeUntil：直到你的标记信号发送数据的时候结束！！！
    [[subject takeUntil:signal] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //发送信号
    [subject sendNext:@"AA"];
    [signal sendNext:@""];     //标记信号
    [signal sendCompleted];    //标记信号
    [subject sendNext:@"CC"];
    [subject sendNext:@"BB"];
    //takelast 必须加上sendCompleted
    [subject sendCompleted];
}

-(void)demo_ignore {
    //ignore
    RACSubject * subject = [RACSubject subject];
    
    //忽略一些值
//    RACSignal * ignoreSignal = [[subject ignore:@"1"] ignore:@"2"];
    //忽略所有值
    RACSignal * ignoreSignal = [subject ignoreValues];
    
    //订阅信号
    [ignoreSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //发送数据
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    
}

-(void)demo_filter {
    //信号的忽略
    
    [[_textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        //value就是源信号的内容，
        NSLog(@"%@",value);
        //返回值就是过滤条件：只有满足条件，才能获取返回值
        return [value length] <= 5;
    }]subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
