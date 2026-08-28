//
//  AppDelegate.m
//  TodayNews
//
//  Created by linxiang on 2018/2/8.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "AppDelegate.h"

#import <AFNetworking/AFNetworking.h>

#import "LXADView.h"

//CoreData相关
#import "AppUseTime_API.h"
#import "AppUseTime+CoreDataClass.h"

// 获取时间扩展
#import "NSString+DisplayTime.h"

// 异常处理
#import "AvoidCrash.h"
#import <Bugly/Bugly.h>
static NSString * const KBuglyAppId = @"e58b6a4d80";


@interface AppDelegate ()<BuglyDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /**
     *  相比于becomeEffective，增加
     *  对”unrecognized selector sent to instance”防止崩溃的处理
     *
     *  但是必须配合:
     *            setupClassStringsArr:和
     *            setupNoneSelClassStringPrefixsArr
     *            这两个方法可以同时使用
     */
     [AvoidCrash makeAllEffective];
    
    
    
    /**
     *  初始化一个需要防止”unrecognized selector sent to instance”的崩溃的类名数组
     *  ⚠️不可将@"NSObject"加入classStrings数组中
     *  ⚠️不可将UI前缀的字符串加入classStrings数组中
     */
    
    NSArray *noneSelClassStrings = @[
                                     @"NSNull",
                                     @"NSNumber",
                                     @"NSString",
                                     @"NSDictionary",
                                     @"NSArray"
                                     ];
    [AvoidCrash setupNoneSelClassStringsArr:noneSelClassStrings];
    
    
    /**
     *  初始化一个需要防止”unrecognized selector sent to instance”的崩溃的类名前缀的数组
     *  ⚠️不可将UI前缀的字符串(包括@"UI")加入classStringPrefixs数组中
     *  ⚠️不可将NS前缀的字符串(包括@"NS")加入classStringPrefixs数组中
     */
//    + (void)setupNoneSelClassStringPrefixsArr:(NSArray<NSString *> *)classStringPrefixs;
    NSArray *noneSelClassPrefixs = @[
                                     @"Login"
                                     ];
    [AvoidCrash setupNoneSelClassStringPrefixsArr:noneSelClassPrefixs];
    
    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
    
    
    
    
//------ 设置按钮互斥 ----- 同一时间只能点击一个按钮
    [[UIButton appearance] setExclusiveTouch:YES];
    
//------ 开启LXLog -------
    // 启动调试日志
    [LXLog defaultCTLog];
    
    // 只显示该开发者的调试日志
    [[LXLog defaultCTLog] setLogOwner:Log_LX];
    
    //测试
    LXLog(@"AAA = %d",112);
    AALog(@"BBB = %@",@"asdf");
    BBLog(@"CCC = %d",23333);
    
//------ 开启网络监测 ------
    [self startReachability];
    
//------ 设置主页面 ------
    self.window = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
    self.window.backgroundColor = [UIColor orangeColor];
    
    // 第一次为NO
    BOOL isfirstUP = [LXUDCache lx_loadCache_Bool:UD_KEY_ISFIRSTUSEAPP];
        
    if (isfirstUP) {
        // 已经启动过了，可以显示广告了
        _mainTabBarController = [MainTabBarController new];
        self.window.rootViewController = _mainTabBarController;
        [self.window makeKeyAndVisible];
    }else{
        // 不是首次启动
        [LXUDCache lx_setCache:[NSNumber numberWithBool:YES] forKey:UD_KEY_ISFIRSTUSEAPP];

        LXLaunchMovieVC * vc = [LXLaunchMovieVC new];
        self.window.rootViewController= vc;
        [self.window makeKeyAndVisible];
    }
    
    [self FFF];
    
    return YES;
}

