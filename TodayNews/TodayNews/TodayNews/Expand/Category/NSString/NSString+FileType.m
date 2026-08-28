//
//  NSString+FileType.m
//  TodayNews
//
//  Created by linxiang on 2018/2/28.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "NSString+FileType.h"

@implementation NSString (FileType)


+ (NSString *)lx_FileType:(NSString *)fileName {
    // 1.截取获得文件后缀，如果没有后最放回空字符串
    NSString * suffixStr = [fileName pathExtension];
    
    // 2.可能有大小写区分，所以都转换为小写
    suffixStr = suffixStr.lowercaseString;
    
    // 3.进行判断
    if ([suffixStr isEqualToString:@"png"]) {
        return @"png";
    }else if ([suffixStr isEqualToString:@"gif"]) {
        return @"gif";
    }else if ([suffixStr isEqualToString:@"jpg"]) {
        return @"jpg";
    }else if(suffixStr.length > 0){
        return @"请前往NSString+FileType.h进行补充！！";
    }
    
    return @"";
}


@end
