//
//  Study_PassValue_B_VC.h
//  TodayNews
//
//  Created by linxiang on 2018/4/27.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

// block define
typedef void(^passValueBlock)(NSDictionary *);

@interface Study_PassValue_B_VC : UIViewController

// 声明block属性
@property (nonatomic, copy) passValueBlock myblock;
// 声明block方法

@end
