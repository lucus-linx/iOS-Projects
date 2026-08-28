//
//  LXLog.m
//  TodayNews
//
//  Created by linxiang on 2018/2/11.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXLog.h"

@implementation LXLog

+(instancetype)defaultCTLog
{
    static LXLog *ctlog=nil;
    static dispatch_once_t once_log;
    dispatch_once(&once_log, ^{
        ctlog=[LXLog new];
        [ctlog InitArray];
    });
    return ctlog;
}

-(void)InitArray
{
    _owners = [NSMutableArray array];
    [_owners addObject:[NSNumber numberWithInteger:Log_All]];
}

/** 只显示该开发者的调试日志 */
-(void)setLogOwner:(LogOwner)owner
{
    [_owners removeAllObjects];
    [_owners addObject:[NSNumber numberWithInteger:owner]];
}

@end
