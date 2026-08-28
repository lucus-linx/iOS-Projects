//
//  LXLogConsoleViewController.m
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXLogConsoleViewController.h"
// view
#import "LXLogConsoleTVCell.h"

// Category
#import "NSString+LXLogStringSize.h"

#import "LXLogGlobalConst.h"
#import "LXLogStoreManager.h"
#import "LXLogMarco.h"



@interface LXLogConsoleViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation LXLogConsoleViewController


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 刷新下页面
    [self refresheTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // back btn
    UIBarButtonItem *backitem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(closeCallBack)];
    [self.navigationItem setLeftBarButtonItem:backitem];
    
    //创建两个按钮
    UIBarButtonItem * addTest =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(LXLogTestCallBack)];
    UIBarButtonItem * remove =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(clearLXLog)];
    self.navigationItem.rightBarButtonItems=@[addTest,remove];
    
    // 创建页面
    [self CreateView];
    
    // 初始化参数
    _dataSource = [[LXLogStoreManager shared].defaultLogArr mutableCopy];
    
    
    // 监听通知 刷新页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresheTableView) name:KNotification_RefreshLXLog object:nil];
}

#pragma mark - TopBtn CallBack
-(void)closeCallBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)LXLogTestCallBack {
    
// **************** 简单的log输出测试 ***************
    // 1. NSString
    NSString * C_String_1 = @"这是中文第一段";
    NSString * C_String_2 = @"这是中文第二段：啊水电费发的撒事打发打发撒啊第三方";
    NSString * C_String_3 = @"这是中文第三段：打撒孙打发打发撒点发水电费撒热火发热贴好几回各付各的更多的是复方丹参但是速度发的撒发多少";

    NSString * E_String_1 = @"this is the first";
    NSString * E_String_2 = @"this is the second:sadjlsdfkkjsdlsalkdsajlkk";
    NSString * E_String_3 = @"this is the third:dsajlkflkasdljksdaflkdaslfkdlkafsdkjlaslkjadslkjlkjsdaflkdsaflkdasfklsdklfaakldsjlkjsad";
    
    LXLog(@"NSString_1 = %@",C_String_1);
    LXLog(@"NSString_2 = %@",C_String_2);
    LXLog(@"NSString_3 = %@",C_String_3);
    
    LXLog(@"NSString_4 = %@",E_String_1);
    LXLog(@"NSString_5 = %@",E_String_2);
    LXLog(@"NSString_6 = %@",E_String_3);
    
    
    // 2. NSArray
    NSArray * C_Arr_int = @[@1,@2,@3,@4,@5];
    NSArray * C_Arr_str = @[@"你",@"好",@"啊",@"哈哈哈",@"的速度撒事东方大厦",@"凤飞飞凤飞飞撒点时尚大厦撒啊"];
    
    NSArray * E_Arr_str = @[@"hello",@"I",@"am",@"a",@"handsome",@"boy"];
    
    LXLog(@"NSArray_1 = %@",C_Arr_int);
    LXLog(@"NSArray_2 = %@",C_Arr_str);
    
    LXLog(@"NSArray_3 = %@",E_Arr_str);
    
    // 3. NSDictionary
    NSDictionary * C_Dict_int = @{@"A":@123,
                                  @"B":@456,
                                  @"C":@678,
                                  @"D":@999
                                  };
    NSDictionary * C_Dict_str = @{@"A":@"我",
                                  @"B":@"是",
                                  @"C":@"谁",
                                  @"D":@"？？"
                                  };
    NSDictionary * E_Dict_str = @{@"A":@"AA",
                                  @"B":@"BB",
                                  @"C":@"CCCC",
                                  @"D":@"DDDDDDDDDD"
                                  };
    LXLog(@"NSDictionary_1 = %@",C_Dict_int);
    LXLog(@"NSDictionary_2 = %@",C_Dict_str);
    LXLog(@"NSDictionary_3 = %@",E_Dict_str);
    
    

    
// ************** 延时操作 **************
    NSDictionary * dict = @{@"A":@"123",
                            @"B":@"456",
                            @"C":@"678",
                            @"D":@"999"
                            };

    // 定制了延时执行的任务，不会阻塞线程，效率较高（推荐使用）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LXLog(@"NSDictionary = %@",dict);
    });
}

-(void)clearLXLog {
    [[LXLogStoreManager shared] resetLXLogs];
}

#pragma mark - CreateView
-(void)CreateView {
    
//    NSLog(@"screen H = %f", screenH);
//    NSLog(@"self.view H = %f",self.view.frame.size.height);
    
    // (statusbar)
    CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
//    NSLog(@"statusbar height: %f", rectOfStatusbar.size.height);   // 高度
    float statusH = rectOfStatusbar.size.height;
    
    // navigationbar height
    CGRect rectOfNavigationbar = self.navigationController.navigationBar.frame;
//    NSLog(@"navigationbar height: %f", rectOfNavigationbar.size.height);   // 高度
    float naviBarH = rectOfNavigationbar.size.height;
    
    // tabbar height
//    NSLog(@"tabBar height: %f", self.tabBarController.tabBar.frame.size.height);   // 高度
    float tabbarH = self.tabBarController.tabBar.frame.size.height;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - statusH - naviBarH - tabbarH) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor lightGrayColor];
    //代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = YES;  // 弹动
    //设置不显示分割线
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    //推测高度，必须有，可以随便写多少 否则：iOS11底部刷新错乱
    _tableView.estimatedRowHeight = 80;  //推测高度80
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.delaysContentTouches = NO;
    [self.view addSubview:_tableView];
}

/**
 通知回调，刷新页面
 */
-(void)refresheTableView {
    // 数据更新
    _dataSource = [[LXLogStoreManager shared].defaultLogArr mutableCopy];
    
    // 重新加载
    [_tableView reloadData];
    
    //获取最后一行
    if (_dataSource.count > 0) {
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_dataSource.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


#pragma mark - tableView 数据源代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


/**
 加载Cell数据
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXLogConsoleTVCell * cell = [LXLogConsoleTVCell cellWithTableView:tableView];
    LXLogModel * model = _dataSource[indexPath.row];
    cell.model = model;
    
    //（这种是没有点击后的阴影效果)
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


/**
 每一个cell的高度  暂时定高
 */
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LXLogModel * model = _dataSource[indexPath.row];
    
    CGFloat statusHeight =  [model.Content sizeWithLabelWidth:screenW/5*4 font:LXLogConsoleTableViewCell_DeFaultFont].height;
    

    return (25+25+10+10+20+statusHeight);
    
    
//    return 300;
    
}




-(void)dealloc {
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
