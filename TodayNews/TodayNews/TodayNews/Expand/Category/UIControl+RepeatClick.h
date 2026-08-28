//
//  UIControl+RepeatClick.h
//  TodayNews
//
//  Created by linxiang on 2018/2/12.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

#define defaultInterval 0.5   // 默认时间间隔

@interface UIControl (RepeatClick)

@property (nonatomic, assign) NSTimeInterval timeInterval;  // 用这个给重复点击加间隔
@property (nonatomic, assign) BOOL isIgnoreEvent;   ////YES不允许点击    NO允许点击

@end
