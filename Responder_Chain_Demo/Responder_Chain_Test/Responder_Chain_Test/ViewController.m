//
//  ViewController.m
//  Responder_Chain_Test
//
//  Created by linxiang on 2017/12/22.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ViewController.h"

#import "A_View.h"
#import "B_View.h"
#import "C_View.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    A_View * Aview = [[A_View alloc]init];
    Aview.frame = CGRectMake(0, 100, 100, 100);
    [self.view addSubview:Aview];
    
    B_View * Bview = [[B_View alloc]init];
    Bview.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:Bview];
    
    C_View * Cview = [[C_View alloc]init];
    Cview.frame = CGRectMake(200, 100, 100, 100);
    [self.view addSubview:Cview];
    
    
    C_View * Cview_1 = [[C_View alloc]init];
    Cview_1.frame = CGRectMake(0, 300, 300, 300);
    [self.view addSubview:Cview_1];
    
    B_View * Bview_1 = [[B_View alloc]init];
    Bview_1.frame = CGRectMake(0, 0, 200, 200);
    [Cview_1 addSubview:Bview_1];
    
    A_View * Aview_1 = [[A_View alloc]init];
    Aview_1.frame = CGRectMake(0, 0, 100, 100);
    [Bview_1 addSubview:Aview_1];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
