//
//  LXLogMemoryHelper.h
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/18.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXLogMemoryHelper : NSObject

+ (instancetype)shared;

- (NSString *)appUsedMemoryAndPercentage;
- (NSString *)appUsedMemoryAndFreeMemory;

@end
