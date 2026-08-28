//
//  LXTabBar.h
//  TodayNews
//
//  Created by linxiang on 2018/2/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

// 自定义圆形按钮
#import "LXCircleButton.h"

@interface LXTabBar : UITabBar

@property (nonatomic, strong) LXCircleButton *centerBtn; //中间按钮

@end
