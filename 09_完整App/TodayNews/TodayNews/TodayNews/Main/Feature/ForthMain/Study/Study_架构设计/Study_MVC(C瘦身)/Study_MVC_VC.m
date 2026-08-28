//
//  Study_MVC_VC.m
//  TodayNews
//
//  Created by linxiang on 2018/7/23.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_MVC_VC.h"

#import "Study_MVC_Datasource.h"

#import "Study_MVC_User.h"

#import "Study_MVC_User_Cell.h"


@interface Study_MVC_VC ()<UITableViewDelegate, Study_MVC_User_CellDelegate>

@property (nonatomic, strong) Study_MVC_Datasource * LXArrDataSource;
@property (nonatomic, strong) NSMutableArray * dataArr;

@property (nonatomic, strong) UITableView * tableView;

@end

static NSString * const CellIdentifier = @"mycellID";


@implementation Study_MVC_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LXRandomColor;
    
    [self createTableView];
    
}

-(void)createTableView {
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.and.bottom.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[Study_MVC_User_Cell class] forCellReuseIdentifier:@"cellID"];
    
    
    
    
    NSArray * AA = @[@"123",@"234",@"345",@"456",@"567",@"678",@"789"];
    NSArray * BB = @[@"2018.1",@"2018.2",@"2018.3",@"2018.4",@"2018.5",@"2018.6",@"2018.7"];
    
    self.dataArr = [[NSMutableArray alloc]initWithCapacity:5];

    for(int j = 0; j < AA.count; j++) {
        Study_MVC_User * user = [Study_MVC_User new];
        user.title = AA[j];
        user.date = BB[j];
        
        [self.dataArr addObject:user];
    }
    
    self.LXArrDataSource = [[Study_MVC_Datasource alloc]initWithItems:[self.dataArr copy] cellIdentifier:@"cellID" configureCellBlock:^(Study_MVC_User_Cell *cell, Study_MVC_User *model, NSIndexPath *indexPath) {
        cell.model = model;
        cell.delegate = self;
    }];
    
    self.tableView.dataSource = self.LXArrDataSource;

//    [self.tableView reloadData];
}

#pragma mark - delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Didselect = %ld  == %ld",(long)indexPath.section,(long)indexPath.row);
}

#pragma mark - mydelegate
- (void)CenterBtn_CellDelegate:(Study_MVC_User_Cell *)cell {
    
    // 根据cell 获取所在位置
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    NSLog(@"indexPath = %ld = %ld",(long)indexPath.section, (long)indexPath.row);
}


#pragma mark - lazy init

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        //代理
        _tableView.delegate = self;
        _tableView.bounces = YES;  //弹动
        //设置不显示分割线
        _tableView.separatorStyle = UITableViewCellEditingStyleNone;
        //推测高度，必须有，可以随便写多少 否则：iOS11底部刷新错乱
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.delaysContentTouches = NO;
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
