//
//  LXLog.h
//  TodayNews
//
//  Created by linxiang on 2018/2/11.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _LogOwner
{
    Log_All      =0,
    Log_LX       =1,
    Log_AA       =2,
    Log_BB       =3,
}LogOwner;


#ifndef __OPTIMIZE__
// 这里执行的是debug模式下
#define CTLogBase(owner,onwer_type,fmt,...) if ([[LXLog defaultCTLog].owners containsObject:[NSNumber numberWithInteger:Log_All]] || [[LXLog defaultCTLog].owners containsObject:[NSNumber numberWithInteger:onwer_type]])\
{\
NSLog((@"[owner: %@] %s [line: %d] " fmt),owner ,__FUNCTION__ ,__LINE__, ##__VA_ARGS__);\
}
#else
// 这里执行的是release模式下
#define CTLogBase(owner,onwer_type,fmt,...)
#endif

// NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d]" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define LXLog(fmt,...) CTLogBase(@"LX",Log_LX,fmt,##__VA_ARGS__)
#define AALog(fmt,...) CTLogBase(@"AA",Log_AA,fmt,##__VA_ARGS__)
#define BBLog(fmt,...) CTLogBase(@"BB",Log_BB,fmt,##__VA_ARGS__)


/**
 *  调试辅助类
 */
@interface LXLog : NSObject

@property (nonatomic,strong)NSMutableArray *owners;

+(instancetype)defaultCTLog;

/** 只显示该开发者的调试日志 */
-(void)setLogOwner:(LogOwner)owner;


@end
