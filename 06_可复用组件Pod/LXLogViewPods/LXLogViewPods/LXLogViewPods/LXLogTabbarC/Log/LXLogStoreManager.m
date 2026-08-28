//
//  LXLogStoreManager.m
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXLogStoreManager.h"

#import "LXLogCompat.h"

#import "LXLogGlobalConst.h"

@implementation LXLogStoreManager


+(instancetype)shared {
    static LXLogStoreManager * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LXLogStoreManager alloc]init];
    });
    return _instance;
}

-(instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    // 初始化
    _defaultLogArr = [[NSMutableArray alloc]initWithCapacity:5];
    _config = [LXLogConfig shared];
    
    return self;
}


/**
 新增
 */
-(void)addLXLog:(LXLogModel *)model {
    // 超出规定数额，删除第一个，再新增
    if (_defaultLogArr.count >= _config.logMaxCount) {
        // 防止崩溃
        if (_defaultLogArr.count > 0) {
            [_defaultLogArr removeObjectAtIndex:0];
        }
    }
    // 直接添加
    if (model) {
        [_defaultLogArr addObject:model];
    }
}

/**
 移除
 */
-(void)removeLXLog:(LXLogModel *)model {
    for (int i = 0; i < _defaultLogArr.count; i++) {
        LXLogModel * m = _defaultLogArr[i];
        if ([m.Id isEqualToString:model.Id]) {   // 判断UUID是否相等
            [_defaultLogArr removeObjectAtIndex:i];
        }
    }
    
    // 主线程发送通知，刷新界面
    dispatch_main_async_safe(^{
        // 创建通知
        NSNotification *notification = [NSNotification notificationWithName:KNotification_RefreshLXLog object:nil userInfo:nil];
        // 通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    });
}

/**
 重置
 */
-(void)resetLXLogs {
    // 移除所有数据
    [_defaultLogArr removeAllObjects];
    
    // 主线程发送通知，刷新界面
    dispatch_main_async_safe(^{
        // 创建通知
        NSNotification *notification = [NSNotification notificationWithName:KNotification_RefreshLXLog object:nil userInfo:nil];
        // 通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    });
}










@end
