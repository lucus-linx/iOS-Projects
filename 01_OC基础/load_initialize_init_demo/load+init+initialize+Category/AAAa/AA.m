//
//  AA.m
//  AAAa
//
//  Created by linxiang on 2017/9/5.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "AA.h"


@implementation AA


+(void)load{
    NSLog(@"AAAAA");
}

+(void)initialize {
    NSLog(@"BBBBB");
}

-(instancetype)init {
    self = [super init];
    if (self != nil) {
        NSLog(@"EEEEE");
    }
    return self;
}


@end

@implementation AA (AA_category)

+ (void)load
{
    NSLog(@"AA_category");
}

@end
