//
//  ThirdVC.m
//  LXReactiveCocoa_Demo
//
//  Created by linxiang on 2017/5/8.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ThirdVC.h"

#import <ReactiveObjC/ReactiveObjC.h>

#import "RACReturnSignal.h"

@interface ThirdVC ()

@end

@implementation ThirdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self demo_RACCommand_USE];
}


-(void)demo_RACMulticastConnection {
    
    //不管订阅多少信号，就只会请求一次数据
    //RACMulticastConnection连接类：用于 当一个信号被多次订阅的时候，避免多次请求数据、、
    //1、创建信号
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送网络请求
        NSLog(@"发送请求");
        //发送请求到的数据
        [subscriber sendNext:@"请求到数据！！"];
        
        return nil;
    }];
    
    //2、将信号转成一个连接类
    RACMulticastConnection * connection = [signal publish];
    
    //3、订阅信号
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"AA 处理数据%@",x);
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"BB 处理数据%@",x);
    }];
    
    //4、链接
    [connection connect];
    
    
//    //订阅信号1
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"AA 处理数据%@",x);
//    }];
//    //订阅信号2
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"BB 处理数据%@",x);
//    }];
}


-(void)demo_RACCommand {
    
    // RACCommand 命令
    //1、创建命令
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        NSLog(@"%@",input);
        //input ： 指令
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            //发送数据
            [subscriber sendNext:@"执行完命令"];
            
            return nil;
        }];
    }];
    
    //订阅信号
    //executionSignals:信号源，，发送信号的信号。
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }];
        NSLog(@"%@",x);
    }];
    
    //switchToLatest 获取最新发送的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    //2、执行命令
    [command execute:@"执行命令参数"];
}

-(void)demo_switchToLatest {
    
    //创建多个信号
    RACSubject * signalOfSignal = [RACSubject subject];
    RACSubject * signal_1 = [RACSubject subject];
    RACSubject * signal_2 = [RACSubject subject];
    
    
    //订阅信号 switchToLatest:最新的信号
    [signalOfSignal.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //发送信号
    [signalOfSignal sendNext:signal_1];
    [signalOfSignal sendNext:signal_2];
    [signal_1 sendNext:@"1"];
    [signal_2 sendNext:@"2"];
}

-(void)demo_RACCommand_USE {
    
    // RACCommand 命令 == 对事件的一个操作
    //1、创建命令
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //input ： 指令
        NSLog(@"%@",input);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            //发送数据
            [subscriber sendNext:@"执行完命令之后产生的数据"];
            
            //发送完成
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    //监听事件有没有执行完毕
    [command.executing subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            NSLog(@"正在执行");
        }else{
            NSLog(@"已经结束了&&还没开始做");
        }
    }];
    
    
    //2、执行命令
    RACSignal * signal = [command execute:@"执行命令参数"];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收到了数据了:%@",x);
    }];
}

-(void)demo_bind {
    
    //bind
    //1、创建信号
    RACSubject * subject = [RACSubject subject];
    //2、绑定信号
    RACSignal * bindSignal = [subject bind:^RACSignalBindBlock _Nonnull{
        
        return ^RACSignal * (id value, BOOL * stop) {
            NSLog(@"AAAA == %@",value);
            //block调用：只要源信号发送数据，就会调用bindBlock
            //block作用：处理源信号内容
            
            //返回信号，不能传nil，返回空信号：[RACSignal empty]
//            return [RACSignal empty];
            
            return [RACReturnSignal return:value];
        };
    }];
    
    //3、订阅信号
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"BBB == %@",x);
    }];
    
    //4、发送数据
    [subject sendNext:@"发送原始的数据"];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
