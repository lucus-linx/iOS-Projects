//
//  Study_NSDate_VC.m
//  TodayNews
//
//  Created by linxiang on 2018/3/9.
//  Copyright © 2018年 LX. All rights reserved.
//


/*
 格林威治标准时间GMT
    十七世纪，格林威治皇家天文台为了海上霸权的扩张计画而进行天体观测。1675年旧皇家观测所(Old Royal Observatory) 正式成立，
 到了1884年决定以通过格林威治的子午线作为划分地球东西两半球的经度零度。观测所门口墙上有一个标志24小时的时钟，显示当下的时间，
 对全球而言，这里所设定的时间是世界时间参考点，全球都以格林威治的时间作为标准来设定时间，这就是我们耳熟能详的
 「格林威治标准时间」(Greenwich Mean Time，简称G.M.T.)的由来，标示在手表上，则代表此表具有两地时间功能，
 也就是同时可以显示原居地和另一个国度的时间。
 
 
 世界协调时间UTC
    多数的两地时间表都以GMT来表示，但也有些两地时间表上看不到GMT字样，出现的反而是UTC这3个英文字母，究竟何谓UTC？事实上，
 UTC指的是Coordinated Universal Time－ 世界协调时间（又称世界标准时间、世界统一时间），是经过平均太阳时(以格林威治时间GMT为准)、
 地轴运动修正后的新时标以及以「秒」为单位的国际原子时所综合精算而成的时间，计算过程相当严谨精密，因此若以「世界标准时间」的角度来说，
 UTC比GMT来得更加精准。其误差值必须保持在0.9秒以内，若大于0.9秒则由位于巴黎的国际地球自转事务中央局发布闰秒，使UTC与地球自转周期一致。
 所以基本上UTC的本质强调的是比GMT更为精确的世界时间标准，不过对于现行表款来说，GMT与UTC的功能与精确度是没有差别的。
 */

/*
 纪元的显示：
 G：显示AD，也就是公元
 
 年的显示：
 yy：年的后面2位数字
 yyyy：显示完整的年
 
 月的显示：
 M：显示成1~12，1位数或2位数
 MM：显示成01~12，不足2位数会补0
 MMM：英文月份的缩写，例如：Jan
 MMMM：英文月份完整显示，例如：January
 
 日的显示：
 d：显示成1~31，1位数或2位数
 dd：显示成01~31，不足2位数会补0
 星期的显示：
 EEE：星期的英文缩写，如Sun
 EEEE：星期的英文完整显示，如，Sunday
 
 上/下午的显示：
 aa：显示AM或PM
 
 小時的显示：
 H：显示成0~23，1位数或2位数(24小时制
 HH：显示成00~23，不足2位数会补0(24小时制)
 K：显示成0~12，1位数或2位数(12小時制)
 KK：显示成0~12，不足2位数会补0(12小时制)
 
 分的显示：
 m：显示0~59，1位数或2位数
 mm：显示00~59，不足2位数会补0
 
 秒的显示：
 s：显示0~59，1位数或2位数
 ss：显示00~59，不足2位数会补0
 S： 毫秒的显示
 
 时区的显示：
 z / zz /zzz ：PDT
 zzzz：Pacific Daylight Time
 Z / ZZ / ZZZ ：-0800
 ZZZZ：GMT -08:00
 v：PT
 vvvv：Pacific Time
 
 */


#import "Study_NSDate_VC.h"

#import "NSString+DisplayTime.h"

@interface Study_NSDate_VC ()

@end

@implementation Study_NSDate_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"自定义NSDate";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    NSString * cur = [NSString getCurrentTimeStampWithSecond:YES];
    NSLog(@"cur = %@",cur);
    
    
    NSString * cur1 = [NSString getCurrentTimeStampWithSecond:NO];
    NSLog(@"cur = %@",cur1);
    

    NSDate* date = [NSDate date];
    NSTimeInterval timeSp = [date timeIntervalSince1970];
    
    
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:kCFDateFormatterNoStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"G yyyy-MM-dd HH:mm:ss EEE"];

    

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeSp];
    NSString *dateString = [formatter stringFromDate:confromTimesp];

    // 根据时间戳和格式 ==》 需要的时间格式
    NSString * str1 = [NSString timeWithTimeInterval:timeSp Format:@"" Area:LXTimeZoneTypeShanghai];
    
    //
    NSString * str2 = [NSString timeToTimeStamp:str1];
    
    
    NSString * str3 = [NSString getCurrentTime];
    
    NSString * str4 = [NSString getTodayDate];
    
    LXLog(@"");
}


/**
 iOS时区相关函数
 */
-(void)getTimeZone {
    // 系统时区不可改变
    NSTimeZone *systemZone = [NSTimeZone systemTimeZone];
    
    // 手机设置的时区，也就是我们自己设定的时区可以改变
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    
    LXLog(@"systemZone = %@ \nlocalZone = %@",systemZone,localZone);
    
    // 获取iOS系统内部所有支持的时区 注意：里面没有北京时区
    NSArray *zones = [NSTimeZone knownTimeZoneNames];
    for (NSString *zone in zones) {
        NSLog(@"时区名 = %@", zone);
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
