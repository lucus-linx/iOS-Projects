//
//  LXNightThemeManager.m
//  TodayNews
//
//  Created by linxiang on 2018/2/26.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXNightThemeManager.h"


@interface LXNightThemeManager()

@property (readwrite, copy, nonatomic) NSString *currentThemeName;

@end

@implementation LXNightThemeManager

+ (instancetype)defaultManager {
    static LXNightThemeManager *DefaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DefaultManager = [[LXNightThemeManager alloc] init];
    });
    return DefaultManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentThemeName = [LXUDCache lx_loadCache:UD_KEY_LXTHEMEMODEL];
        if (!self.currentThemeName) {
            self.currentThemeName = LXNightThemeManager_DefaultModel;   // 有两种模式
        }
    }
    return self;
}

- (void)setThemeName:(NSString *)themeName {
    self.currentThemeName = themeName;
    // 存储
    [LXUDCache lx_setCache:themeName forKey:UD_KEY_LXTHEMEMODEL];
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:LXThemeManagerDidChangeThemeNotification object:nil];
    
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
    } completion:nil];
}


/**
 切换模式
 */
+(void)ExchangeTheme {
    BOOL isNightModel = [[LXNightThemeManager defaultManager].currentThemeName isEqualToString:LXNightThemeManager_NightModel];
    [[LXNightThemeManager defaultManager] setThemeName:isNightModel ? LXNightThemeManager_DefaultModel : LXNightThemeManager_NightModel];
}

@end
