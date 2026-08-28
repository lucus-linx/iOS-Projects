//
//  Study_Ivar_Student.m
//  TodayNews
//
//  Created by linxiang on 2018/7/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_Ivar_Student.h"

@interface Study_Ivar_Student()
{
@public
    NSString * AA;
        
@protected
    NSString * BB;
        
@private
    NSString * CC;
        
@package
    NSString * DD;
}
@end


@implementation Study_Ivar_Student
{
@public
    NSString * AAA;

@protected
    NSString * BBB;

@private
    NSString * CCC;

@package
    NSString * DDD;
}

int ABC = 10;   // 没有 {} 则为全局变量


-(instancetype)init {
    
    self = [super init];  
    if (self) {
//        self->A = @"A";
        self->AA = @"AA";
//        self->AAA = @"AAA";
        _A = @"我是新的";
        
        LXLog(@"ABC = %d",ABC);
    }
    return self;
}

@end