-(void)FFF {
    
    for (int i = 1; i < 10 ; i++) {
        for (int j = 0; j < 10; j++) {
            for (int k = 0; k < 10; k++) {
                if (pow(i, 3) + pow(j, 3) + pow(k, 3) == i *100 + j*10 +k) {
                    NSLog(@"i = %d, j = %d, k = %d",i,j,k);
                }

//                if ((i*i*i + j*j*j + k*k*k) == (i *100 + j*10 +k)) {
//                    NSLog(@"i = %d, j = %d, k = %d",i,j,k);
//                }
            }
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    NSLog(@"%s",__func__);
//---- 保存到数据库 ----
    //记录离开APP时间点
    NSString * starttime = [LXUDCache lx_loadCache:UD_KEY_APPDIDACTIVETIME];
    NSString * endtime = [NSString getCurrentTime];
    
    // 计算时间间隔
    NSString * starttimeSP = [NSString timeToTimeStamp:starttime];
    NSString * endtimeSP = [NSString timeToTimeStamp:endtime];
    long long diff = [endtimeSP longLongValue] - [starttimeSP longLongValue];
    
    //获取当天日期 1、函数getTodayDate 2、根据endtime截取前十位
    NSString * date = [endtime substringToIndex:10];
    
    NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:date,@"date",starttime,@"starttime",endtime,@"endtime",[NSString stringWithFormat:@"%lld",diff],@"timediff", nil];
    
    // CoreData 数据写入
    AppUseTime_API * A = [AppUseTime_API sharedInstance];
    [A insertModel:dic success:^{
        LXLog(@"写入成功");
    } fail:^(NSError *error) {
        LXLog(@"写入失败");
    }];
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"%s",__func__);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    // 第一次为NO
    BOOL openlaunchAD = [LXUDCache lx_loadCache_Bool:UD_KEY_ISOPENLAUNCH_AD];

    if (openlaunchAD) {
        // 已经启动过了，可以显示广告了
        LXADView * ADView = [[LXADView alloc]my_init];
        [self.window addSubview:ADView];
    }
    
    NSLog(@"%s",__func__);
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%s",__func__);
    
    //记录进入APP时间点
    NSString * timeStr = [NSString getCurrentTime];
    [LXUDCache lx_setCache:timeStr forKey:UD_KEY_APPDIDACTIVETIME];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%s",__func__);
}


/**
 开启网络监测
 */
-(void)startReachability {
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
//                [SVProgressHUD showWarning:@"未知网络"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
//                [SVProgressHUD showWarning:@"请检测网络状态"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
//                [SVProgressHUD showWarning:@"3G/4G"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
//                [SVProgressHUD showWarning:@"WiFi"];
                break;
            default:
                break;
        }
    }];
    //开启监测
    [manager startMonitoring];
}

#pragma mark - Bugly
- (void)configureForBugly {
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.channel = @"App Store";
    config.blockMonitorEnable = YES; // 卡顿监控开关，默认关闭
    config.blockMonitorTimeout = 5;

    config.unexpectedTerminatingDetectionEnable = YES; // 非正常退出事件记录开关，默认关闭
    config.delegate = self;
    
#ifdef DEBUG
    config.debugMode = YES; // debug 模式下，开启调试模式
    config.reportLogLevel = BuglyLogLevelVerbose; // 设置自定义日志上报的级别，默认不上报自定义日志
#else
    config.debugMode = NO; // release 模式下，关闭调试模式
    config.reportLogLevel = BuglyLogLevelWarn;
#endif
    
    [Bugly startWithAppId:KBuglyAppId config:config];
    
    //
    [Bugly setUserIdentifier:@"12345"];  // 记录登录名
    
}

#pragma mark - AvoidCrash 自定义通知异常回调，并通过Bugly上传
- (void)dealwithCrashMessage:(NSNotification *)note {
    //异常拦截并且通过bugly上报
    
    NSDictionary *info = note.userInfo;
    NSString *errorReason = [NSString stringWithFormat:@"【ErrorReason】%@========\n【ErrorPlace】%@========\n【DefaultToDo】%@========\n【ErrorName】%@", info[@"errorReason"], info[@"errorPlace"], info[@"defaultToDo"], info[@"errorName"]];
    NSArray *callStack = info[@"callStackSymbols"];
    
    // 额外信息
    NSDictionary * extraInfo = @{@"UserID":@"defaultID"};
    
    /**
     *    @brief 上报自定义错误
     *
     *    @param category    类型(Cocoa=3,CSharp=4,JS=5,Lua=6)
     *    @param aName       名称
     *    @param aReason     错误原因
     *    @param aStackArray 堆栈
     *    @param info        附加数据
     *    @param terminate   上报后是否退出应用进程
     */
    [Bugly reportExceptionWithCategory:3 name:@"AvoidCrash框架拦截异常" reason:errorReason callStack:callStack extraInfo:extraInfo terminateApp:NO];
}





    
@end
