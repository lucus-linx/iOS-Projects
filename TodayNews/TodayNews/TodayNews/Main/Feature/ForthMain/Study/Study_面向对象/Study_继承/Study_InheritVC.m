//
//  Study_InheritVC.m
//  TodayNews
//
//  Created by linxiang on 2018/7/13.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_InheritVC.h"

#import "Study_Taxi.h"

@interface Study_InheritVC ()

@end

@implementation Study_InheritVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LXRandomColor;
        
    Study_Taxi * taxi = [[Study_Taxi alloc]init];
    [taxi printTick];
    
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
