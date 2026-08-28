//
//  ViewController.m
//  AAAa
//
//  Created by linxiang on 2017/9/5.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ViewController.h"

#import "AA.h"

#import "BBViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    AA * a1 = [AA new];
    AA * a2 = [AA new];
    
    BBViewController * b1 = [BBViewController new];
    
    BBViewController * b2 = [BBViewController new];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
