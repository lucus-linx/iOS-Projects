//
//  study_threadSecureVC.m
//  TodayNews
//
//  Created by linxiang on 2018/5/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "study_threadSecureVC.h"

#import <pthread/pthread.h>

#import <libkern/OSAtomic.h>

@interface study_threadSecureVC ()
@property (nonatomic, strong) UITextView * detailTV;

@property (nonatomic, strong) dispatch_queue_t synQueue;

@end



@implementation study_threadSecureVC

@synthesize nonatomic_str = _nonatomic_str;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LXRandomColor;
    self.title = @"线程安全";
    
    // 创建串行队列，执行同步任务
    _synQueue = dispatch_queue_create("net.testQueue", DISPATCH_QUEUE_SERIAL);
    
/*  参考文档
    作者：景铭巴巴
    鏈接：https://www.jianshu.com/p/938d68ed832c#
    來源：簡書
    著作權歸作者所有。商業轉載請聯繫作者獲得授權，非商業轉載請註明出處。
 */
    float W = SCREEN_WIDTH;
    float H = 50;
    [self createBtn:CGRectMake(0, H*1, W, H) :1 :@"synchronized"];
    [self createBtn:CGRectMake(0, H*2, W, H) :2 :@"dispatch_semaphore - GCD"];
    [self createBtn:CGRectMake(0, H*3, W, H) :3 :@"NSLock - Cocoa"];
    [self createBtn:CGRectMake(0, H*4, W, H) :4 :@"NSRecursiveLock递归锁"];
    [self createBtn:CGRectMake(0, H*5, W, H) :5 :@"NSConditionLock条件锁"];
    [self createBtn:CGRectMake(0, H*6, W, H) :6 :@"NSCondition"];
    [self createBtn:CGRectMake(0, H*7, W, H) :7 :@"pthread_mutex - C语言"];
    [self createBtn:CGRectMake(0, H*8, W, H) :8 :@"pthread_mutex(recursive) - C语言"];
    [self createBtn:CGRectMake(0, H*9, W, H) :9 :@"OSSpinLock - 已经不安全了"];
    [self createBtn:CGRectMake(0, H*10, W, H) :10 :@"atomic 属性原子性"];
    [self createBtn:CGRectMake(0, H*11, W, H) :11 :@"重写getter/setter注意事项 - 看代码"];
    
    _detailTV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, W, H)];
    _detailTV.text = @"OSSpinLock > dispatch_semaphore > pthread_mutex > NSLock > NSCondition > pthread_mutex(recursive) > NSRecursiveLock > NSConditionLock >synchronized";
    [self.view addSubview:_detailTV];
}


-(void)btnCallBack:(id)sender {
    UIButton * btn = (UIButton *)sender;
    
    if (btn.tag == 1) {
        _detailTV.text = @"";
        [self synchronized];
    }
    if (btn.tag == 2) {
        _detailTV.text = @"dispatch_semaphore是GCD用来同步的一种方式";
        [self semaphore];
    }
    if (btn.tag == 3) {
        _detailTV.text = @"NSLock是Cocoa提供给我们最基本的锁对象";
        [self NSLock];
    }
    if (btn.tag == 4) {
        _detailTV.text = @"递归锁:NSRecursiveLock实际上定义的是一个递归锁，这个锁可以被同一线程多次请求，而不会引起死锁。这主要是用在循环或递归操作中。";
        [self NSRecursiveLock];
    }
    if (btn.tag == 5) {
        _detailTV.text = @"NSConditionLock条件锁";
        [self NSConditionLock];
    }
    if (btn.tag == 6) {
        _detailTV.text = @"";
        [self NSCondition];
    }
    if (btn.tag == 7) {
        _detailTV.text = @"";
        [self pthread_mutex];
    }
    if (btn.tag == 8) {
        _detailTV.text = @"";
        [self pthread_mutex_Recursive];
    }
    if (btn.tag == 9) {
        _detailTV.text = @"";
        [self OSSpinLock];
    }
    if (btn.tag == 10) {
        _detailTV.text = @"";
        [self nonatomic_TEST];
    }
    
    
}


