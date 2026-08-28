//
//  NSString+DisplayTime.h
//  TodayNews
//
//  Created by linxiang on 2018/3/8.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

// 时区
typedef NS_OPTIONS(NSUInteger, LXTimeZoneType) {
    LXTimeZoneTypeNoOptions = 1<<0,    // 没有选择，默认为世界标准事件 GMT与UTC
    LXTimeZoneTypeShanghai = 1<<1,      // 上海时区
    LXTimeZoneTypeHong_Kong = 1<<2,     // 香港时区
};



@interface NSString (DisplayTime)

/**
 获得当前时间戳 - 此处时间戳是国际标准时间 不是本地时间
 
 @param ISSecond 计量单位 是否为秒   YES:秒   NO:毫秒
 @return 时间戳
 */
+ (NSString *)getCurrentTimeStampWithSecond:(BOOL)ISSecond;


/**
 "2011-01-26 17:40:50" ==》 时间戳（单位秒）
 
 @param timeStr 时间
 @return 时间戳（秒）
 */
+ (NSString *)timeToTimeStamp:(NSString *)timeStr;



/**
 时间戳（单位秒） ==》 类似于yyyy-MM-dd HH:mm:ss
 
 @param timeSp 时间戳（单位秒）
 @param timeZone LXTimeZoneType 时区选择
 @return 类似yyyy-MM-dd HH:mm:ss 格式
 */
+ (NSString *)timeWithTimeInterval:(NSTimeInterval)timeSp Format:(NSString *)format Area:(LXTimeZoneType)timeZone;


/**
 获取当前时间点的具体时间

 @return @"2011-01-26 17:40:50"
 */
+ (NSString *)getCurrentTime;


/**
 获取当天日期

 @return @"2018-03-09"
 */
+ (NSString *)getTodayDate;

/**
 根据『时间戳』计算时间差（几小时前、几天前）

 @param timeStamp 时间戳（单位毫秒）
 @return 3分钟前
 */
+ (NSString *) compareCurrentTime:(NSTimeInterval)timeStamp;



@end
