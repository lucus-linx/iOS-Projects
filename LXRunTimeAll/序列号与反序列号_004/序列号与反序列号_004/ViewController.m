//
//  ViewController.m
//  序列号与反序列号_004
//
//  Created by linxiang on 2017/3/22.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ViewController.h"

#import "Person.h"

#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"temp path = %@",NSTemporaryDirectory());
}

- (IBAction)save:(id)sender {
    
    Person * p = [[Person alloc]init];
    p.name = @"你好";
    p.age = 22;
    
    //路径
    NSString * temp = NSTemporaryDirectory();
    NSString * filePath = [temp stringByAppendingPathComponent:@"hank.aa"];
    
    //归档
    [NSKeyedArchiver archiveRootObject:p toFile:filePath];
    
}

- (IBAction)get:(id)sender {
    
    //路径
    NSString * temp = NSTemporaryDirectory();
    NSString * filePath = [temp stringByAppendingPathComponent:@"hank.aa"];
    
    Person * p = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"%@ 今年 %d 岁",p.name ,p.age);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
