//
//  Mediator.h
//  TodayNews
//
//  Created by linxiang on 2018/2/8.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mediator : NSObject

// Login
+ (UIViewController *)LoginComponent_LoginVC;

// 四个主页面
+ (UIViewController *)FourMainComponent_FirstViewController;
+ (UIViewController *)FourMainComponent_SecondViewController;


// 个人中心
+ (UIViewController *)PersonalCenterComponent_PYTempCollectionViewController;


@end
