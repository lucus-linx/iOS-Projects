//
//  LXNightBaseTableView.m
//  TodayNews
//
//  Created by linxiang on 2018/2/27.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXNightBaseTableView.h"
#import "LXNightThemeManager.h"

@implementation LXNightBaseTableView



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
        
        // 设置Label字体颜色
        self.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.2 alpha:1];
        self.separatorColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.16 alpha:1];
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        
    } else {
        // LXNight_Default.plist文件读取
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LXNight_Default" ofType:@"plist"];
        NSMutableDictionary *DefaultDic = [[NSDictionary dictionaryWithContentsOfFile:plistPath] mutableCopy];
        
        // 设置Label字体色
        self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
        self.separatorColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.91 alpha:1];
        self.indicatorStyle = UIScrollViewIndicatorStyleDefault;
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
