//
//  LXNightThemeManager.h
//  TodayNews
//
//  Created by linxiang on 2018/2/26.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

// Push通知名字
static NSString * const LXThemeManagerDidChangeThemeNotification = @"LXThemeManagerDidChangeThemeNotification";

// 两种模式：默认白天模式 和 夜间模式
static NSString * const LXNightThemeManager_DefaultModel = @"LXNightThemeManager_DefaultModel";
static NSString * const LXNightThemeManager_NightModel = @"LXNightThemeManager_NightModel";

@interface LXNightThemeManager : NSObject

@property (readonly, copy, nonatomic) NSString *currentThemeName;

+ (instancetype)defaultManager;

- (void)setThemeName:(NSString *)themeName;

/**
 切换模式
 */
+ (void)ExchangeTheme;

@end
