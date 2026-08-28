//
//  NSString+LXLogDate.m
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "NSString+LXLogDate.h"

@implementation NSString (LXLogDate)

/**
 获取当前时间点的具体时间
 
 @return @"2011-01-26 17:40:50"
 */
+ (NSString *)getCurrentTime {
    //1.获取时间戳
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    //2.格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    //3.直接转换
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

@end
