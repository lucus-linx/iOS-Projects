//
//  Study_CustomObject_copy_mutableCopy.h
//  TodayNews
//
//  Created by linxiang on 2018/10/31.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Study_CustomObject_copy_mutableCopy : NSObject <NSCopying, NSMutableCopying>  // 协议

@property (copy,nonatomic) NSString *name;

@property (copy,nonatomic) NSString *age;

@end
