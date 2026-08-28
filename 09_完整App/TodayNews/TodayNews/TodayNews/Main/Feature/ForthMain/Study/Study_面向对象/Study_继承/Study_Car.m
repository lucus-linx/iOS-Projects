//
//  Study_Car.m
//  TodayNews
//
//  Created by linxiang on 2018/7/13.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_Car.h"

@implementation Study_Car

- (void)setBrand:(NSString *)brand{
    _brand = brand;
}
- (void)setColor:(NSString *)color{
    _color = color;
}
- (void)brake{
    NSLog(@"Study_Car 刹车");
}
- (void)quicken{
    NSLog(@"Study_Car 加速");
}


@end
