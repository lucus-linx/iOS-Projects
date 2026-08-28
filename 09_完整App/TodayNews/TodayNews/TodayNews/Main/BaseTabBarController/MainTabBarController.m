//
//  MainTabBarController.m
//  TodayNews
//
//  Created by linxiang on 2018/2/8.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "MainTabBarController.h"

//Controller
#import "LXBaseNavigationController.h"

//View
#import "MainTabbarView.h"
#import "LXLaunchGuideView.h"

//Category
#import "UIImage+Extension.h"

#import "LXTabBar.h"


#import "LXNightThemeManager.h"



@interface MainTabBarController ()<UITabBarControllerDelegate,MainTabbarViewDelegate>
{
    LXTabBar * _lxTabbar;
}

@property (nonatomic, strong) MainTabbarView * mainTabbarView;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置背景颜色
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    _lxTabbar = [[LXTabBar alloc] init];
    [_lxTabbar.centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    //选中时的颜色
    if ([LXUDCache lx_loadCache:UD_KEY_PYCOLOR]) {
        _lxTabbar.tintColor = [LXUDCache lx_loadCache:UD_KEY_PYCOLOR];
    }else{
        _lxTabbar.tintColor = [UIColor colorWithRed:27.0/255.0 green:118.0/255.0 blue:208/255.0 alpha:1];
    }

    //透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
    _lxTabbar.translucent = NO;
    //利用KVC 将自己的tabbar赋给系统tabBar
    [self setValue:_lxTabbar forKeyPath:@"tabBar"];
    
    //设置 UITabBarController Delegate
    self.delegate = self;

    
    // 添加子视图
    [self addChildViewControllers];
    
    // 夜间模式
    [self applyTheme];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:LXThemeManagerDidChangeThemeNotification object:nil];
    

    // 设置APP引导页
    
    // 第一次为NO，是否应该关闭启动引导，默认为不关闭NO
    BOOL closelaunchGUIDE = [LXUDCache lx_loadCache_Bool:UD_KEY_ISCLOSELAUNCH_GUIDE];
    
    if (!closelaunchGUIDE)
    {
        // 静态引导图 动态引导图
        NSArray *imageNameArray = @[@"GuidePageHUD_Gif01.gif",@"GuidePageHUD_Gif02.gif",@"GuidePageHUD_guideImage1.png",@"GuidePageHUD_guideImage2.png",@"GuidePageHUD_guideImage3.png",@"GuidePageHUD_guideImage4.png"];
        
        LXLaunchGuideView *launchGuideView = [[LXLaunchGuideView alloc] my_initWithFrame:self.view.frame imageNameArray:imageNameArray isHideBtn:NO];
        launchGuideView.isSlideEnter = NO;
        [self.view addSubview:launchGuideView];
    }
    
    
    
}

//添加子控制器
- (void)addChildViewControllers{
    //图片大小建议32*32
    [self addChildrenViewController:@"FirstViewController" andTitle:@"首页" andImageName:@"tab1_n" andSelectImage:@"tab1_p"];
    [self addChildrenViewController:@"SecondViewController" andTitle:@"视频" andImageName:@"tab2_n" andSelectImage:@"tab2_p"];
    //中间这个不设置东西，只占位
    [self addChildrenViewController:@"ThirdViewController" andTitle:@"探索" andImageName:@"1" andSelectImage:@"1"];
    [self addChildrenViewController:@"ForthViewController" andTitle:@"功能" andImageName:@"tab3_n" andSelectImage:@"tab3_p"];
    [self addChildrenViewController:@"FifthViewController" andTitle:@"我" andImageName:@"tab4_n" andSelectImage:@"tab4_p"];
}

- (void)addChildrenViewController:(NSString *)class andTitle:(NSString *)title andImageName:(NSString *)imageName andSelectImage:(NSString *)selectedImage{

    Class classs = NSClassFromString(class);
    UIViewController *childVC = [classs new];
    
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    childVC.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    childVC.title = title;
    
    LXBaseNavigationController *baseNav = [[LXBaseNavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:baseNav];
}


#pragma mark - CenterBtn
- (void)buttonAction:(UIButton *)button{
//    self.selectedIndex = 2;//关联中间按钮
    
    // 获取当前的角度
    CGAffineTransform _trans = _lxTabbar.centerBtn.transform;
    CGFloat rotate = acosf(_trans.a);
    // 旋转180度后，需要处理弧度的变化
    if (_trans.b < 0) {
        rotate = M_PI - rotate;
    }
    // 将弧度转换为角度
    CGFloat degree = rotate/M_PI * 180;
//    LXLog(@"%f",degree);
    
    if (degree == 0) {
        // 旋转按钮90度
        [self CenterBtn_TransBegain];
    }else if(degree > 89 && degree < 91){   // 可能存在误差
        // 旋转回去
        [self CenterBtn_TransBack];
    }
}

-(void)CenterBtn_TransBegain {
    // 获取当前的显示的主页面
    LXBaseNavigationController * f = self.selectedViewController;
    [f.view addSubview:self.mainTabbarView];
    
    // 按钮旋转动画
    [UIView animateWithDuration:0.5f animations:^{
        _lxTabbar.centerBtn.transform = CGAffineTransformMakeRotation(M_PI/2);
    }];
}

-(void)CenterBtn_TransBack {
    // 如果存在则进行还原操作
    if (_mainTabbarView) {
        [_mainTabbarView removeFromSuperview];
        
        // 按钮旋转动画
        [UIView animateWithDuration:0.5f animations:^{
            _lxTabbar.centerBtn.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}


#pragma mark - TabBar Delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    // 重要：这里可以进行二次点击时候的刷新使用
    // LXLog(@"didSelectItem = %lu",(unsigned long)self.selectedIndex);
    
    [self CenterBtn_TransBack];
}

#pragma mark - UITabBarController Delegate



-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController == [tabBarController.viewControllers objectAtIndex:2])
    {
        LXLog(@"我是空白区域");
        
        return NO;
    }
    
    return YES;
}

#pragma mark - MainTabbarView Delegate
-(void)TouchEvent:(NSInteger)index {
    if (index == 10000) {
        [self CenterBtn_TransBack];
    }else if (index == 10001){
        LXLog(@"低啊几啊散列技术独立开发");
        [self CenterBtn_TransBack];
    }
    
}

#pragma mark - 主题切换应用
- (void)applyTheme {
    BOOL isNightModel = [[LXNightThemeManager defaultManager].currentThemeName isEqualToString:LXNightThemeManager_NightModel];
    
    if (isNightModel) {
        //修改Tabbar背景色 即可
        _lxTabbar.barTintColor = [UIColor darkGrayColor];
    } else {
        _lxTabbar.barTintColor = [UIColor whiteColor];
    }
}


#pragma mark - Push Pop

-(void)goto_A {
    UIViewController * controller = [Mediator LoginComponent_LoginVC];
    [self.navigationController pushViewController:controller animated:YES];
}



#pragma mark - lazyinit

-(MainTabbarView *)mainTabbarView {
    if (!_mainTabbarView) {
        _mainTabbarView = [[MainTabbarView alloc]init];
        _mainTabbarView.delegate = self;
        _mainTabbarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT - TABBAR_HEIGHT);
    }
    return _mainTabbarView;
}





- (void)dealloc {
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
