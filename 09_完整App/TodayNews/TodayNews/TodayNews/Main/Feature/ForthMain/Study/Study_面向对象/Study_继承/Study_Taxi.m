//
//  Study_Taxi.m
//  TodayNews
//
//  Created by linxiang on 2018/7/13.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_Taxi.h"

@implementation Study_Taxi

- (void)brake {
    NSLog(@"Study_Taxi 刹车");
}


- (void)printTick{
    [super brake];
    [self brake];
    
    self.brand = @"A";
    self.color = @"B";
    
    NSLog(@"%@出租车打印了发票，公司为:%@,颜色为:%@",_brand,_company,_color);
}

@end
