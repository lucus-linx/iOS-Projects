//
//  LXLogConfig.m
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXLogConfig.h"

static const NSInteger kDefaultLogMaxCount = NSIntegerMax;


@implementation LXLogConfig

+(instancetype)shared {
    static LXLogConfig * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LXLogConfig alloc]init];
    });
    return _instance;
}

-(instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _logMaxCount = kDefaultLogMaxCount;
    
    return self;
}


@end
