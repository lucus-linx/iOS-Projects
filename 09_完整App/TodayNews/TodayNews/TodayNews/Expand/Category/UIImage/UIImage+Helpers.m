//
//  UIImage+Helpers.m
//  TodayNews
//
//  Created by linxiang on 2018/2/26.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "UIImage+Helpers.h"

@implementation UIImage (Helpers)

+ (instancetype)imageFilledWithColor:(UIColor *)color {
    UIImage *result;
    
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    [color setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, 1, 1));
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
