//
//  LXBaseNavigationController.m
//  TodayNews
//
//  Created by linxiang on 2018/2/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXBaseNavigationController.h"
//#import "UIImage+Extension.h"

// 主题的扩展类 - 修改navigation和Tabbar主题的扩展类
#import "NSObject+PYThemeExtension.h"

#import "UIImage+Helpers.h"

#import "LXNightThemeManager.h"

// 九宫格页面，手势无效
#import "LXNineBoxVC.h"


@interface LXBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation LXBaseNavigationController

//- (void)loadView {
//    [super loadView];
//    // bg.png为自己ps出来的想要的背景颜色。
//    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(self.navigationBar.frame.size.width, self.navigationBar.frame.size.height + 20)]
//                            forBarPosition:UIBarPositionAny
//                                barMetrics:UIBarMetricsDefault];
//    [self.navigationBar setShadowImage:[UIImage new]];
//
//    //状态栏颜色
//    [[UIApplication sharedApplication] setStatusBarStyle:kStatusBarStyle];
//    //title颜色和字体
//    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor],
//                                               NSFontAttributeName:[UIFont systemFontOfSize:18]};
//
//    if ([UIDevice currentDevice].systemVersion.floatValue > 7.0) {
//        //导航背景颜色
//        self.navigationBar.barTintColor = [UIColor blueColor];
//    }
//
//    //系统返回按钮图片设置
//    NSString *imageName = @"back_more1";
//    if (kStatusBarStyle == UIStatusBarStyleLightContent) {
//        imageName = @"back_more";
//    }
//    UIImage *image = [UIImage imageNamed:imageName];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width-1, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTintColor:[UIColor purpleColor]];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(5, 0)
//                                                         forBarMetrics:UIBarMetricsDefault];
//}





#pragma mark - PY主题 初始化。主题扩展相关
/*
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {

// PY主题与夜间主题冲突，故此处先注释
        // 设置主题颜色
        UINavigationBar *navBar = [[UINavigationBar alloc] init];

        // 设置背景颜色
        if ([LXUDCache lx_loadCache:UD_KEY_PYCOLOR]) {
            navBar.barTintColor = [LXUDCache lx_loadCache:UD_KEY_PYCOLOR];
        }else{
            navBar.barTintColor = [UIColor whiteColor];
        }
        // PY主题设置参数
        [navBar py_addToThemeColorPool:@"barTintColor"];


        navBar.tintColor = [UIColor redColor];
        // 设置字体颜色
        NSDictionary *attr = @{ NSForegroundColorAttributeName : [UIColor orangeColor],
                                NSFontAttributeName : [UIFont boldSystemFontOfSize:20]
                                };
        navBar.titleTextAttributes = attr;

        // 不透明 Y起点从NavBar底部开始
        navBar.translucent = NO;

        [self setValue:navBar forKey:@"navigationBar"];
 
    }

    return self;
}
 */

#pragma mark - 状态栏样式设定
- (UIStatusBarStyle)preferredStatusBarStyle
{
    BOOL isNightModel = [[LXNightThemeManager defaultManager].currentThemeName isEqualToString:LXNightThemeManager_NightModel];
    
    return isNightModel ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置全局Navigation从Bar以下开始
    self.navigationBar.translucent = NO;
    
    // 根据夜间模式刷新主题
    [self applyTheme];
    
    // 添加夜间模式切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:LXThemeManagerDidChangeThemeNotification object:nil];
    
    [self addGestureRecognizer];
}


