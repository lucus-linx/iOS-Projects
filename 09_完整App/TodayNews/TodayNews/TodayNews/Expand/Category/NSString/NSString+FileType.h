//
//  NSString+FileType.h
//  TodayNews
//
//  Created by linxiang on 2018/2/28.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FileType)

/**
 根据输入的文件名，判断是什么类型的文件

 @param fileName 路径 / 文件名（含后缀）
 @return gif/png/jpg....
 */
+ (NSString *)lx_FileType:(NSString *)fileName;

@end
