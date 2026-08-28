//
//  NSString+LXLogDeviceInfo.h
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/10.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LXLogDeviceInfo)


// **************** APP ******************

+(NSString *)getAPPInfo_BundleName;

+(NSString *)getAPPInfo_BundleDisplayName ;

+(NSString *)getAPPInfo_BundleIdentifier;

+(NSString *)getAPPInfo_BundleShortVersion;

+(NSString *)getAPPInfo_BundleVersion;


// **************** Device ******************
// 屏幕尺寸
+(NSString *)getDeviceScreenSize;
/// 获取设备版本号
+ (NSString *)getDeviceName;
/// 当前系统名称
+ (NSString *)getSystemName;
/// 获取iPhone名称
+ (NSString *)getiPhoneName;
/// 当前系统版本号
+ (NSString *)getSystemVersion;
/// 获取总内存大小
+ (NSString *)getTotalMemorySize;
/// 获取当前语言
+ (NSString *)getDeviceLanguage;

@end
