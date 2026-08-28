//
//  ViewController.m
//  LXBlock_Demo
//
//  Created by linxiang on 2017/5/3.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ViewController.h"

#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)demo_1:(id)sender {
    void(^myblock)() = ^() {
        NSLog(@"简单的block");
    };
    
    //调用block
    myblock();
}


- (IBAction)demo_2:(id)sender {
    //1.block 作为方法对象
    
    void(^myblock)() = ^() {
        NSLog(@"简单的block");
    };
    

    Person * per = [[Person alloc] init];
    
    per.block = myblock;
    
    NSLog(@"%@",per.block);
    
}

- (IBAction)demo_3:(id)sender {
    //2.block作为方法参数
    Person * p1 = [[Person alloc]init];
    
    [p1 eat:^(NSString * s) {
        NSLog(@"%@",s);
    }];
}

- (IBAction)demo_4:(id)sender {
    //3.block作为返回值
    Person * p = [[Person alloc]init];
    
    p.run(10);
}

- (IBAction)demo_5:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
