//
//  LXNightBaseButton.m
//  TodayNews
//
//  Created by linxiang on 2018/2/26.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXNightBaseButton.h"
#import "LXNightThemeManager.h"

@implementation LXNightBaseButton


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
        self.layer.borderColor = [UIColor colorWithRed:218 / 255.0 green:109 / 255.0 blue:242 / 255.0 alpha:1].CGColor;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    } else {
        // LXNight_Default.plist文件读取
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LXNight_Default" ofType:@"plist"];
        NSMutableDictionary *DefaultDic = [[NSDictionary dictionaryWithContentsOfFile:plistPath] mutableCopy];
        
        // 设置Label字体色
        self.layer.borderColor = [UIColor colorWithRed:218 / 255.0 green:109 / 255.0 blue:242 / 255.0 alpha:1].CGColor;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
