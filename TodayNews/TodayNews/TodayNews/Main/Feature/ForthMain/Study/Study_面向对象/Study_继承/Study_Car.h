//
//  Study_Car.h
//  TodayNews
//
//  Created by linxiang on 2018/7/13.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Study_Car : NSObject{
    NSString *_brand;
    NSString *_color;
}

- (void)setBrand:(NSString *)brand;
- (void)setColor:(NSString *)color;
- (void)brake;
- (void)quicken;

@end
