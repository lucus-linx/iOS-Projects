//
//  LXUDCache.h
//  TodayNews
//
//  Created by linxiang on 2018/2/26.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXUDCache : NSObject

// 归档与反归档
+ (void)lx_setCache:(id)data forKey:(NSString *)key;
+ (id)lx_loadCache:(NSString *)key;

+ (void)lx_setCache_Bool:(BOOL)data forKey:(NSString *)key;

+ (BOOL)lx_loadCache_Bool:(NSString *)key;

+ (void)lx_clearCache:(NSString *)key;

@end
