//
//  UIColor+Extension.h
//  TodayNews
//
//  Created by linxiang on 2018/2/27.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/*
    颜色转换：iOS中十六进制的颜色转换为UIColor(RGB)
    #开头、OX开头、六位数
 */
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
