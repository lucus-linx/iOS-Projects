//
//  Person.m
//  initialize_load_Demo
//
//  Created by linxiang on 2017/9/5.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "Person.h"

@implementation Person

+(void)load {
    NSLog(@"%s", __FUNCTION__);
//    NSLog(@"%s  %@", __FUNCTION__, [self class]);
}

+ (void)initialize
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%s  %@", __FUNCTION__, [self class]);
}

@end
