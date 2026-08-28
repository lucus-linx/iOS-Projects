//
//  Mediator.m
//  TodayNews
//
//  Created by linxiang on 2018/2/8.
//  Copyright © 2018年 LX. All rights reserved.
//


#import "Mediator.h"

// Component 组件
#import "LoginComponent.h"

#import "FourMainComponent.h"

#import "PersonalCenterComponent.h"


// 解决警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
/*
 作者：戴仓薯
 鏈接：https://www.jianshu.com/p/6517ab655be7
 */

@implementation Mediator

#pragma mark -- 样例
// 方法一： 需要导入头文件
+ (UIViewController *)LoginComponent_LoginVC_Before {
    return [LoginComponent LoginVC];
}

// 方法二： 使用RunTime，则不需要导入 组件的头文件，解耦

+ (UIViewController *)LoginComponent_LoginVC_Runtime {
    
    Class cls = NSClassFromString(@"LoginComponent");
    
    //方式一：  Warning : PerformSelector may cause a leak because its selector is unknown
    //    return [cls performSelector:NSSelectorFromString(@"LoginVC")];
    
    //方式二： 解决上方 存在内存泄露的警告
    SuppressPerformSelectorLeakWarning(
                                       return [cls performSelector:NSSelectorFromString(@"LoginVC")];
                                       );
    
    //方式三：Runtime  #import <objc/message.h>
    //    return objc_msgSend(cls, NSSelectorFromString(@"LoginVC"));
}

#pragma mark -- 日常使用

+ (UIViewController *)LoginComponent_LoginVC {
    Class cls = NSClassFromString(@"LoginComponent");
    SuppressPerformSelectorLeakWarning(
                                       return [cls performSelector:NSSelectorFromString(@"LoginVC")];
                                       );
}

+ (UIViewController *)FourMainComponent_FirstViewController {
    Class cls = NSClassFromString(@"FourMainComponent");
    SuppressPerformSelectorLeakWarning(
                                       return [cls performSelector:NSSelectorFromString(@"FirstViewController")];
                                       );
}

+ (UIViewController *)FourMainComponent_SecondViewController {
    Class cls = NSClassFromString(@"FourMainComponent");
    SuppressPerformSelectorLeakWarning(
                                       return [cls performSelector:NSSelectorFromString(@"SecondViewController")];
                                       );
}



#pragma mark - 个人中心
+ (UIViewController *)PersonalCenterComponent_PYTempCollectionViewController {
    Class cls = NSClassFromString(@"PersonalCenterComponent");
    SuppressPerformSelectorLeakWarning(
                                       return [cls performSelector:NSSelectorFromString(@"PYTempCollectionViewController")];
                                       );
}











@end
