//
//  SecondViewController.m
//  TodayNews
//
//  Created by linxiang on 2018/2/8.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "SecondViewController.h"

#import "Recommend_SEC_VC.h"
#import "Attention_SEC_VC.h"
#import "Location_SEC_VC.h"

@interface SecondViewController ()<TYTabPagerControllerDataSource,TYTabPagerControllerDelegate>

@property (nonatomic, strong) NSArray *datas;

@end

@implementation SecondViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tabBarHeight = 40;
    self.tabBarOrignY = 0;
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;   // 不同的样式
    //self.tabBar.layout.cellWidth = 50;  // 可设定死，也可通过代理动态设定
    self.tabBar.layout.cellSpacing = 5;  // cell之间的间隔
    self.tabBar.layout.cellEdging = 0;  //
    self.tabBar.layout.adjustContentCellsCenter = YES;  // 处理是否居中显示
    self.tabBar.layout.normalTextFont = [UIFont fontWithName:@"Arial" size:20.0f];  //  未选择 设置字体
    self.tabBar.layout.selectedTextFont = [UIFont fontWithName:@"Arial" size:25.0f]; // 选择
    
    self.dataSource = self;
    self.delegate = self;
    
    
    
    [self loadData];
}

- (void)loadData {

    NSArray * datas = @[@"关注",@"扥发哈哈哈",@"推荐",@"视频",@"热点",@"体育",@"军事",@"科技",@"新时代"];
    
    _datas = [datas copy];
    
    // only add controller at index 0
    [self scrollToControllerAtIndex:0 animate:YES];
    [self reloadData];
    
    // first reloadData add controller at index 0,and scroll to index 1
//    [self reloadData];
//    [self scrollToControllerAtIndex:1 animate:YES];
}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return _datas.count;
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    if (index%3 == 0) {
        Recommend_SEC_VC *VC = [[Recommend_SEC_VC alloc]init];
        return VC;
    }else if (index%3 == 1) {
        Attention_SEC_VC *VC = [[Attention_SEC_VC alloc]init];
        return VC;
    }else {
        Location_SEC_VC *VC = [[Location_SEC_VC alloc]init];
        return VC;
    }
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    NSString *title = _datas[index];
    return title;
}


// Delegate  动态修改bar的宽度
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSArray * datas = @[@"关注",@"扥发哈哈哈",@"推荐",@"视频",@"热点",@"体育",@"军事",@"科技",@"新时代"];
    NSString *title = datas[index];
    return [pagerTabBar cellWidthForTitle:title];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
