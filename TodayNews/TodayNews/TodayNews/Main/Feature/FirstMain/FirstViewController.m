//
//  FirstViewController.m
//  TodayNews
//
//  Created by linxiang on 2018/2/8.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "FirstViewController.h"

#import "YBPopupMenu.h"

#import "LXQRCode_VC.h"

#import <PYSearch/PYSearch.h>

#import "NSObject+PYThemeExtension.h"

#import "A_VC.h"

#import "E_Night_VC.h"

#import "LXNightThemeManager.h"

@interface FirstViewController ()<YBPopupMenuDelegate,LXQRCodeControllerDelegate>

@end

@implementation FirstViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.view setBackgroundColor:[UIColor orangeColor]];
 
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setFrame:CGRectMake(0, 0, 30, 30)];
    [barButton setImage:[UIImage imageNamed:@"button_home"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(left_btnCallBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarButton setFrame:CGRectMake(0, 0, 30, 30)];
    [rightBarButton setImage:[UIImage imageNamed:@"button_home"] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(right_btnCallBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBarButtonitem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil
                                                                                   action:nil];
    negativeSpacer.width = -10;

    self.navigationItem.leftBarButtonItems = @[negativeSpacer,item];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightBarButtonitem];
    
    
    UIButton * searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 7, 100, 30)];
    [searchBtn setBackgroundColor:[UIColor redColor]];
    [searchBtn addTarget:self action:@selector(searchBtnCallBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    // 设置中间搜索按钮
    self.navigationItem.titleView = searchBtn;
    
    
    UIButton * A = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [A setBackgroundColor:[UIColor redColor]];
    [A addTarget:self action:@selector(AA) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:A];
    
    UIButton * B = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 100, 100)];
    [B setBackgroundColor:[UIColor redColor]];
    [B addTarget:self action:@selector(BB) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:B];
    
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    LXLog(@"点击了 %@ 选项",ybPopupMenu.titles[index]);
    
    if (index == 0) {
        [self QRCode_Result];
    }
    
    if (index == 1) {
        // 设置主题色        
        UIViewController * controller = [Mediator PersonalCenterComponent_PYTempCollectionViewController];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if (index == 2) {
        // 切换 夜间模式
        [LXNightThemeManager ExchangeTheme];
    }
    
}

/**
 使用LXQRCode扫码的三种方式
 */
-(void)QRCode_Result{
    
    int randNum = 3; // LXRandNum(3);
    
    if(randNum == 0) {
        // 后向传值
        LXQRCode_VC * QRCodeVC = [[LXQRCode_VC alloc]init];
        QRCodeVC.LXQRCodeReturnResultType = LXQRCodeReturnResultType_Common;
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:QRCodeVC];
        
        [self presentViewController:navVC animated:YES completion:^{
        }];
    } else if(randNum ==1) {
        // 反向传值 - delegate
        LXQRCode_VC * QRCodeVC = [[LXQRCode_VC alloc]init];
        QRCodeVC.LXQRCodeReturnResultType = LXQRCodeReturnResultType_Delegate;
        QRCodeVC.delegate = self;
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:QRCodeVC];
        
        [self presentViewController:navVC animated:YES completion:^{
        }];
    } else if(randNum == 2) {
        // 反向传值 - Block
        LXQRCode_VC * QRCodeVC = [[LXQRCode_VC alloc]init];
        QRCodeVC.LXQRCodeReturnResultType = LXQRCodeReturnResultType_block;
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:QRCodeVC];
        
        QRCodeVC.callBackBlock = ^(NSString * QRCode_Result){   // 1
            LXLog(@"Block Get is %@",QRCode_Result);
        };
        
        [self presentViewController:navVC animated:YES completion:^{
        }];
    }
}


#pragma mark -- LXQRCode Delegate
- (void)qrcodeController:(LXQRCode_VC *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(LXQRCodeResultType)resultType
{
    if (resultType == LXQRCodeResultTypeSuccess) {
        LXLog(@"Delegate  Success == %@",readerScanResult);
    }else {
        LXLog(@"Delegate  fail == %@",readerScanResult);
    }
}



#pragma mark - CallBack
-(void)left_btnCallBack {
    LXLog(@"");
    
    [SVProgressHUD showSuccess:@"加载成功sdfaf"];
}

-(void)right_btnCallBack:(UIButton *)sender {
    NSArray * TITLES = @[@"扫一扫",@"PY主题",@"夜间"];
    NSArray * ICONS = @[@"button_home",@"button_home",@"button_home"];
    [YBPopupMenu showRelyOnView:sender titles:TITLES icons:ICONS menuWidth:120 delegate:self];
}

-(void)searchBtnCallBack {
    // 1. Create hotSearches array
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. Create searchViewController
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"Search programming language" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Call this Block when completion search automatically
        // Such as: Push to a view controller
        A_VC * vc = [[A_VC alloc]init];
        
        [searchViewController.navigationController pushViewController:vc animated:YES];
    }];
    // 3. present the searchViewController
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}


-(void)AA{
    [self goto_A];
    LXLog(@"CCCCC");
}

-(void)BB {
    E_Night_VC * controller = [[E_Night_VC alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)goto_A {
    UIViewController * controller = [Mediator LoginComponent_LoginVC];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
