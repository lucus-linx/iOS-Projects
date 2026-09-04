//
//  CatonMonitor.h
//  APM
//
//  Created by 启业云03 on 2020/7/2.
//  Copyright © 2020 LD. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 消息来源
typedef NS_ENUM(NSInteger, CatonMonitorType) {
    CatonMonitorType_FPS = 0, 
    CatonMonitorType_RunLoop,
    CatonMonitorType_SubThread
};



NS_ASSUME_NONNULL_BEGIN

@interface CatonMonitor : NSObject

+ (instancetype)shareInstance;

- (void)beginMonitor; //开始监视卡顿
- (void)endMonitor;   //停止监视卡顿

@end

NS_ASSUME_NONNULL_END
