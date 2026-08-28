//
//  Study_GCDBaseUseVC.m
//  TodayNews
//
//  Created by linxiang on 2018/5/15.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_GCDBaseUseVC.h"

@interface Study_GCDBaseUseVC ()

@property (nonatomic, strong) UITextView * detailTV;

@end

@implementation Study_GCDBaseUseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LXRandomColor;
    self.title = @"GCD基本使用";
    
    float W = SCREEN_WIDTH;
    float H = 40;
    [self createBtn:CGRectMake(0, 0, W, H) :1 :@"GCD创建队列方式,请查看代码"];
    [self createBtn:CGRectMake(0, H*1, W, H) :2 :@"GCD创建任务方式,请查看代码"];
    
    [self createBtn:CGRectMake(0, H*2, W, H) :3 :@"同步执行 + 并发队列"];
    [self createBtn:CGRectMake(0, H*3, W, H) :4 :@"异步执行 + 并发队列"];
    [self createBtn:CGRectMake(0, H*4, W, H) :5 :@"同步执行 + 串行队列"];
    [self createBtn:CGRectMake(0, H*5, W, H) :6 :@"异步执行 + 串行队列"];
    [self createBtn:CGRectMake(0, H*6, W, H) :7 :@"全局并发队列 + 同步执行"];
    [self createBtn:CGRectMake(0, H*7, W, H) :8 :@"全局并发队列 + 异步执行"];
    [self createBtn:CGRectMake(0, H*8, W, H) :9 :@"主线程执行『主队列 + 同步执行』"];
    [self createBtn:CGRectMake(0, H*9, W, H) :10 :@"其他线程执行『主队列 + 同步执行』"];
    [self createBtn:CGRectMake(0, H*10, W, H) :11 :@"主队列 + 异步执行"];
    [self createBtn:CGRectMake(0, H*11, W, H) :12 :@"GCD线程通讯+同步执行主队列操作"];
    [self createBtn:CGRectMake(0, H*12, W, H) :13 :@"GCD线程通讯+异步执行主队列操作"];
    
    _detailTV = [[UITextView alloc]initWithFrame:CGRectMake(0, H*13, W, 100)];
    _detailTV.text = @"细节";
    [self.view addSubview:_detailTV];
}


-(void)btnCallBack:(id)sender {
    UIButton * btn = (UIButton *)sender;
    
    if (btn.tag == 3) {
        [self concurrentSync];
    }
    if (btn.tag == 4) {
        [self concurrentASync];
    }
    if (btn.tag == 5) {
        [self serialSync];
    }
    if (btn.tag == 6) {
        [self serialASync];
    }
    if (btn.tag == 7) {
        [self globalSync];
    }
    if (btn.tag == 8) {
        [self globalASync];
    }
    if (btn.tag == 9) {
        _detailTV.text = @"主线程执行『主队列 + 同步执行』\n特点(主线程调用)：互等卡主不执行。\n特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。";
        
        [self performSelectorOnMainThread:@selector(mainSync) withObject:@"main" waitUntilDone:YES];
    }
    if (btn.tag == 10) {
        _detailTV.text = @"其他线程执行『主队列 + 同步执行』\n特点(主线程调用)：互等卡主不执行。\n特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。";
        
        // 使用 NSThread 的 detachNewThreadSelector 方法会创建线程，并自动启动线程执行selector 任务
        [NSThread detachNewThreadSelector:@selector(mainSync) toTarget:self withObject:nil];
    }
    if (btn.tag == 11) {
        [self mainASync];
    }
    if (btn.tag == 12) {
        [self thread_communicate:YES];
    }
    if (btn.tag == 13) {
        [self thread_communicate:NO];
    }
}

#pragma mark -- 创建队列
-(void)CreatQueue {
    /*
     作者：行走的少年郎
     链接：https://juejin.im/post/5a90de68f265da4e9b592b40
     来源：掘金
     著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
     */
    
    // 串行队列的创建方法
    dispatch_queue_t queue1 = dispatch_queue_create("net.testQueue", DISPATCH_QUEUE_SERIAL);
    // 并发队列的创建方法
    dispatch_queue_t queue2 = dispatch_queue_create("net.testQueue", DISPATCH_QUEUE_CONCURRENT);
   
    /*
     * 主队列（Main Dispatch Queue）是GCD提供的一种特殊的串行队列。
     * * 所有放在主队列中的任务，都会放到主线程中执行。
     * * 可使用dispatch_get_main_queue()获得主队列。
     */
    // 主队列的获取方法
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    
    /*
     * 对于并发队列，GCD 默认提供了全局并发队列（Global Dispatch Queue）。
     * 可以使用dispatch_get_global_queue来获取。需要传入两个参数。
     * 第一个参数表示队列优先级，一般用DISPATCH_QUEUE_PRIORITY_DEFAULT。
     * 第二个参数暂时没用，用0即可。
     */
    // 全局并发队列的获取方法
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

#pragma mark -- 任务创建
-(void)createTask {
    dispatch_queue_t queue = nil;
    
    // 同步执行任务创建方法
    dispatch_sync(queue, ^{
        // 这里放同步执行任务代码
    });
    // 异步执行任务创建方法
    dispatch_async(queue, ^{
        // 这里放异步执行任务代码
    });
}

#pragma mark -- 任务+队列组合技
/**
 * 同步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)concurrentSync {
    
    _detailTV.text = @"同步执行 + 并发队列 \n特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。";
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    //创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    
    //在队列里面添加任务
    //同步任务
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@" --1-- %@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@" --2-- %@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@" --3-- %@",[NSThread currentThread]);
        }
    });
}

/**
 * 异步执行 + 并发队列
 * 特点：可以开启多个线程，任务交替（同时）执行。
 */
-(void)concurrentASync {
    
    _detailTV.text = @"异步执行 + 并发队列 \n特点：可以开启多个线程，任务交替（同时）执行。";
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    
    //创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("myueue", DISPATCH_QUEUE_CONCURRENT);
    
    //创建异步任务
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--1--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--2--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--3--%@",[NSThread currentThread]);
        }
    });
}