-(void)synchronized {
    NSObject *obj = [[NSObject alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized(obj) {
            NSLog(@"需要线程同步的操作1 开始");
            [NSThread sleepForTimeInterval:3];              // 模拟耗时操作
            NSLog(@"需要线程同步的操作1 结束");
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"我在锁外面");
        @synchronized(obj) {
            NSLog(@"需要线程同步的操作2");
        }
    });
}


-(void)semaphore {
    dispatch_semaphore_t signal = dispatch_semaphore_create(1);
    dispatch_time_t overTime = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(signal, overTime);
        NSLog(@"需要线程同步的操作1 开始");
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"需要线程同步的操作1 结束");
        dispatch_semaphore_signal(signal);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(signal, overTime);
        NSLog(@"需要线程同步的操作2");
        dispatch_semaphore_signal(signal);
    });
}

-(void)NSLock {
    NSLock *lock = [[NSLock alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[lock lock];
        [lock lockBeforeDate:[NSDate date]];
        NSLog(@"需要线程同步的操作1 开始");
        sleep(2);
        NSLog(@"需要线程同步的操作1 结束");
        [lock unlock];
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        if ([lock tryLock]) {//尝试获取锁，如果获取不到返回NO，不会阻塞该线程
            NSLog(@"锁可用的操作");
            [lock unlock];
        }else{
            NSLog(@"锁不可用的操作");
        }
        
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:3];
        if ([lock lockBeforeDate:date]) {//尝试在未来的3s内获取锁，并阻塞该线程，如果3s内获取不到恢复线程, 返回NO,不会阻塞该线程
            NSLog(@"没有超时，获得锁");
            [lock unlock];
        }else{
            NSLog(@"超时，没有获得锁");
        }
        
    });
}


/**
 递归锁:NSRecursiveLock实际上定义的是一个递归锁，这个锁可以被同一线程多次请求，而不会引起死锁。这主要是用在循环或递归操作中。
 */
-(void)NSRecursiveLock {
//    NSLock *lock = [[NSLock alloc] init];
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        static void (^RecursiveMethod)(int);
        
        RecursiveMethod = ^(int value) {
            
            [lock lock];
            NSLog(@"递归锁 加锁");
            if (value > 0) {
                
                NSLog(@"value = %d", value);
                sleep(1);
                RecursiveMethod(value - 1);
            }
            [lock unlock];
            NSLog(@"递归锁 解锁");
        };
        
        RecursiveMethod(5);
    });
 
}


-(void)NSConditionLock {
    
    NSConditionLock * lock = [[NSConditionLock alloc]init];
    
    NSMutableArray *products = [NSMutableArray array];
    
    NSInteger HAS_DATA = 1;
    NSInteger NO_DATA = 0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            [lock lockWhenCondition:NO_DATA];
            [products addObject:[[NSObject alloc] init]];
            NSLog(@"produce a product,总量:%zi",products.count);
            [lock unlockWithCondition:HAS_DATA];
            sleep(1);
        }
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            NSLog(@"wait for product");
            [lock lockWhenCondition:HAS_DATA];
            [products removeObjectAtIndex:0];
            NSLog(@"custome a product");
            [lock unlockWithCondition:NO_DATA];
        }
        
    });
}

-(void)NSCondition {
    NSCondition *condition = [[NSCondition alloc] init];
    
    NSMutableArray *products = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            [condition lock];
            if ([products count] == 0) {
                NSLog(@"wait for product");
                [condition wait];
            }
            [products removeObjectAtIndex:0];
            NSLog(@"custome a product");
            [condition unlock];
        }
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            [condition lock];
            [products addObject:[[NSObject alloc] init]];
            NSLog(@"produce a product,总量:%zi",products.count);
            [condition signal];
            [condition unlock];
            sleep(1);
        }
        
    });
}



