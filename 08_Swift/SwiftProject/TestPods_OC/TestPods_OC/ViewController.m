//
//  ViewController.m
//  TestPods_OC
//
//  Created by 启业云03 on 2021/3/23.
//

#import "ViewController.h"

//#import <OnlyOCDemo/AllHeader.h>
//#import <OnlyOCDemo/FunctionB.h>
//
//#import <OnlySwiftDemo/OnlySwiftDemo-Swift.h>
//
//#import <OCAddSwiftDemo/FunctionD_OC.h>
//#import <OCAddSwiftDemo/OCAddSwiftDemo-Swift.h>

#import <Masonry.h>

//#import <QYCH5/QYCH5-Swift.h>
#import "QYCH5-Swift.h"
//@import QYCH5;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = UIColor.orangeColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /*
    // 第一类：纯OC组件
    // [FunctionA printSomethingA:@"A打印"];
    [FunctionB printSomethingB:@"B打印"];
    
    // 第二类：纯Swift组件
    SwiftLibC *C = [[SwiftLibC alloc] init];
    [C show];
    
    // 第三类：OC组件包含Swift
    // OC组件中的OC方法
    [FunctionD_OC printSomething:@"你大爷！"];
    // OC组件中的OC方法再嵌套 Swift Pod 以及 Swift源码
    [FunctionD_OC useSwiftPod];
    [FunctionD_OC useSwiftSource];
    
    // OC组件中Swift源码
    SwiftLibD *D = [[SwiftLibD alloc] init];
    [D show:@"123"];
    // OC组件中Swift源码中调用OC源码以及Swift Pod
    [D show_OC_Source:@"789"];
    [D show_SwiftPod:@"10"];
     */
    
    ContainerWebViewVC *vc = [[ContainerWebViewVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
