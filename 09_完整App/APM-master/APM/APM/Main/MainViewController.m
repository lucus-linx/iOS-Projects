//
//  MainViewController.m
//  APM
//
//  Created by 启业云03 on 2020/7/2.
//  Copyright © 2020 LD. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.orangeColor;
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
        
    NSDictionary *data = self.dataSource[indexPath.row];
    cell.textLabel.text = data[@"Title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *data = self.dataSource[indexPath.row];
    NSString *VCName = data[@"VC"];
    
    if (VCName.length > 0) {
        Class cls = NSClassFromString(VCName);
        UIViewController *vc = [[cls alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        
    }
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSDictionary *first = @{@"VC":@"CatonViewController",
                                @"Title":@"卡顿"};
        NSDictionary *temp = @{@"VC":@"",
                                @"Title":@"暂史蒂芬了解"};
        NSArray *arr = @[first, temp];
        _dataSource = [[NSMutableArray alloc] initWithArray:arr];
    }
    return _dataSource;
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
