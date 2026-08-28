//
//  NSString+DisplayTime.m
//  TodayNews
//
//  Created by linxiang on 2018/3/8.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "NSString+DisplayTime.h"

@implementation NSString (DisplayTime)


/**
 获得当前时间戳 - 此处时间戳是国际标准时间 不是本地时间

 @param ISSecond 计量单位 是否为秒   YES:秒   NO:毫秒
 @return 时间戳
 */
+ (NSString *)getCurrentTimeStampWithSecond:(BOOL)ISSecond {
    // 2018-03-09 02:04:54 +0000 UTC  此时的时间是 世界标准时间e 与北京时间相差8小时
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    // 计算NSDate对象距离1970年1月1号  00:00:00 的时间戳。
    NSTimeInterval timeSp = [date timeIntervalSince1970];   //  *1000 是精确到毫秒，不乘就是精确到秒
    if (!ISSecond) {
        timeSp = timeSp * 1000;
    }
    // 转换格式
    NSString * timeString = [NSString stringWithFormat:@"%0.f", timeSp];//转为字符型
    
    return timeString;
}


/**
 "2011-01-26 17:40:50" ==》 时间戳（单位秒）

 @param timeStr 时间
 @return 时间戳（秒）
 */
+ (NSString *)timeToTimeStamp:(NSString *)timeStr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSDate* date = [formatter dateFromString:timeStr];   //------------将字符串按formatter转成nsdate
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timeSp;
}


/**
 时间戳（单位秒） ==》 类似于yyyy-MM-dd HH:mm:ss
 
 @param timeSp 时间戳（单位秒）
 @param timeZone LXTimeZoneType 时区选择
 @return 类似yyyy-MM-dd HH:mm:ss 格式
 */
+ (NSString *)timeWithTimeInterval:(NSTimeInterval)timeSp Format:(NSString *)format Area:(LXTimeZoneType)timeZone
{
    // 设置格式
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];

    if (format.length > 0) {
        // 如果有参数传入，则设置参数的格式
        [formatter setDateFormat:format];
    }else {
        // 如果没有参数，则默认格式
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    
    // 时区
    if (timeZone == LXTimeZoneTypeNoOptions) {
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];  // @"UTC"也可以 零区时间
    } else if (timeZone == LXTimeZoneTypeShanghai) {
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    } else if (timeZone == LXTimeZoneTypeHong_Kong) {
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"]];
    }
    
    // 根据时间戳（单位秒）转换获得 NSDate
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeSp];
    // 格式转换
    NSString *dateString = [formatter stringFromDate:confromTimesp];
    
    return dateString;
}



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

/**
 获取当天日期
 
 @return @"2018-03-09"
 */
+ (NSString *)getTodayDate {
    //1.获取时间戳
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    //2.格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    //3.直接转换
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}


//通过时间戳计算时间差（几小时前、几天前）
+(NSString *) compareCurrentTime:(NSTimeInterval)timeStamp
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeStamp/1000];
    
    NSTimeInterval  timeInterval = [confromTimesp timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *referenceComponents=[calendar components:unitFlags fromDate:confromTimesp];
    //    NSInteger referenceYear  =referenceComponents.year;
    //    NSInteger referenceMonth =referenceComponents.month;
    //    NSInteger referenceDay   =referenceComponents.day;
    NSInteger referenceHour = referenceComponents.hour;
    //    NSInteger referemceMinute=referenceComponents.minute;
    
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp= timeInterval/60) < 60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = timeInterval/3600) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if ((temp = timeInterval/3600/24)==1)
    {
        result = [NSString stringWithFormat:@"昨天%ld时",(long)referenceHour];
    }
    else if ((temp = timeInterval/3600/24)==2)
    {
        result = [NSString stringWithFormat:@"前天%ld时",(long)referenceHour];
    }
    
    else if((temp = timeInterval/3600/24) <31){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = timeInterval/3600/24/30) <12){
        result = [NSString stringWithFormat:@"%ld个月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}


@end
