//
//  LXLogSandboxViewController.m
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXLogSandboxViewController.h"

#import "LXLogMarco.h"

#import "LXLogSandbox_GCDWebServerVC.h"

#import "PAirSandbox.h"

@interface LXLogSandboxViewController ()

@end

@implementation LXLogSandboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // back btn
    UIBarButtonItem *backitem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(closeCallBack)];
    [self.navigationItem setLeftBarButtonItem:backitem];

    
    float W = screenW;
    float H = 50;
    [self createBtn:CGRectMake(0, H, W, H) :1 :@"GCDWebServer打开沙盒"];
    [self createBtn:CGRectMake(0, H*3 , W, H) :2 :@"PAirSandbox浏览沙盒目录"];
//    [self createBtn:CGRectMake(0, H*2, W, H) :3 :@"NSThread创建方式3"];
}


#pragma mark - TopBtn CallBack
-(void)closeCallBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)btnCallBack:(id)sender {
    UIButton * btn = (UIButton *)sender;
    
    if (btn.tag == 1) {
        LXLogSandbox_GCDWebServerVC * vc = [LXLogSandbox_GCDWebServerVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag == 2) {
        UIViewController * vc = [[PAirSandbox sharedInstance] getASViewController];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark -- CraeteView
-(void)createBtn:(CGRect)frame :(NSInteger)tag :(NSString *)title {
    UIButton * btn = [[UIButton alloc]initWithFrame:frame];
    btn.backgroundColor = [UIColor orangeColor];
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
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
