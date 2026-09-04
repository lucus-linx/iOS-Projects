//
//  CatonViewController.m
//  APM
//
//  Created by 启业云03 on 2020/7/2.
//  Copyright © 2020 LD. All rights reserved.
//

#import "CatonViewController.h"
#import "YYFPSLabel.h"
#import "CatonMonitor.h"
#import "PingThread.h"

@interface CatonViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CatonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.redColor;
    
    //这里是做卡顿监测
    [[CatonMonitor shareInstance] beginMonitor];
    
//    PingThread *p = [[PingThread alloc] init];
//    [p start];
    
    // initView
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/3*2);
    
    YYFPSLabel *FPSLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:FPSLabel];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, 100, 100)];
    btn.backgroundColor = UIColor.redColor;
    [btn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 费时测试
    usleep(500*1000);  // 微秒
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = @"结论了节快乐";
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
