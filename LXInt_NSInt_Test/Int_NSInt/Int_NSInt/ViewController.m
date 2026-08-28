//
//  ViewController.m
//  Int_NSInt
//
//  Created by linxiang on 2017/8/2.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self teshu];
    
}



-(void)intTest {
    
    NSInteger a = 100;
    
    int b = 1000;
 
    
    NSLog(@"%d -- %d",INT8_MIN,INT8_MAX);
    NSLog(@"%d -- %d",INT16_MIN,INT16_MAX);
    NSLog(@"%d -- %d",INT32_MIN,INT32_MAX);
    NSLog(@"%lld -- %lld",INT64_MIN,INT64_MAX);
}


-(void)Typeof {
    //整型
    int i = 100;
    //浮点型
    float f = 1.1;
    //双浮点型
    double d = 2.2;
    //短整型
    short int si = 200;
    //长整型
    long long int ll = 1233223L;
    
    BOOL b = YES;
    
    //输出数据与内存中所占字节数
    //整型
    NSLog(@"int       = %d    size = %lu byte",i, sizeof(i));
    //浮点型
    NSLog(@"float     = %f    size = %lu byte",f,sizeof(f));
    //双浮点型
    NSLog(@"double    = %e    size = %lu byte",d,sizeof(d));
    //短整型
    NSLog(@"short int = %hi   size = %lu byte",si,sizeof(si));
    //长整型
    NSLog(@"long long = %lli  size = %lu byte",ll,sizeof(ll));
    //bool型
    NSLog(@"bool      = %d    size = %lu byte",b, sizeof(b));

}

-(void)teshu {
    int i = 11;

    long int li = 11;
    
    long long int lli = 11;
    
    long l = 11;
    
    long long ll = 11;
    
    
    NSLog(@"int = %d    size = %lu byte",i, sizeof(i));
   
    NSLog(@"long int = %ld    size = %lu byte",li, sizeof(li));
   
    NSLog(@"long long int = %lld    size = %lu byte",lli, sizeof(lli));
   
    NSLog(@"long = %ld    size = %lu byte",l, sizeof(l));
  
    NSLog(@"long long = %lld    size = %lu byte",ll, sizeof(ll));
    
//    unsigned long ul = 111;
//    
//    unsigned long int uli = 11;
//    
//    unsigned long long int ulli = 11;
    
   
    
    
    
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
