//
//  NSString+LXLogDate.h
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LXLogDate)

/**
 获取当前时间点的具体时间
 
 @return @"2011-01-26 17:40:50"
 */
+ (NSString *)getCurrentTime;

@end
