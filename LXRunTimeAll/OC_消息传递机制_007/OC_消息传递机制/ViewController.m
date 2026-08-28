//
//  ViewController.m
//  OC_消息传递机制
//
//  Created by linxiang on 2017/9/7.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ViewController.h"

#import "Person.h"
//#import "Person_1.h"

#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Person * person = [[Person alloc]init];
    
    // 一般的方法调用
//    [person AAA];
   

    // 消息传递的方法调用
    objc_msgSend(person, @selector(resolveThisMethodDynamically));

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
