//
//  AppDelegate.m
//  APM
//
//  Created by 启业云03 on 2020/7/2.
//  Copyright © 2020 LD. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

// PLCrashReporter
#import <CrashReporter/CrashReporter.h>
#import <CrashReporter/PLCrashReportTextFormatter.h>

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    MainViewController *rootVC = [MainViewController new];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    rootNav.navigationBar.translucent = NO;
    
    self.window.rootViewController = rootNav;
    
    // 主窗口并显示
    [self.window makeKeyWindow];
    [self.window makeKeyAndVisible];
    
    [self init_PLCrash];
    
    return YES;
}

- (void)init_PLCrash {
    
    // 获取数据
    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD
                                                                       symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
    NSData *lagData = [[[PLCrashReporter alloc] initWithConfiguration:config] generateLiveReport];
    // 转换成 PLCrashReport 对象
    PLCrashReport *lagReport = [[PLCrashReport alloc] initWithData:lagData error:NULL];
    // 进行字符串格式化处理
    NSString *lagReportString = [PLCrashReportTextFormatter stringValueForCrashReport:lagReport withTextFormat:PLCrashReportTextFormatiOS];
    //将字符串上传服务器
    NSLog(@"lag happen, detail below: \n %@ \n\n\n =============================================\n\n\n",lagReportString);
    
    
    
//    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
//    NSError *error;
//    // Check if we previously crashed
//    if ([crashReporter hasPendingCrashReport]) {
//        [self handleCrashReport];
//    }
//    // Enable the Crash Reporter
//    if (![crashReporter enableCrashReporterAndReturnError: &error]) {
//        NSLog(@"Warning: Could not enable crash reporter: %@", error);
//    }
}

- (void)handleCrashReport {
    

    // 获取数据
    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD
                                                                       symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
    NSData *lagData = [[[PLCrashReporter alloc] initWithConfiguration:config] generateLiveReport];
    // 转换成 PLCrashReport 对象
    PLCrashReport *lagReport = [[PLCrashReport alloc] initWithData:lagData error:NULL];
    // 进行字符串格式化处理
    NSString *lagReportString = [PLCrashReportTextFormatter stringValueForCrashReport:lagReport withTextFormat:PLCrashReportTextFormatiOS];
    //将字符串上传服务器
    NSLog(@"lag happen, detail below: \n %@",lagReportString);
    
//    
//    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
//    NSData *crashData;
//    NSError *error;
//
//    // Try loading the crash report
//    crashData = [crashReporter loadPendingCrashReportDataAndReturnError:&error];
//    if (crashData == nil) {
//        NSLog(@"Could not load crash report: %@", error);
//        [crashReporter purgePendingCrashReport];
//        return;
//    }
//
//    // We could send the report from here, but we'll just print out some debugging info instead
//    PLCrashReport *report = [[PLCrashReport alloc] initWithData:crashData error:&error];
//    if (report == nil) {
//        NSLog(@"Could not parse crash report");
//        [crashReporter purgePendingCrashReport];
//        return;
//    }
//
//    //TODO:send the report
//    NSLog(@"Crashed on %@", report.systemInfo.timestamp);
//    NSLog(@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name, report.signalInfo.code, report.signalInfo.address);
//    NSString *humanReadText = [PLCrashReportTextFormatter stringValueForCrashReport:report withTextFormat:PLCrashReportTextFormatiOS];
//    NSLog(@"Crashed Format Text %@", humanReadText);
//
//    [crashReporter purgePendingCrashReport];
    return;
}

@end
