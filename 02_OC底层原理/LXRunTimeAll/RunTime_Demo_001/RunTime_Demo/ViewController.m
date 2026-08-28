//
//  ViewController.m
//  RunTime_Demo
//
//  Created by linxiang on 2017/3/22.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ViewController.h"

//#import "Person.h"

#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//方式一：OC标准写法
//    Person * p = [[Person alloc]init];

    
//方式二：进行拆分
//    Person * p =[Person alloc];
//    p = [p init];

//方式三：拆分后，逐步采用消息发送机制进行替换   此步骤之后可完全不用导入头文件也可以进行Person的调用
    //NSClassFromString(@"Person") == [Person class] == objc_getRequiredClass("Person")
    NSObject * p = objc_msgSend(objc_getRequiredClass("Person"), @selector(alloc));
    objc_msgSend(p, @selector(init));
    
//方式四： 最后组合
//    NSObject * p = objc_msgSend(objc_msgSend(NSClassFromString(@"Person"), @selector(alloc)),@selector(init));
    
//方式一：标准的OC对象调用函数
//    [p eat];
    
//方式二：
//    [p performSelector:@selector(eat)];
    
//方式三：调用消息发送机制
    //消息发送机制
    objc_msgSend(p, @selector(eat));
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
