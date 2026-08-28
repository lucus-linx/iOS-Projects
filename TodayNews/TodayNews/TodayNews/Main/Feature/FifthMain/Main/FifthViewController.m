//
//  FifthViewController.m
//  TodayNews
//
//  Created by linxiang on 2018/2/11.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "FifthViewController.h"

//Category
#import "UIImage+Helpers.h"

//Tool
#import "LXNightThemeManager.h"

//View
#import "FifthMain_FirstTypeCell.h"
#import "FifthMain_SecondTypeCell.h"

#import "AppUseTime_API.h"
#import "AppUseTime+CoreDataClass.h"

#import "NSString+DisplayTime.h"

#import "LXNineBoxVC.h"

#define HeadView_H SCREEN_WIDTH/2

@interface FifthViewController ()<UITableViewDelegate,UITableViewDataSource,FifthMain_FirstTypeCellDelegate,FifthMain_SecondTypeCellDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * myheadView;

@property (nonatomic, strong) UIImageView * myheadImageView;

@property (nonatomic, strong) UIButton * UsetimeBtn;

@end

@implementation FifthViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    if (self.UsetimeBtn) {
        [self.UsetimeBtn setTitle:[self getUseTime] forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置NavigationBar背景透明
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];   // 下方的细线
    
    

    
    
    [self.view addSubview:self.tableView];
}

#pragma mark - GetUseTime
- (NSString *)getUseTime {
    __block long long UseTime = 0;
    AppUseTime_API * A = [AppUseTime_API sharedInstance];
    [A readAllUploadModel:^(NSArray *finishArray) {
        for (AppUseTime * obj in finishArray) {
            // LXLog(@"DDDDD == %@ == %@ == %@ == %@",obj.date, obj.starttime, obj.endtime, obj.timediff);
            UseTime += [obj.timediff longLongValue];
        }
    } fail:^(NSError *error) {
        LXLog(@"");
    }];
    
    // 本次使用的时长
    NSString * starttime = [LXUDCache lx_loadCache:UD_KEY_APPDIDACTIVETIME];
    NSString * nowtime = [NSString getCurrentTime];
    
    // 计算时间间隔
    NSString * starttimeSP = [NSString timeToTimeStamp:starttime];
    NSString * endtimeSP = [NSString timeToTimeStamp:nowtime];
    long long diff = [endtimeSP longLongValue] - [starttimeSP longLongValue];
    
    UseTime += diff;
    
    // 除以60秒 获取分钟
    UseTime /= 60;
    NSString * usetimestr = [NSString stringWithFormat:@"%lld分钟",UseTime];
    
    return usetimestr;
}



#pragma mark - TableView Delegate
//Section数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

// 对应Section每个Row数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 4;
    }else if (section == 2) {
        return 4;
    }
    return 0;
}

// 设置Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        FifthMain_FirstTypeCell * cell = [FifthMain_FirstTypeCell cellWithTableView:tableView];
        
        // 按钮参数配置
        NSArray * norImageArr = @[@"home_me2",@"home_list2",@"button_home1"];
        NSArray * highImageArr = @[@"home_me1",@"home_list1",@"button_home"];
        NSArray * titleArr = @[@"历史",@"查看",@"夜间"];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[norImageArr,highImageArr,titleArr] forKeys:@[@"nor",@"high",@"title"]];
        
        cell.parameterDic = dic;
        // 添加代理
        cell.delegate = self;
        
        //（这种是没有点击后的阴影效果)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(indexPath.section == 1 && indexPath.row == 0) {
        static NSString *ID = @"cell_type_2";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.imageView.image = [UIImage imageNamed:@"home_list2"];
        cell.textLabel.text = @"PY主题设置";
        cell.detailTextLabel.text = @"进入";
        
        //（这种是没有点击后的阴影效果)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;

    }else if (indexPath.section == 1 && indexPath.row == 1){
        
        FifthMain_SecondTypeCell * cell = [FifthMain_SecondTypeCell cellWithTableView:tableView];
        
        cell.imageView.image = [UIImage imageNamed:@"home_list2"];
        cell.textLabel.text = @"广告设置";
        
        cell.mySwitch.tag = 101;
        BOOL openlaunchAD = [LXUDCache lx_loadCache_Bool:UD_KEY_ISOPENLAUNCH_AD];
        cell.mySwitch.on = openlaunchAD;
        
        // 添加代理
        cell.delegate = self;
        
        //（这种是没有点击后的阴影效果)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.section == 1 && indexPath.row == 2){
        
        FifthMain_SecondTypeCell * cell = [FifthMain_SecondTypeCell cellWithTableView:tableView];
        
        cell.imageView.image = [UIImage imageNamed:@"home_list2"];
        cell.textLabel.text = @"启动引导设置";
        
        cell.mySwitch.tag = 102;
        BOOL closelaunchGUIDE = [LXUDCache lx_loadCache_Bool:UD_KEY_ISCLOSELAUNCH_GUIDE];
        cell.mySwitch.on = !closelaunchGUIDE;
        
        // 添加代理
        cell.delegate = self;
        
        //（这种是没有点击后的阴影效果)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.section == 1 && indexPath.row == 3){
        
        FifthMain_SecondTypeCell * cell = [FifthMain_SecondTypeCell cellWithTableView:tableView];
        
        cell.imageView.image = [UIImage imageNamed:@"home_list2"];
        cell.textLabel.text = @"启动视频设置";
        cell.mySwitch.tag = 103;
        BOOL firstUP = [LXUDCache lx_loadCache_Bool:UD_KEY_ISFIRSTUSEAPP];
        cell.mySwitch.on = !firstUP;
        // 添加代理
        cell.delegate = self;
        
        //（这种是没有点击后的阴影效果)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    } else if(indexPath.section == 2 && indexPath.row == 0) {
        static NSString *ID = @"cell_type_2";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.imageView.image = [UIImage imageNamed:@"home_list2"];
        cell.textLabel.text = @"手势密码&&指纹密码";
        cell.detailTextLabel.text = @"进入";
        
        //（这种是没有点击后的阴影效果)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else {
        static NSString *ID = @"cell";
        // 根据标识去缓存池找cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 不写这句直接崩掉，找不到循环引用的cell
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.text = @"123";
        
        return cell;
    }

    return nil;
}

