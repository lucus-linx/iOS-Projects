//
//  FirstViewController.m
//  LXMBProgressHUD_Demo
//
//  Created by linxiang on 2017/5/11.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "FirstViewController.h"

#import "MBProgressHUD+LX.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)click:(id)sender {
    NSLog(@"可点击");
}
- (IBAction)AAA:(id)sender {
    NSLog(@"点击了");
    
    [MBProgressHUD showSuccess:@"加载成功"];
}
- (IBAction)fail:(id)sender {
    [MBProgressHUD showError:@"加载失败"];
}

- (IBAction)wait:(id)sender {
    [MBProgressHUD showMessage:@"正在加载..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
