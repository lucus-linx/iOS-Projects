//
//  Study_IvarVC.m
//  TodayNews
//
//  Created by linxiang on 2018/7/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_IvarVC.h"
#import "Study_Ivar_MidStudent.h"

@interface Study_IvarVC ()

@end

@implementation Study_IvarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = LXRandomColor;
    
    
    Study_Ivar_MidStudent * midStu = [Study_Ivar_MidStudent new];
    
    LXLog(@"A = %@",midStu->_A);
//    LXLog(@"B = %@",midStu->_B);
//    LXLog(@"C = %@",midStu->_C);
    LXLog(@"D = %@",midStu->_D);
//    LXLog(@"E = %@",midStu->_E);
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
