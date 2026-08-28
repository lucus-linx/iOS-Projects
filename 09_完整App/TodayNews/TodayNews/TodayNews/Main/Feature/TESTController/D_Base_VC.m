//
//  D_Base_VC.m
//  TodayNews
//
//  Created by linxiang on 2018/2/13.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "D_Base_VC.h"

@interface D_Base_VC ()

@end

@implementation D_Base_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"D_Base_VC";
    
    
    UIButton * A = [[UIButton alloc]initWithFrame:CGRectMake(0, 44 + 10, 100, 100)];
    [A setBackgroundColor:[UIColor redColor]];
    [A addTarget:self action:@selector(goto_A) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:A];
    [self.view sendSubviewToBack:A];
    
}

-(void)goto_A {
    LXLog(@"");
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
