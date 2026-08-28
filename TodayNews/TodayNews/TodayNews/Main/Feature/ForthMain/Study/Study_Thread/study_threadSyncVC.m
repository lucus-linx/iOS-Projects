//
//  study_threadSyncVC.m
//  TodayNews
//
//  Created by linxiang on 2018/5/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "study_threadSyncVC.h"

@interface study_threadSyncVC ()

@property (nonatomic, strong) UITextView * detailTV;

@end

@implementation study_threadSyncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LXRandomColor;
    self.title = @"线程同步";
    
    float W = SCREEN_WIDTH;
    float H = 50;
    [self createBtn:CGRectMake(0, H*1, W, H) :1 :@"GCD栅栏-dispatch_barrier"];
    [self createBtn:CGRectMake(0, H*2, W, H) :2 :@"GCD组队列-dispatch_group"];
    [self createBtn:CGRectMake(0, H*3, W, H) :3 :@"GCD信号量-dispatch_semaphore 并发=5"];
//    [self createBtn:CGRectMake(0, H*4, W, H) :4 :@"执行一次-dispatch_once"];
//    [self createBtn:CGRectMake(0, H*5, W, H) :5 :@"dispatch_apply在串行队列"];
//    [self createBtn:CGRectMake(0, H*6, W, H) :6 :@"dispatch_apply在并行队列"];
//    [self createBtn:CGRectMake(0, H*7, W, H) :7 :@"dispatch_apply是同步调用，不能在主队列执行"];
//    [self createBtn:CGRectMake(0, H*8, W, H) :8 :@"GCD队列组：dispatch_group_notify"];
//    [self createBtn:CGRectMake(0, H*9, W, H) :9 :@"GCD队列组：dispatch_group_wait"];
//    [self createBtn:CGRectMake(0, H*10, W, H) :10 :@"GCD队列组：dispatch_group_enter/leave"];
//    [self createBtn:CGRectMake(0, H*11, W, H) :11 :@"GCD信号量：dispatch_semaphore 线程同步"];
//    [self createBtn:CGRectMake(0, H*12, W, H) :12 :@"GCD信号量：dispatch_semaphore 线程安全"];
//    [self createBtn:CGRectMake(0, H*13, W, H) :13 :@"dispatch_suspend / resume"];
    
    _detailTV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, W, H)];
    _detailTV.text = @"细节";
    [self.view addSubview:_detailTV];
}


-(void)btnCallBack:(id)sender {
    UIButton * btn = (UIButton *)sender;
    
    if (btn.tag == 1) {
        [self barrier];
    }
    if (btn.tag == 2) {
        [self group];
    }
    if (btn.tag == 3) {
        [self semaphore];
    }
}

// GCD栅栏-dispatch_barrier
-(void)barrier {
    /* 创建并发队列 */
    dispatch_queue_t concurrentQueue = dispatch_queue_create("test.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    /* 添加两个并发操作A和B，即A和B会并发执行 */
    dispatch_async(concurrentQueue, ^(){
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"OperationA");
    });
    dispatch_async(concurrentQueue, ^(){
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"OperationB");
    });
    /* 添加barrier障碍操作，会等待前面的并发操作结束，并暂时阻塞后面的并发操作直到其完成 */
    dispatch_barrier_async(concurrentQueue, ^(){
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"OperationBarrier!");
    });
    /* 继续添加并发操作C和D，要等待barrier障碍操作结束才能开始 */
    dispatch_async(concurrentQueue, ^(){
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"OperationC");
    });
    dispatch_async(concurrentQueue, ^(){
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"OperationD");
    });
}

-(void)group {
    
    __block NSString * A = @"";
    __block NSString * B = @"";
    __block NSString * C = @"";
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        /*加载图片1 */
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"加载图片1");
        A = @"加载图片1";
    });
    dispatch_group_async(group, queue, ^{
        /*加载图片2 */
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"加载图片2");
        B = @"加载图片2";
    });
    dispatch_group_async(group, queue, ^{
        /*加载图片3 */
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"加载图片3");
        C = @"加载图片3";
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 合并图片… …
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"合并 = %@ + %@ + %@",A,B,C);
    });
}

// 信号量
-(void)semaphore {
    /* 创建一个信号量并初始化为5 */
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(5);
    
    /* 模拟1000个等待执行的任务，通过信号量控制最大并发任务数量为5 */
    for (int i = 0; i < 100; i++) {
        /* 任务i */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /* 耗时任务1，执行前等待信号使信号量减1 */
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"任务%d开始", i);
            [NSThread sleepForTimeInterval:(arc4random() % 5 + 1)];   // 耗时操作随机[1,6)
            NSLog(@"任务%d结束", i);
            /* 任务i结束，发送信号释放一个资源 */
            dispatch_semaphore_signal(semaphore);
        });
    }
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
