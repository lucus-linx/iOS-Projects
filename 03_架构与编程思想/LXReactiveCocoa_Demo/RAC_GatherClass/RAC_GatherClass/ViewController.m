//
//  ViewController.m
//  RAC_GatherClass
//
//  Created by linxiang on 2017/4/25.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ViewController.h"

#import "ReactiveObjC.h"

#import "KFC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self anaysicPlist];
}

#pragma mark -- KFC
-(void)anaysicPlist {
    
    //文件路径
    NSString * path = [[NSBundle mainBundle]pathForResource:@"kfc.plist" ofType:nil];
    
    NSArray * dicArr = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray * arr = [NSMutableArray array];
    
    [dicArr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        KFC * kfc = [KFC kfcWithDict:x];
        [arr addObject:kfc];
    }];
    
    NSArray * arr_1 = [[dicArr.rac_sequence map:^id _Nullable(id  _Nullable value) {
        return [KFC kfcWithDict:value];
    }] array];
    
    NSLog(@"%@",arr_1);
    
}


#pragma mark -- Demo
-(void)demo_1 {
    //元祖类 ：类似于 数组
    
    RACTuple * tuple = [RACTuple tupleWithObjectsFromArray:@[@"111",@"222",@"333"]];
    NSString * str = tuple[1];
    NSLog(@"%s == %@",__func__,str);
}

-(void)demo_2 {
    //RACSequence：用于代替NSArray,NSDictionary,可以快速的遍历
    //最常见的应用常见：字典转模型
    
    //数组
    NSArray * arr = @[@"abc",@"bcd",@123];
    //RAC集合类
    RACSequence * requence = arr.rac_sequence;
    //遍历
    RACSignal * signal = requence.signal;
    
    //订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%s == %@",__func__,x);
    }];
    
    [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%s == %@",__func__,x);
    }];
}

-(void)demo_3 {
    
    //字典
    NSDictionary * dic = @{@"name":@"lionsom",@"age":@12};
    
    //字典转集合
    [dic.rac_sequence.signal subscribeNext:^(RACTuple* x) {
//        NSLog(@"%s == %@",__func__,x);
        
        //宏 ： 解析元祖
        //宏里面的参数 : 传入需要解析出来的变量名称
        //右边,放需要解析的元祖
        RACTupleUnpack(NSString * key,NSString * value) = x;
      
        NSLog(@"%@:%@",key,value);
        
        if ([key isEqualToString:@"name"]) {
            NSLog(@"Vaule == %@",value);
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
