//
//  LXLogTabBarController.m
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXLogTabBarController.h"

#import "LXLogBaseNaigationController.h"

#import "LXLogMarco.h"

@interface LXLogTabBarController ()

@end

@implementation LXLogTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 设置背景颜色
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // 底部tabbar不透明
    self.tabBar.translucent = NO;
    
    // 添加子视图
    [self addChildViewControllers];
}

//添加子控制器
- (void)addChildViewControllers{
    //图片大小建议32*32
    [self addChildrenViewController:@"LXLogConsoleViewController" andTitle:@"Console" andImageName:@"tabbar_console" andSelectImage:@"tab1_p"];
    [self addChildrenViewController:@"LXLogAppInfoViewController" andTitle:@"APP" andImageName:@"tabbar_app" andSelectImage:@"tab2_p"];
    [self addChildrenViewController:@"LXLogSandboxViewController" andTitle:@"Sandbox" andImageName:@"tabbar_sandbox" andSelectImage:@"tab3_p"];
}

- (void)addChildrenViewController:(NSString *)class andTitle:(NSString *)title andImageName:(NSString *)imageName andSelectImage:(NSString *)selectedImage{
    
    Class classs = NSClassFromString(class);
    UIViewController *childVC = [classs new];
    
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    childVC.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    childVC.title = title;
    
    LXLogBaseNaigationController *baseNav = [[LXLogBaseNaigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:baseNav];
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
