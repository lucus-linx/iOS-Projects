//
//  PingThread.m
//  APM
//
//  Created by 启业云03 on 2020/7/2.
//  Copyright © 2020 LD. All rights reserved.
//

#import "PingThread.h"

@interface PingThread()

@end

@implementation PingThread

- (void)main {
    
    while (!self.isCancelled) {
        @autoreleasepool {
            __block BOOL isRespons = NO;

            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

            // 主线程同步
            dispatch_async(dispatch_get_main_queue(), ^{
                                
                isRespons = YES;
                dispatch_semaphore_signal(semaphore);
            });
            
            [NSThread sleepForTimeInterval:2];
            
            if (!isRespons) {
                NSLog(@"卡卡卡卡");
            }
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    }
}

@end
