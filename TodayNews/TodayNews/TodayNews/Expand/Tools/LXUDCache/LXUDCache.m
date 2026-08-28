//
//  LXUDCache.m
//  TodayNews
//
//  Created by linxiang on 2018/2/26.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXUDCache.h"

@implementation LXUDCache

// 归档与反归档
+ (void)lx_setCache:(id)data forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)lx_loadCache:(NSString *)key {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:key]];
}

+ (void)lx_setCache_Bool:(BOOL)data forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)lx_loadCache_Bool:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (void)lx_clearCache:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

@end
