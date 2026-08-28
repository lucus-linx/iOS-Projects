//
//  ViewController.m
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/3.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "ViewController.h"

#import "AFNetworking.h"

#import "LXLog.h"

#import <sys/sysctl.h>
#import <mach/mach.h>


#import<libkern/OSAtomic.h>

@interface ViewController ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *arr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.arr = [NSMutableArray new];
    
    
    float W = [UIScreen mainScreen].bounds.size.width/2;
    float H = 50;
    [self createBtn:CGRectMake(0, 50+H, W, H) :1 :@"主线程输出Log"];
    [self createBtn:CGRectMake(W, 50+H, W, H) :2 :@"子线程输出Log"];
    
    [self createBtn:CGRectMake(0, 100+H*2, W, H) :3 :@"开启timer-内存爆炸按钮"];
    [self createBtn:CGRectMake(W, 100+H*2, W, H) :4 :@"暂停timer-内存不变"];
    [self createBtn:CGRectMake(0, 100+H*3, W, H) :5 :@"关闭timer-内存清空"];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(test) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer setFireDate:[NSDate distantFuture]];

}


-(void)btnCallBack:(id)sender {
    UIButton * btn = (UIButton *)sender;
    
    if (btn.tag == 1) {
        if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
            LXLog(@"这里是主线程的log");
        }
    }
    if (btn.tag == 2) {
        //创建一个并发队列
        dispatch_queue_t queue = dispatch_queue_create("myueue", DISPATCH_QUEUE_CONCURRENT);
        
        //创建异步任务
        dispatch_async(queue, ^{
            for (int i = 0; i < 2; i++) {
                LXLog(@"--1--%@",[NSThread currentThread]);
            }
        });
    }
    
    if (btn.tag == 3) {
        [self.timer setFireDate:[NSDate distantPast]];
    }
    if (btn.tag == 4) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
    if (btn.tag == 5) {
        [self.timer invalidate];
        self.timer = nil;
    
        [self.arr removeAllObjects];
        self.arr = nil;
    }
}


-(void)test {
    int i = 0;
    while (i < 30000) {
        [self.arr addObject:[[NSObject alloc] init]];
        ++i;
    }
}


#pragma mark -- CraeteView
-(void)createBtn:(CGRect)frame :(NSInteger)tag :(NSString *)title {
    UIButton * btn = [[UIButton alloc]initWithFrame:frame];
    btn.backgroundColor = [UIColor blackColor];
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:30];
    [btn addTarget:self action:@selector(btnCallBack:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = frame.size.height/2;
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = [UIColor greenColor].CGColor;
    [self.view addSubview:btn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