#pragma mark - 主题切换应用
- (void)applyTheme {
    // 判断当前是否是夜间模式
    BOOL isNightModel = [[LXNightThemeManager defaultManager].currentThemeName isEqualToString:LXNightThemeManager_NightModel];
    
    if (isNightModel) {
        // LXNight_Night.plist文件读取
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LXNight_Night" ofType:@"plist"];
        NSMutableDictionary *NightDic = [[NSDictionary dictionaryWithContentsOfFile:plistPath] mutableCopy];
      
        // title字体设置
        NSDictionary *attr = @{ NSForegroundColorAttributeName : [UIColor colorWithHexString:NightDic[@"NavigationBar.titleTextColor"]],
                                NSFontAttributeName : [UIFont boldSystemFontOfSize:20]
                                };
        self.navigationBar.titleTextAttributes = attr;
        // 返回按钮字体颜色
        self.navigationBar.tintColor = [UIColor colorWithHexString:NightDic[@"NavigationBar.tintColor"]];
        // 导航栏背景
        self.navigationBar.barTintColor =[UIColor colorWithHexString:NightDic[@"NavigationBar.barTintColor"]];
        
        // 刷新状态栏
        [self setNeedsStatusBarAppearanceUpdate];
        
    } else {
        // LXNight_Default.plist文件读取
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LXNight_Default" ofType:@"plist"];
        NSMutableDictionary *DefaultDic = [[NSDictionary dictionaryWithContentsOfFile:plistPath] mutableCopy];
        
        // 设置字体颜色
        NSDictionary *attr = @{ NSForegroundColorAttributeName : [UIColor colorWithHexString:DefaultDic[@"NavigationBar.titleTextColor"]],
                                NSFontAttributeName : [UIFont boldSystemFontOfSize:20]
                                };
        self.navigationBar.titleTextAttributes = attr;
        // 返回按钮字体颜色
        self.navigationBar.tintColor = [UIColor colorWithHexString:DefaultDic[@"NavigationBar.tintColor"]];
        // 导航栏背景
        self.navigationBar.barTintColor = [UIColor colorWithHexString:DefaultDic[@"NavigationBar.barTintColor"]];
        
        // 刷新状态栏
        [self setNeedsStatusBarAppearanceUpdate];
    }
}


#pragma mark - 侧滑手势

- (void)addGestureRecognizer {
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    UIView *gestureView = gesture.view;
    
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:popRecognizer];
    
    //获取系统手势的target数组
    NSMutableArray *_targets = [gesture valueForKey:@"_targets"];
    //获取它的唯一对象，我们知道它是一个叫UIGestureRecognizerTarget的私有类，它有一个属性叫_target
    id gestureRecognizerTarget = [_targets firstObject];
    //获取_target:_UINavigationInteractiveTransition，它有一个方法叫handleNavigationTransition:
    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"_target"];
    //通过前面的打印，我们从控制台获取出来它的方法签名。
    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    //创建一个与系统一模一样的手势，我们只把它的类改为UIPanGestureRecognizer
    [popRecognizer addTarget:navigationInteractiveTransition action:handleTransition];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
//    NSLog(@"ViewControllers = %@",self.viewControllers);
    
    // 如果是九宫格手势页面。左滑返回手势与九宫格手势冲突
    if ([self.viewControllers[self.viewControllers.count-1] isKindOfClass:NSClassFromString(@"LXNineBoxVC")]) {
        return NO;
    }
    
    /**
     *  这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
     */
    
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchLocation = [touch locationInView:touch.view];
    
    CGFloat absX = fabs(touchLocation.x);
    CGFloat absY = fabs(touchLocation.y);
    
    // 设置滑动有效距离
    if (MAX(absX, absY) < 10)
        return NO;
    
    if (absX > absY ) {
        
        if (touchLocation.x<0) {
            
            //向左滑动
            return YES;
        }else{
            //向右滑动
            return NO;
        }
        
    } else if (absY > absX) {
        if (touchLocation.y<0) {
            
            //向上滑动
            return YES;
        }else{
            
            //向下滑动
            return YES;
        }
    }
    
    return  YES;
}

#pragma mark -  push 设置

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    LXLog(@"%@ %lu",viewController,(unsigned long)self.viewControllers.count);
    //如果现在push的不是栈底控制器（最先push进来的那个控制器）  隐藏Tabbar
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    //FIXME:这样做防止主界面卡顿时，导致一个ViewController被push多次
    if (self.childViewControllers.count > 0) {
        if ([[self.childViewControllers lastObject] isKindOfClass:[viewController class]]) {
            return;
        }
    }
    
    [super pushViewController:viewController animated:animated];
    
    // 设置全局返回文字
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:nil action:nil];
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
