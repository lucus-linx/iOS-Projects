//
//  Study_GCDUsefulVC.m
//  TodayNews
//
//  Created by linxiang on 2018/5/15.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_GCDUsefulVC.h"

@interface Study_GCDUsefulVC ()

@property (nonatomic, strong) UITextView * detailTV;

@property (nonatomic, strong) dispatch_semaphore_t semaphoreLock;
@property (nonatomic, assign) NSInteger ticketSurplusCount;




@end

@implementation Study_GCDUsefulVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LXRandomColor;
    self.title = @"GCD高级用法";
    
    float W = SCREEN_WIDTH;
    float H = 40;
    [self createBtn:CGRectMake(0, H*1, W, H) :1 :@"GCD栅栏-barrier Sync"];
    [self createBtn:CGRectMake(0, H*2, W, H) :2 :@"GCD栅栏-barrier ASync"];
    [self createBtn:CGRectMake(0, H*3, W, H) :3 :@"延时执行-dispatch_after"];
    [self createBtn:CGRectMake(0, H*4, W, H) :4 :@"执行一次-dispatch_once"];
    [self createBtn:CGRectMake(0, H*5, W, H) :5 :@"dispatch_apply在串行队列"];
    [self createBtn:CGRectMake(0, H*6, W, H) :6 :@"dispatch_apply在并行队列"];
    [self createBtn:CGRectMake(0, H*7, W, H) :7 :@"dispatch_apply是同步调用，不能在主队列执行"];
    [self createBtn:CGRectMake(0, H*8, W, H) :8 :@"GCD队列组：dispatch_group_notify"];
    [self createBtn:CGRectMake(0, H*9, W, H) :9 :@"GCD队列组：dispatch_group_wait"];
    [self createBtn:CGRectMake(0, H*10, W, H) :10 :@"GCD队列组：dispatch_group_enter/leave"];
    [self createBtn:CGRectMake(0, H*11, W, H) :11 :@"GCD信号量：dispatch_semaphore 线程同步"];
    [self createBtn:CGRectMake(0, H*12, W, H) :12 :@"GCD信号量：dispatch_semaphore 线程安全"];
    [self createBtn:CGRectMake(0, H*13, W, H) :13 :@"dispatch_suspend / resume"];
    
    _detailTV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, W, H)];
    _detailTV.text = @"细节";
    [self.view addSubview:_detailTV];
}

-(void)btnCallBack:(id)sender {
    UIButton * btn = (UIButton *)sender;
    
    if (btn.tag == 1) {
        _detailTV.text = @"异步执行两组操作，栅栏分开两组异步操作，dispatch_barrier_sync在主线程中执行栅栏中追加的任务";
        [self barrier:YES];
    }
    if (btn.tag == 2) {
        _detailTV.text = @"异步执行两组操作，栅栏分开两组异步操作，dispatch_barrier_async在子线程中执行栅栏中追加的任务";
        [self barrier:NO];
    }
    if (btn.tag == 3) {
        [self after];
    }
    if (btn.tag == 4) {
        [self once];
    }
    if (btn.tag == 5) {
        [self apply:YES];
    }
    if (btn.tag == 6) {
        [self apply:NO];
    }
    if (btn.tag == 7) {
        _detailTV.text = @"dispatch_apply函数是dispatch_sync函数和Dispatch Group的关联API。所以：dispatch_apply是一个同步调用，跟dispatch_sync一样在主队列中会崩溃";
    }
    if (btn.tag == 8) {
        [self groupNotify];
    }
    if (btn.tag == 9) {
        [self groupWait];
    }
    if (btn.tag == 10) {
        [self groupEnterAndLeave];
    }
    if (btn.tag == 11) {
        [self semaphoreSync];
    }
    if (btn.tag == 12) {
        
        _detailTV.text = @"dispatch_semaphore_create：创建一个Semaphore并初始化信号的总量;\ndispatch_semaphore_signal：发送一个信号，让信号总量加1\ndispatch_semaphore_wait：可以使总信号量减1，当信号总量为0时就会一直等待（阻塞所在线程），否则就可以正常执行。";
        
        [self initTicketStatusSave];
    }
    if (btn.tag == 13) {
        [self suspendQueue];
    }
}


