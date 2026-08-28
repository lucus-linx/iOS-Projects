//
//  SecondViewController.m
//  LXReactiveCocoa_Demo
//
//  Created by linxiang on 2017/5/3.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "SecondViewController.h"

#import <ReactiveObjC/ReactiveObjC.h>

#import "Weak_StrongVC.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    
}
- (IBAction)click_demo_1:(id)sender {
    [self demo_1];
}
- (IBAction)click_demo_2:(id)sender {
    [self demo_2];
}
- (IBAction)click_demo_3:(id)sender {
    [self demo_RAC];
}
- (IBAction)click_demo_4:(id)sender {
    [self demo_RACObserve];
}
- (IBAction)click_demo_5:(id)sender {
    
    Weak_StrongVC * wsVC = [[Weak_StrongVC alloc]init];
    
    [self presentViewController:wsVC animated:YES completion:^{
        
    }];
    
}
- (IBAction)click_demo_6:(id)sender {
    [self demo_RACPack];
}

- (void)demo_1 {
    //RAC timer 定时器
    // 不需要管 RunLoop 和 多线程 直接干 
    [[RACSignal interval:1.0f onScheduler:[RACScheduler scheduler]]subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"AAAAAA = %@ == %@",x , [NSThread currentThread]);
    }];
    
}

-(void)demo_2 {
    // 多个请求 完毕之后 才进行调用
    
    //请求1
    RACSignal * signal_1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送信号
        NSLog(@"发送网络数据");
        //发送数据
        [subscriber sendNext:@"数据1 来了！！"];
        
        return nil;
    }];
    
    //请求2
    RACSignal * signal_2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送信号
        NSLog(@"发送网络数据");
        //发送数据
        [subscriber sendNext:@"数据2 来了！！"];
        
        return nil;
    }];
    
    //数组：存放信号
    //当数组中的所有信号都发送了数据，才会执行selector
    //参数：必须和数组的信号一一对应
    //参数：就是每一个信号发送的数据
    [self rac_liftSelector:@selector(updateUI::) withSignalsFromArray:@[signal_1,signal_2]];
    
}

-(void)updateUI:(id)data1 :(id)data2 {
    NSLog(@"%@",[NSThread currentThread]);
    
    NSLog(@"updateUI == %@ == %@",data1,data2);
}


#pragma mark -- RAC 宏

-(void)demo_RAC {
    //方法一：
    //监听文本框
    // * 文本信号 *
//    [_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"EEEEE == %@",x);
//    }];
    
    
    //方法二： 宏
    //给某个对象的某个属性绑定信号，一旦信号产生数据，就会将内容赋值给属性！！
    RAC(_showLabel,text) = _textField.rac_textSignal;
}

-(void)demo_RACObserve {
    
    //只要这个对象的属性发生改变，我就发送信号！！！
    //在这里就是 只要label的text文本发生变化，我就发送文本信号
    [RACObserve(self.showLabel, text) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //给某个对象的某个属性绑定信号，一旦信号产生数据，就会将内容赋值给属性！！
    RAC(_showLabel,text) = _textField.rac_textSignal;
}

-(void)demo_RACPack {
    //包装元祖
    RACTuple *tuple = RACTuplePack(@"abc", @"efg");
    
    //解包元祖
    RACTupleUnpack(NSString *string1,NSString *string2) = tuple;
    NSLog(@"%@---%@",string1,string2);
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
