//
//  Study_Equality_VC.m
//  TodayNews
//
//  Created by linxiang on 2018/8/28.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_Equality_VC.h"

@interface Study_Equality_VC ()

@end

@implementation Study_Equality_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LXRandomColor;

    [self stringEqualTest];
}

-(void)stringEqualTest {
    NSString *foo = @"123";
    NSString *bar = [NSString stringWithFormat:@"%d", 123];
    
    BOOL eA = (foo == bar);
    BOOL eB = [foo isEqual: bar];
    BOOL eC = [foo isEqualToString: bar];
    
    NSLog(@"%d, %d, %d", eA, eB, eC); // 0, 1, 1
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
