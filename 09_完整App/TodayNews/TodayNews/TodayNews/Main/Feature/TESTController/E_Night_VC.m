//
//  E_Night_VC.m
//  TodayNews
//
//  Created by linxiang on 2018/2/26.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "E_Night_VC.h"

#import "LXNightThemeManager.h"

#import "LXNightBaseLabel.h"

@interface E_Night_VC ()

@end

@implementation E_Night_VC

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"夜间模式";
        
    LXNightBaseLabel * label = [[LXNightBaseLabel alloc]initWithFrame:CGRectMake(0, 100, 100, 20)];
    label.text = @"AAA";
    [self.view addSubview:label];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 切换 夜间模式
    [LXNightThemeManager ExchangeTheme];
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
