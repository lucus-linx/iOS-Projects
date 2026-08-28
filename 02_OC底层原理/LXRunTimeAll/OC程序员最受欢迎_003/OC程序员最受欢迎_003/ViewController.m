//
//  ViewController.m
//  OC程序员最受欢迎_003
//
//  Created by linxiang on 2017/3/22.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ViewController.h"

#import "NSURL+url.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //目的：给系统NSURL这个类的URLWithString 方法添加一个功能，创建URL又能判断是否为空
    NSURL * url = [NSURL URLWithString:@"www.baidu.com/你好"];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSLog(@"AAA == %@",url);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
