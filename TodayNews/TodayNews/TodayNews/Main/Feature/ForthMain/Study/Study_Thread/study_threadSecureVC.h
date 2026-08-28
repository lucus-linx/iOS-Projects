//
//  study_threadSecureVC.h
//  TodayNews
//
//  Created by linxiang on 2018/5/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface study_threadSecureVC : UIViewController

// 测试原子性属性
@property (atomic, strong) NSString * atomic_str;

@property (nonatomic, strong) NSString * nonatomic_str;

@end
