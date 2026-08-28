//
//  LXNightBaseView.m
//  TodayNews
//
//  Created by linxiang on 2018/2/26.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXNightBaseView.h"
#import "LXNightThemeManager.h"

@implementation LXNightBaseView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self applyTheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:LXThemeManagerDidChangeThemeNotification object:nil];
    }
    return self;
}

- (void)applyTheme {
    // 判断当前是否是夜间模式
    BOOL isNightModel = [[LXNightThemeManager defaultManager].currentThemeName isEqualToString:LXNightThemeManager_NightModel];
    
    if (isNightModel) {
        // LXNight_Night.plist文件读取
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LXNight_Night" ofType:@"plist"];
        NSMutableDictionary *NightDic = [[NSDictionary dictionaryWithContentsOfFile:plistPath] mutableCopy];
        
        // 设置View背景色
        self.backgroundColor = [UIColor colorWithHexString:NightDic[@"View.backgroundColor"]];
        
    } else {
        // LXNight_Default.plist文件读取
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LXNight_Default" ofType:@"plist"];
        NSMutableDictionary *DefaultDic = [[NSDictionary dictionaryWithContentsOfFile:plistPath] mutableCopy];
        
        // 设置View背景色
        self.backgroundColor = [UIColor colorWithHexString:DefaultDic[@"View.backgroundColor"]];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
