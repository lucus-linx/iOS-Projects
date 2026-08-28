//
//  LXLogAppInfoViewController.m
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXLogAppInfoViewController.h"

#import "LXLogAppInfoTVCell.h"

#import "LXLogMarco.h"

#import "NSString+LXLogDeviceInfo.h"

@interface LXLogAppInfoViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation LXLogAppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景颜色
    self.view.backgroundColor = [UIColor greenColor];
    
    // back btn
    UIBarButtonItem *backitem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(closeCallBack)];
    [self.navigationItem setLeftBarButtonItem:backitem];
    
    
    // 懒加载 tableview
    [self.view addSubview:self.tableView];
}

#pragma mark - TopBtn CallBack
-(void)closeCallBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView DataSource
// Section Number
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

// Rows Number
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }else if (section == 1) {
        return 7;
    }else if (section == 2) {
        return 2;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LXLogAppInfoTVCell * cell = [LXLogAppInfoTVCell cellWithTableView:tableView];

    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.titleLabel.text = @"Project Name";
        cell.detailLabel.text = [NSString getAPPInfo_BundleName];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.titleLabel.text = @"APP Name";
        cell.detailLabel.text = [NSString getAPPInfo_BundleDisplayName];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.titleLabel.text = @"APP Version";
        cell.detailLabel.text = [NSString getAPPInfo_BundleShortVersion];
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        cell.titleLabel.text = @"APP Build";
        cell.detailLabel.text = [NSString getAPPInfo_BundleVersion];
    }
    if (indexPath.section == 0 && indexPath.row == 4) {
        cell.titleLabel.text = @"Bundle Identifier";
        cell.detailLabel.text = [NSString getAPPInfo_BundleIdentifier];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.titleLabel.text = @"Screen Size";
        cell.detailLabel.text = [NSString getDeviceScreenSize];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.titleLabel.text = @"设备型号";
        cell.detailLabel.text = [NSString getDeviceName];
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        cell.titleLabel.text = @"system name";
        cell.detailLabel.text = [NSString getSystemName];
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        cell.titleLabel.text = @"system Version";
        cell.detailLabel.text = [NSString getSystemVersion];
    }
    if (indexPath.section == 1 && indexPath.row == 4) {
        cell.titleLabel.text = @"User name";
        cell.detailLabel.text = [NSString getiPhoneName];
    }
    if (indexPath.section == 1 && indexPath.row == 5) {
        cell.titleLabel.text = @"设备内存";
        cell.detailLabel.text = [NSString getTotalMemorySize];
    }
    if (indexPath.section == 1 && indexPath.row == 6) {
        cell.titleLabel.text = @"当前语言";
        cell.detailLabel.text = [NSString getDeviceLanguage];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.titleLabel.text = @"Lionsom's Blog";
        cell.detailLabel.text = @"http://lionsom.com";
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.titleLabel.text = @"Lionsom's 简书";
        cell.detailLabel.text = @"enter";
    }
 
    
    //（这种是没有点击后的阴影效果)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 右侧小图标 - 箭头
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


#pragma mark - TableView Delegate

// cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

// Section顶部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

// Section底部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 30)];
    headView.backgroundColor = [UIColor blueColor];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenW/2, 30)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor orangeColor];
    [headView addSubview:titleLabel];
    
    if (section == 0) {
        titleLabel.text = @"  Application Info";
    }else if (section == 1) {
        titleLabel.text = @"  Device Info";
    }else if (section == 2) {
        titleLabel.text = @"  Lionsom's blog";
    }
    
    return headView;
}

// 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        NSURL *URL = [NSURL URLWithString:@"http://www.baidu.com"];
        if (indexPath.row == 0) {
            URL = [NSURL URLWithString:@"http://lionsom.com"];
        } else if (indexPath.row == 1) {
            URL = [NSURL URLWithString:@"https://www.jianshu.com/u/3184595a8c6c"];
        }

        UIApplication *application = [UIApplication sharedApplication];
        
        if (@available(iOS 10.0, *)) {
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                NSLog(@"iOS10 - 跳转AppStore成功！！！");
            }];
        } else {
            // Fallback on earlier versions
            NSLog(@"iOS9 - 跳转AppStore成功！！！");
            [application openURL:URL];
        }
    }
}



#pragma mark - Lazy init
-(UITableView *)tableView {
    
    if (!_tableView) {
        
        // (statusbar)
        CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
//        NSLog(@"statusbar height: %f", rectOfStatusbar.size.height);   // 高度
        float statusH = rectOfStatusbar.size.height;
        
        // navigationbar height
        CGRect rectOfNavigationbar = self.navigationController.navigationBar.frame;
//        NSLog(@"navigationbar height: %f", rectOfNavigationbar.size.height);   // 高度
        float naviBarH = rectOfNavigationbar.size.height;
        
        // tabbar height
//        NSLog(@"tabBar height: %f", self.tabBarController.tabBar.frame.size.height);   // 高度
        float tabbarH = self.tabBarController.tabBar.frame.size.height;
        
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - statusH - naviBarH - tabbarH) style:UITableViewStylePlain];
        
        //设置代理
        _tableView.delegate = self;
        _tableView.dataSource =self;
        //设置不显示分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        // heightForHeader 和 heightForFooter 两个delegate不执行
        _tableView.estimatedRowHeight = 0;
        if (@available(iOS 11.0, *)) {
            //当有heightForHeader delegate时设置
            _tableView.estimatedSectionHeaderHeight = 0;
            //当有heightForFooter delegate时设置
            _tableView.estimatedSectionFooterHeight = 0;
        }
        
        //其实不用判断两层，@available(iOS 11.0)会有一个else的
        if(@available(iOS 11.0, *)){
            if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
                _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        // 解决tableview上按钮点击效果的延迟现象
        _tableView.delaysContentTouches = NO;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
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
