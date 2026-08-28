//
//  LXNightBaseViewController.m
//  TodayNews
//
//  Created by linxiang on 2018/2/26.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXNightBaseViewController.h"
#import "LXNightThemeManager.h"

@interface LXNightBaseViewController ()

@end

@implementation LXNightBaseViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self applyTheme];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:LXThemeManagerDidChangeThemeNotification object:nil];
}

- (void)applyTheme {
    // 判断当前是否是夜间模式
    BOOL isNightModel = [[LXNightThemeManager defaultManager].currentThemeName isEqualToString:LXNightThemeManager_NightModel];
    
    if (isNightModel) {
        // LXNight_Night.plist文件读取
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LXNight_Night" ofType:@"plist"];
        NSMutableDictionary *NightDic = [[NSDictionary dictionaryWithContentsOfFile:plistPath] mutableCopy];
        
        // view背景颜色设置
        self.view.backgroundColor =  [UIColor colorWithHexString:NightDic[@"ViewController.backgroundColor"]];
    
    } else {
        // LXNight_Default.plist文件读取
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LXNight_Default" ofType:@"plist"];
        NSMutableDictionary *NightDic = [[NSDictionary dictionaryWithContentsOfFile:plistPath] mutableCopy];
        
        // view背景颜色设置
        self.view.backgroundColor = [UIColor colorWithHexString:NightDic[@"ViewController.backgroundColor"]];
    }
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
