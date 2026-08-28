//
//  Study_NSThreadVC.m
//  TodayNews
//
//  Created by linxiang on 2018/4/27.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_NSThreadVC.h"

@interface Study_NSThreadVC ()

@property (nonatomic, assign) NSInteger tickets;

@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation Study_NSThreadVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LXRandomColor;
    self.title = @"NSThread";

    float W = SCREEN_WIDTH/2;
    float H = 50;
    [self createBtn:CGRectMake(0, H, W, H) :1 :@"NSThread创建方式1"];
    [self createBtn:CGRectMake(W, H, W, H) :2 :@"NSThread创建方式2"];
    [self createBtn:CGRectMake(0, H*2, W, H) :3 :@"NSThread创建方式3"];
    
    [self createBtn:CGRectMake(0, H*3, W, H) :4 :@"NSThread休眠方式1"];
    [self createBtn:CGRectMake(W, H*3, W, H) :5 :@"NSThread休眠方式2"];
    
    [self createBtn:CGRectMake(0, H*4, W, H) :6 :@"NSThread退出"];
    
    [self createBtn:CGRectMake(0, H*5, W, H) :7 :@"NSThread非安全抢票"];
    [self createBtn:CGRectMake(W, H*5, W, H) :8 :@"NSThread安全抢票"];
    
    [self createBtn:CGRectMake(0, H*6, W, H) :9 :@"NSThread线程通讯1"];
    [self createBtn:CGRectMake(W, H*6, W, H) :10 :@"NSThread线程通讯2"];
    [self createBtn:CGRectMake(0, H*7, W, H) :11 :@"NSThread线程通讯3"];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, H*8, 100, 100)];
    _imageView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_imageView];
    
}


-(void)btnCallBack:(id)sender {
    UIButton * btn = (UIButton *)sender;
    
    if (btn.tag == 1) {
        [self creatNSThread1];
    }
    if (btn.tag == 2) {
        [self craeteNSThread2];
    }
    if (btn.tag == 3) {
        [self createNSThread3];
    }
    if (btn.tag == 4) {
        [self Thread_sleep1];
    }
    if (btn.tag == 5) {
        [self Thread_sleep2];
    }
    if (btn.tag == 6) {
        [self Thread_exit];
    }
    if (btn.tag == 7) {
        [self threadSecurity:NO];
    }
    if (btn.tag == 8) {
        [self threadSecurity:YES];
    }
    if (btn.tag == 9) {
        [self NSThread_Tongxun1];
    }
    if (btn.tag == 10) {
        [self NSThread_Tongxun2];
    }
    if (btn.tag == 11) {
        [self NSThread_Tongxun3];
    }
}

#pragma mark -- NSThrad Create

/**
 创建方法一：
 */
-(void)creatNSThread1{
    //创建NSThrad线程来处理卡顿
    NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(run:) object:@"thread1"];
    //线程命名
    thread.name = @"新线程";
    //启动
    [thread start];
}

/**
 创建方法二：
 */
-(void)craeteNSThread2{
    //从主线程中分离出的子线程，这种子线程不需要手动开启
    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"thread2"];
}

/**
 创建方法三：
 */
- (void)createNSThread3 {
    //开一个后台线程 （也属于子线程）
    [self performSelectorInBackground:@selector(run:) withObject:@"thread3"];
    
    [self performSelectorOnMainThread:@selector(mainCallBack:) withObject:@"main" waitUntilDone:YES];
    
    [self performSelectorInBackground:@selector(run:) withObject:@"thread4"];
}

-(void)run:(id)obj {
    
    for (int i = 0; i < 1000; i++) {
        NSLog(@"aa = %d",i);
    }
    
    NSLog(@"--%@ -- %@ --",[NSThread currentThread],obj);
    
    /*
        问：delay操作不会执行。为什么呢？？
        解：子线程执行完成就被销毁！不会存在RunLoop了，所以也就没有人去处理timer了
     */
    [self performSelector:@selector(delayCallBack) withObject:@"延迟执行" afterDelay:1.0f];
}

-(void)delayCallBack {
    NSLog(@"delayCallBack");
}

-(void)mainCallBack:(id)obj {
    
    NSLog(@"--mainCallBack-- %@ -- %@ --",[NSThread currentThread],obj);
    
    UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"aaa" message:@"BBB" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [view show];
}

#pragma mark -- NSThrad 休眠

-(void)Thread_sleep1
{
    [NSThread detachNewThreadSelector:@selector(run_Sleep_1:) toTarget:self withObject:@"Sleep_1"];
}

-(void)Thread_sleep2
{
    [NSThread detachNewThreadSelector:@selector(run_Sleep_2:) toTarget:self withObject:@"Sleep_2"];
}