/**
 * 栅栏方法 dispatch_barrier_async
 */
- (void)barrier:(BOOL)isSync {
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    if (isSync) {
        dispatch_barrier_sync(queue, ^{
            // 追加任务 barrier
            for (int i = 0; i < 2; ++i) {
                [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
                NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
            }
        });
    }else {
        dispatch_barrier_async(queue, ^{
            // 追加任务 barrier
            for (int i = 0; i < 2; ++i) {
                [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
                NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
            }
        });
    }
    
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
}

/**
 * 延时执行方法 dispatch_after
 */
- (void)after {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2.0秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);  // 打印当前线程
    });
}


/**
 * 一次性代码（只执行一次）dispatch_once
 */
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
        NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    });
}


/**
 * 快速迭代方法 dispatch_apply
 * 注意：dispatch_apply函数是dispatch_sync函数和Dispatch Group的关联API
 *         该函数按指定的次数将指定的Block追加到指定的Dispatch Queue中,并等到全部的处理执行结束
 * 所以：dispatch_apply是一个同步调用，跟dispatch_sync一样在主队列中会崩溃
 */
- (void)apply:(BOOL)isSerial {
    dispatch_queue_t queue = nil;
    if (isSerial) {
        _detailTV.text = @"循环执行，在主线程中依次执行，一个接一个";
        queue = dispatch_queue_create("net.testQueue", DISPATCH_QUEUE_SERIAL);
    } else {
        _detailTV.text = @"循环执行，多线程中并行";
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }

    NSLog(@"apply-begin---%@",[NSThread currentThread]);  // 打印当前线程
    dispatch_apply(6, queue, ^(size_t index) {
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"after-end---%@",[NSThread currentThread]);  // 打印当前线程
}


/**
 * 队列组 dispatch_group_notify
 */
- (void)groupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
}

/**
 * 队列组 dispatch_group_wait
 */
- (void)groupWait {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---end");
}

/**
 * 队列组 dispatch_group_enter、dispatch_group_leave
 * 这里的dispatch_group_enter、dispatch_group_leave组合，其实等同于dispatch_group_async。
 */
- (void)groupEnterAndLeave
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程.
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
    
    //    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    //    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //
    //    NSLog(@"group---end");
}


/**
 * semaphore 线程同步
 */
- (void)semaphoreSync {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    // 信号量 = 0
    
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务1
        [NSThread sleepForTimeInterval:5];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        
        number = 100;
        
        dispatch_semaphore_signal(semaphore);      // 信号量 + 1
    });
    
    // 当信号总量为0时就会一直等待（阻塞所在线程，当前为主线程），否则就可以正常执行。
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);     // 信号量 - 1
    NSLog(@"semaphore---end,number = %zd",number);
}

/**
 * 线程安全：使用 semaphore 加锁
 * 初始化火车票数量、卖票窗口(线程安全)、并开始卖票
 */
- (void)initTicketStatusSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");

    
    _semaphoreLock = dispatch_semaphore_create(1);
    
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
}

/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe {

    while (1) {
        // 相当于加锁
        dispatch_semaphore_wait(_semaphoreLock, DISPATCH_TIME_FOREVER);
        
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            
            // 相当于解锁
            dispatch_semaphore_signal(_semaphoreLock);
            break;
        }
        
        // 相当于解锁
        dispatch_semaphore_signal(_semaphoreLock);
    }
}


-(void)suspendQueue {
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);
    //提交第一个block，延时5秒打印。
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"五秒后打印，队列挂起时已经开始执行，");
    });
    //提交第二个block，也是延时5秒打印
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"队列挂起时未执行，需恢复队列后在执行");
    });
    //延时一秒
    NSLog(@"立刻打印~~~~~~~");
    [NSThread sleepForTimeInterval:1];
    //挂起队列
    NSLog(@"一秒后打印，队列挂起");
    dispatch_suspend(queue);
    //延时10秒
    [NSThread sleepForTimeInterval:10];
    NSLog(@"十秒后打印，开启队列");
    //恢复队列
    dispatch_resume(queue);
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