/**
 
 */
-(void)pthread_mutex {
    // 导入头文件 #import <pthread/pthread.h>
    
    __block pthread_mutex_t theLock;
    pthread_mutex_init(&theLock, NULL);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        pthread_mutex_lock(&theLock);
        NSLog(@"需要线程同步的操作1 开始");
        sleep(3);
        NSLog(@"需要线程同步的操作1 结束");
        pthread_mutex_unlock(&theLock);
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        pthread_mutex_lock(&theLock);
        NSLog(@"需要线程同步的操作2");
        pthread_mutex_unlock(&theLock);
        
    });
}

-(void)pthread_mutex_Recursive {
    __block pthread_mutex_t theLock;
    //pthread_mutex_init(&theLock, NULL);
    
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&theLock, &attr);
    pthread_mutexattr_destroy(&attr);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        static void (^RecursiveMethod)(int);
        
        RecursiveMethod = ^(int value) {
            
            pthread_mutex_lock(&theLock);
            NSLog(@"递归锁 加锁");
            if (value > 0) {
                
                NSLog(@"value = %d", value);
                sleep(1);
                RecursiveMethod(value - 1);
            }
            pthread_mutex_unlock(&theLock);
            NSLog(@"递归锁 解锁");
        };
        
        RecursiveMethod(5);
    });
}

/**
 OSSpinLock 自旋锁，性能最高的锁。原理很简单，就是一直 do while 忙等。它的缺点是当等待时会消耗大量 CPU 资源，所以它不适用于较长时间的任务。
 注意：不再安全的 OSSpinLock：https://blog.ibireme.com/2016/01/16/spinlock_is_unsafe_in_ios/
 */
-(void)OSSpinLock {
    // 导入头文件 #import <libkern/OSAtomic.h>
    
    __block OSSpinLock theLock = OS_SPINLOCK_INIT;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSSpinLockLock(&theLock);
        NSLog(@"需要线程同步的操作1 开始");
        sleep(3);
        NSLog(@"需要线程同步的操作1 结束");
        OSSpinLockUnlock(&theLock);
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSSpinLockLock(&theLock);
        sleep(1);
        NSLog(@"需要线程同步的操作2");
        OSSpinLockUnlock(&theLock);
        
    });
}


#pragma mark - 自定义属性原子性

/*
 名字：OC属性的setter和getter方法
 作者：单线程
 鏈接：https://www.jianshu.com/p/d9759dd1fb2e
 來源：簡書
 著作權歸作者所有。商業轉載請聯繫作者獲得授權，非商業轉載請註明出處。
 
 1、如果只重写setter和getter其中之一，可以直接重写
 2、如果同时重写setter和getter，需要加上@synthesize propertyName = _propertyName;不然系统会不认_str。因为如果你同时重写了getter和setter方法，系统就不会帮你自动生成这个_str变量，所以当然报错说不认识这个变量。所以得手动指定成员变量，然后再同时重写了getter和setter方法。

 注意事项：
 在重写set和get时，容易犯如下错误，会造成死循环。
 1、在set方法中，self.age=age;相当于是[self setAge:age];
 2、在get方法中，return self.age;相当于是[self age];
 */
- (void)setNonatomic_str:(NSString *)str {
    
    dispatch_sync(_synQueue, ^{
        _nonatomic_str = str;
    });
}

-(NSString *)nonatomic_str {
    
    __block NSString * localStr;
    dispatch_sync(_synQueue, ^{
        localStr = _nonatomic_str;
    });
    
    return localStr;
}

-(void)nonatomic_TEST {
    NSInteger static A = 1;
    NSInteger static B = 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 10 ; i++) {
            sleep(1);
            self.nonatomic_str = [NSString stringWithFormat:@"%ld",(long)A];
            A ++;
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            NSLog(@"获取 = %@",self.nonatomic_str);
        }
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
