//
//  Study_Taxi.h
//  TodayNews
//
//  Created by linxiang on 2018/7/13.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_Car.h"

@interface Study_Taxi : Study_Car {
    NSString *_company;//所属公司
}

//打印发票
- (void)printTick;

@end
