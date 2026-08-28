//
//  LXLogMemoryLabel.m
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/18.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXLogMemoryLabel.h"

#import "LXLogMemoryHelper.h"

@interface LXLogMemoryLabel (){
    dispatch_source_t timer;
}

@end

@implementation LXLogMemoryLabel


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.text = @"";
    self.backgroundColor = [UIColor clearColor];
    self.adjustsFontSizeToFitWidth = YES;
    self.textColor = [UIColor blackColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.clipsToBounds = YES;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    
    // 获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建定时器
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 开始时间
    //                dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));   // 3秒后
    dispatch_time_t start = dispatch_walltime(NULL, 0);
    // 重复间隔
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    // 设置定时器
    dispatch_source_set_timer(timer, start, interval, 0);
    // 设置需要执行的事件
    dispatch_source_set_event_handler(timer, ^{
        //在这里执行事件
        dispatch_async(dispatch_get_main_queue(), ^{
            self.text = [[LXLogMemoryHelper shared] appUsedMemoryAndFreeMemory];
        });
        /*
         // 关闭定时器
         dispatch_source_cancel(_timer);
         */
    });
    // 开启定时器
    dispatch_resume(timer);
    
    return self;
}












@end
