//
//  Study_Enum_VC.m
//  TodayNews
//
//  Created by linxiang on 2018/3/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_Enum_VC.h"

// 第一种实现方式 C语言实现枚举的方式
typedef enum {
    GHTypeUp,
    GHTypeDown,
}GHType;

// 第二种实现方式  OC实现枚举的方式
typedef NS_ENUM(NSUInteger, GHDemoType) {
    GHDemoTypeUp,
    GHDemoTypeDown
};

/**
 * 第三种方式，位移枚举 ,OC实现枚举的方式
 * 优点：一个参数可以传递多个值
 * 说明：如果是位移枚举，观察第一个枚举值。如果该枚举值=0 那么默认传递0座位参数，如果传递0，效率最高
 */
typedef NS_OPTIONS(NSUInteger, GHOpertionType) {
    GHOpertionTypeUp = 1<<0,
    GHOpertionTypeDown = 1<<1,
    GHOpertionTypeLeft = 1<<2,
    GHOpertionTypeRight = 1<<3
};

@interface Study_Enum_VC ()

@end

@implementation Study_Enum_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