-(void)run_Sleep_1:(id)obj {
    NSLog(@"--%@--%@--",[NSThread currentThread],obj);
    
    //休眠方式一：
    [NSThread sleepForTimeInterval:2.0];
    
    NSLog(@"run_Sleep_1 = %@",@"重新回来了");
}

-(void)run_Sleep_2:(id)obj {
    NSLog(@"--%@--%@--",[NSThread currentThread],obj);
    
    //休眠方式二： 从现在开始到 2 秒后启动
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    
    NSLog(@"run_Sleep_2 = %@",@"重新回来了");
}

#pragma mark -- NSThrad 退出

-(void)Thread_exit
{
    [NSThread detachNewThreadSelector:@selector(exit:) toTarget:self withObject:nil];
}

-(void)exit:(id)obj {
    NSLog(@"--%@--%@--",[NSThread currentThread],obj);
    for (int i = 0; i < 1000000; i++) {
        NSLog(@"i = %d",i++);
        if (i == 99) {
            //线程退出
            [NSThread exit];
        }
    }
}


#pragma mark -- NSThrad 线程安全
-(void)threadSecurity:(BOOL)sec {
    
    _tickets = 1000;
    
    if (sec) {
        NSThread * _thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(getTickets_sec) object:nil];
        NSThread * _thread2 = [[NSThread alloc]initWithTarget:self selector:@selector(getTickets_sec) object:nil];
        NSThread * _thread3 = [[NSThread alloc]initWithTarget:self selector:@selector(getTickets_sec) object:nil];
        
        _thread1.name = @"小米—1";
        _thread2.name = @"小明-2";
        _thread3.name = @"小丽-3";
        [_thread1 start];
        [_thread2 start];
        [_thread3 start];
    }else{
        NSThread * _thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(getTickets) object:nil];
        NSThread * _thread2 = [[NSThread alloc]initWithTarget:self selector:@selector(getTickets) object:nil];
        NSThread * _thread3 = [[NSThread alloc]initWithTarget:self selector:@selector(getTickets) object:nil];
        
        _thread1.name = @"小米—1";
        _thread2.name = @"小明-2";
        _thread3.name = @"小丽-3";
        [_thread1 start];
        [_thread2 start];
        [_thread3 start];
    }
}

-(void)getTickets{
    while (_tickets > 0) {
        NSInteger currentTickets = _tickets;
        if (currentTickets > 0) {
            NSLog(@"%@卖了一张票，还剩%ld张票",[NSThread currentThread].name,--_tickets);
        }else {
            NSLog(@"票已经卖完了！！！");
        }
    }
}

-(void)getTickets_sec{
    while (_tickets > 0) {
        
        //token 锁对象 【锁是同一个，并唯一】
        @synchronized (self) {
            NSInteger currentTickets = _tickets;
            if (currentTickets > 0) {
                NSLog(@"%@卖了一张票，还剩%ld张票",[NSThread currentThread].name,--_tickets);
            }else {
                NSLog(@"票已经卖完了！！！");
            }
        }
    }
}


#pragma mark -- NSThrad 线程通讯
-(void)NSThread_Tongxun1 {
    [NSThread detachNewThreadSelector:@selector(downLoadImage:) toTarget:self withObject:@"1"];
}
-(void)NSThread_Tongxun2 {
    [NSThread detachNewThreadSelector:@selector(downLoadImage:) toTarget:self withObject:@"2"];
}
-(void)NSThread_Tongxun3 {
    [NSThread detachNewThreadSelector:@selector(downLoadImage:) toTarget:self withObject:@"3"];
}


- (void)downLoadImage:(NSString *)obj {
    NSURL * url = [NSURL URLWithString:@"https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=628122556,790001397&fm=173&app=25&f=JPEG?w=218&h=146&s=9B97F1A262430AF40C30262B03000054"];
    NSData * data = [NSData dataWithContentsOfURL:url];
    UIImage * image = [UIImage imageWithData:data];
    
    //线程间通讯
    //由子线程回到主线程
    
    if ([obj isEqualToString:@"1"]) {
        //方法一
        [self performSelectorOnMainThread:@selector(loadImage:) withObject:image waitUntilDone:NO];
    }
    if ([obj isEqualToString:@"2"]) {
        //方法二：自己填入需要跳转到哪个线程
        [self performSelector:@selector(loadImage:) onThread:[NSThread mainThread] withObject:image waitUntilDone:NO];
    }
    if ([obj isEqualToString:@"3"]) {
        //方法三：imageView跳转到主线程，然后调用setImage方法
        [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    }
}
- (void)loadImage:(UIImage *)image {
    self.imageView.image = image;
}


#pragma mark -- CraeteView
-(void)createBtn:(CGRect)frame :(NSInteger)tag :(NSString *)title {
    UIButton * btn = [[UIButton alloc]initWithFrame:frame];
    btn.backgroundColor = LXRandomColor;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
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
