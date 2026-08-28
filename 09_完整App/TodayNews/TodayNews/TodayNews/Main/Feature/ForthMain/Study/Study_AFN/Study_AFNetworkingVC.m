//
//  Study_AFNetworkingVC.m
//  TodayNews
//
//  Created by linxiang on 2018/4/20.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_AFNetworkingVC.h"

#import <AFNetworking/AFNetworking.h>

@interface Study_AFNetworkingVC ()

@end

@implementation Study_AFNetworkingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc]init];
    [manager GET:@"" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
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