/**
 * 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)serialSync {
    _detailTV.text = @"同步执行 + 串行队列\n特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。";
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    //第二个参数NULL表示串行队列  == DISPATCH_QUEUE_SERIAL
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_SERIAL);
    
    //同步队列
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--1--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--2--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--3--%@",[NSThread currentThread]);
        }
    });
}


/**
 * 异步执行 + 串行队列
 * 特点：会开启一个新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)serialASync {
    _detailTV.text = @"异步执行 + 串行队列\n特点：会开启一个新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。";
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    //第二个参数NULL表示串行队列  == DISPATCH_QUEUE_SERIAL
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_SERIAL);
    
    //同步队列
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--1--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--2--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--3--%@",[NSThread currentThread]);
        }
    });
}

/**
 * 全局队列 + 同步执行   ====   同步执行 + 并发队列
 * 没有开启新的线程，任务是逐步完成的
 */
-(void)globalSync {
    
    _detailTV.text = @"全局队列 + 同步执行   ====   同步执行 + 并发队列\n特点：全局队列可当做普通并发队列，没有开启新的线程，任务是逐步完成的";
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    //获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    //同步任务
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--1--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--2--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--3--%@",[NSThread currentThread]);
        }
    });
}


/**
 * 全局队列 + 异步执行   ====   异步执行 + 并发队列
 * 特点：可以开启多个线程，任务交替（同时）执行。
 */
-(void)globalASync {
    _detailTV.text = @"全局队列 + 异步执行   ====   异步执行 + 并发队列\n特点：全局队列可当做普通并发队列，可以开启多个线程，任务交替（同时）执行。";
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    //获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    //同步任务
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--1--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--2--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--3--%@",[NSThread currentThread]);
        }
    });
}


/**
 * 同步执行 + 主队列
 * 特点(主线程调用)：互等卡主不执行。
 * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
 */
-(void)mainSync {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    //获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //同步任务
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--1--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--2--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--3--%@",[NSThread currentThread]);
        }
    });
}

/**
 * 异步执行 + 主队列
 * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
-(void)mainASync {
    
    _detailTV.text = @"异步执行 + 主队列\n特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务";
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    //获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //同步任务
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--1--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--2--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
            NSLog(@"--3--%@",[NSThread currentThread]);
        }
    });
}

/**
 线程之间通信
 */
-(void)thread_communicate:(BOOL)isSync {
    //异步操作
    /*获取全局并发队列 dispatch_get_global_queue（0，0）
     第一个参数：优先级 默认为0
     第二个参数：预留 无用
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //耗时操作
        NSURL * url = [NSURL URLWithString:@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3482280360,3588972096&fm=173&app=25&f=JPEG?w=218&h=146&s=C81252964AD178C2280B08400300A0F8"];
        NSData * data = [NSData dataWithContentsOfURL:url];
        UIImage * image = [UIImage imageWithData:data];
        [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
        NSLog(@" --4-- %@",[NSThread currentThread]);
        
        if (isSync) {
            //回到主队列，进行图片加载
            dispatch_sync(dispatch_get_main_queue(), ^{
                [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
                NSLog(@" --5-- %@",[NSThread currentThread]);
                // ... 加载
            });
        } else {
            //回到主队列，进行图片加载
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSThread sleepForTimeInterval:1];    // 模拟耗时操作
                NSLog(@" --5-- %@",[NSThread currentThread]);
                // ... 加载
            });
        }

        NSLog(@" --6-- %@",[NSThread currentThread]);
        
        //回到主队列，执行同步、异步的操作的差异，同下面这个函数最后一个的 “waitUntilDone”
//        [self performSelectorOnMainThread:nil withObject:nil waitUntilDone:YES];
    });
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
