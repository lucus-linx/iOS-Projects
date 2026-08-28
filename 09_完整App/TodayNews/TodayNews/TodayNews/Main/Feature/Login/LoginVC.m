//
//  LoginVC.m
//  TodayNews
//
//  Created by linxiang on 2018/2/8.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LoginVC.h"

#import "A_VC.h"
#import "D_Base_VC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor greenColor]];
    
   
    UIButton * A = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [A setBackgroundColor:[UIColor redColor]];
    [A addTarget:self action:@selector(goto_A) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:A];
    [self.view sendSubviewToBack:A];
    
    UIButton * D = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 100, 100)];
    [D setBackgroundColor:[UIColor redColor]];
    [D addTarget:self action:@selector(goto_D) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:D];
}

-(void)goto_A {
    UIViewController * controller = [[A_VC alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)goto_D {
    UIViewController * controller = [[D_Base_VC alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
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
