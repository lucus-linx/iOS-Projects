//
//  Recommend_SEC_VC.m
//  TodayNews
//
//  Created by linxiang on 2018/2/23.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Recommend_SEC_VC.h"

@interface Recommend_SEC_VC ()

@end

@implementation Recommend_SEC_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"viewDidLoad index ");

    [self.view setBackgroundColor:LXRandomColor];
    
    UIButton * A = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [A setBackgroundColor:[UIColor redColor]];
    [A addTarget:self action:@selector(AA) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:A];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear index ");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewDidAppear index ");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear index ");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewDidDisappear index ");
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
