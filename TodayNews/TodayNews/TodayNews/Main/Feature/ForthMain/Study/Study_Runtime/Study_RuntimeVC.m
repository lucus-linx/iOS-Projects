//
//  Study_RuntimeVC.m
//  TodayNews
//
//  Created by linxiang on 2018/4/26.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_RuntimeVC.h"

#import "NSArray+AssociateObject.h"

@interface Study_RuntimeVC ()

@end

@implementation Study_RuntimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LXRandomColor;

    [self category_AssociateObject_test];
    
}


/**
 关联对象，给NSArray添加属性
 手动添加getter和setter方法
 */
-(void)category_AssociateObject_test{
    NSArray *myArray = [[NSArray alloc]init];
    myArray.blog = @"lionsom.com";
    NSLog(@"谁说Category不能添加属性？我用Category为NSArray添加了一个blog属性，blog=%@",myArray.blog);
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
