//
//  Study_AdaptVC.m
//  TodayNews
//
//  Created by linxiang on 2018/5/7.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_AdaptVC.h"

@interface Study_AdaptVC ()

@end

@implementation Study_AdaptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LXRandomColor;
    self.title = @"适配相关";
    
    
    [self getSize];

    [self getHeight];
    
    //iOS使用的是逻辑像素单位(pt,point)，与密度(ppi)无关，它与px换算的系数由系统确定(Android系统里用户都能修改该系数以增加/减少屏幕的显示内容)。iPhone 2g/3g/3gs 是1，iPhone 4/4s/5/5s/6/6s是2，iPhone 6+/6s+是3。

}

-(void)getSize {
//    1.app尺寸，去掉状态栏
    CGRect r = [ UIScreen mainScreen ].applicationFrame;
//    r=0，20，320，460
//    2.屏幕尺寸
    CGRect rx = [ UIScreen mainScreen ].bounds;
//    r=0，0，320，480
//    3.状态栏尺寸
    CGRect rect;
    rect = [[UIApplication sharedApplication] statusBarFrame];
//    4.iphone中获取屏幕分辨率的方法
    CGRect rect1 = [[UIScreen mainScreen] bounds];
    CGSize size = rect1.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
}

-(void)getHeight {
    // (statusbar)
    CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
    NSLog(@"statusbar height: %f", rectOfStatusbar.size.height);   // 高度
    
    //（navigationbar）
    CGRect rectOfNavigationbar = self.navigationController.navigationBar.frame;
    NSLog(@"navigationbar height: %f", rectOfNavigationbar.size.height);   // 高度
    

    // tabBar
    //在tabBarController中使用（你的继承自UITabBarController的VC）
//    CGFloat tabBarHeight = self.tabBar.frame.size.height;
    //在非tabBarController中使用
//    UITabBarController *tabBarVC = [[UITabBarController alloc] init]; //(这儿取你当前tabBarVC的实例)
//    CGFloat tabBarHeight = tabBarVC.tabBar.frame.size.height;
    // toolBar
    //CGFloat toolBarHeight = self.navigationController.toolBar.frame.size.height;
 
}

#pragma mark -- CraeteView
-(void)createBtn:(CGRect)frame :(NSInteger)tag :(NSString *)title {
    UIButton * btn = [[UIButton alloc]initWithFrame:frame];
    btn.backgroundColor = LXRandomColor;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
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