// 每个Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 70;
    }
    
    return 50;
}

// section头部 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return SCREEN_WIDTH/2;
    }
    return CGFLOAT_MIN;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

/**
 设置没一个section的view
 */
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        
        self.myheadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeadView_H)];
        self.myheadView.backgroundColor = LXRandomColor;

        self.myheadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeadView_H)];
        self.myheadImageView.backgroundColor = [UIColor redColor];
        self.myheadImageView.image = [UIImage imageNamed:@"GuidePageHUD_guideImage1"]; // GuidePageHUD_guideImage1   HeadView
        self.myheadImageView.contentMode = UIViewContentModeScaleAspectFill;  //UIViewContentModeScaleAspectFill
        self.myheadImageView.clipsToBounds = YES;
        [self.myheadView addSubview:self.myheadImageView];
        

        // 阅读时长
        self.UsetimeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5*4, HeadView_H/2, SCREEN_WIDTH/5, 40)];
        self.UsetimeBtn.backgroundColor = [UIColor darkGrayColor];
        [self.UsetimeBtn setTitle:[self getUseTime] forState:UIControlStateNormal];
        [self.UsetimeBtn addTarget:self action:@selector(UseTimeBtnCallBack) forControlEvents:UIControlEventTouchUpInside];
        [self.myheadView addSubview:self.UsetimeBtn];
        
        return self.myheadView;
    }
    
    return nil;
}

// Cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LXLog(@"SEC = %ld, ROW = %ld",(long)indexPath.section,(long)indexPath.row);
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        // 设置主题色
        UIViewController * controller = [Mediator PersonalCenterComponent_PYTempCollectionViewController];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        LXNineBoxVC * v = [[LXNineBoxVC alloc]init];
//        [self presentViewController:v animated:YES completion:nil];
        [self.navigationController pushViewController:v animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
       
    }
    if (indexPath.section == 2 && indexPath.row == 3) {
      
    }
    
    
}

// 标记一下RightTableView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;
    CGFloat headviewH = HeadView_H;  // 此处并非多此一举，而是下面一句除法用HeadView_H，会出现固定值0.25
    
    // HeadView拉伸
    if (yOffset < 0) {
        CGFloat totalOffset = HeadView_H + ABS(yOffset);
        CGFloat f = totalOffset / headviewH;
        self.myheadImageView.frame = CGRectMake(- (SCREEN_WIDTH * f - SCREEN_WIDTH) / 2, yOffset, SCREEN_WIDTH * f, totalOffset);
    }

//    // 更改navigationBar背景颜色
//    CGFloat alpha = yOffset/headviewH;
//    UIColor * a = [[UIColor blackColor] colorWithAlphaComponent:alpha];
//    UIImage * image = [UIImage imageFilledWithColor:a];
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - FifthMain_FirstTypeCellDelegate

-(void)FifthMain_FirstTypeCellDelegate:(FifthMain_FirstTypeCell *)cell WithButton:(UIButton *)Btn {
    
    if ([Btn.titleLabel.text isEqualToString:@"夜间"]) {
        // 切换 夜间模式
        [LXNightThemeManager ExchangeTheme];
    }
    
}

-(void)FifthMain_SecondTypeCellDelegate:(FifthMain_SecondTypeCell *)cell WithSwitch:(UISwitch *)Switch {
    if (Switch.tag == 101) {
        //广告设置
        if (Switch.on) {
            // 开启状态
            [LXUDCache lx_setCache_Bool:YES forKey:UD_KEY_ISOPENLAUNCH_AD];
        }else{
            // 关闭状态
            [LXUDCache lx_setCache_Bool:NO forKey:UD_KEY_ISOPENLAUNCH_AD];
        }
    }else if (Switch.tag == 102) {
        //启动引导设置
        if (Switch.on) {
            // 开启状态
            [LXUDCache lx_setCache_Bool:NO forKey:UD_KEY_ISCLOSELAUNCH_GUIDE];
        }else{
            // 关闭状态
            [LXUDCache lx_setCache_Bool:YES forKey:UD_KEY_ISCLOSELAUNCH_GUIDE];
        }
    }else if (Switch.tag == 103) {
        //启动引导设置
        if (Switch.on) {
            // 开启状态
            [LXUDCache lx_setCache_Bool:NO forKey:UD_KEY_ISFIRSTUSEAPP];

        }else{
            // 关闭状态
            [LXUDCache lx_setCache_Bool:YES forKey:UD_KEY_ISFIRSTUSEAPP];
        }
    }
}

#pragma mark - CallBack

-(void)UseTimeBtnCallBack {
    [self.UsetimeBtn setTitle:[self getUseTime] forState:UIControlStateNormal];
}


#pragma mark - Lazy init
-(UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-TABBAR_HEIGHT) style:UITableViewStyleGrouped];
        //设置代理
        _tableView.delegate = self;
        _tableView.dataSource =self;
        //设置不显示分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
