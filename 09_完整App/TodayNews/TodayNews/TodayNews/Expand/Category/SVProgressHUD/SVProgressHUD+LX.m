//
//  SVProgressHUD+LX.m
//  TodayNews
//
//  Created by linxiang on 2018/2/13.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "SVProgressHUD+LX.h"

#define DefaultInterval 0.7f

@implementation SVProgressHUD (LX)

+ (void)SetConfig {
    [SVProgressHUD setHapticsEnabled:YES];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark]; //框框背景样式
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear]; // 整个页面背景样式.觉得是否可以透视点击
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];  // 转个圈的样式
    
    //[SVProgressHUD setContainerView:self.view];  //放置在哪个图层，默认在Window层
    
//    + (void)setMinimumSize:(CGSize)minimumSize;
    
    [SVProgressHUD setMinimumSize:CGSizeMake(100, 100)]; // 设置框框最小 大小
    
    // 对大小边框的设置
    /*
     + (void)setMinimumSize:(CGSize)minimumSize;                         // default is CGSizeZero, can be used to avoid resizing
     + (void)setRingThickness:(CGFloat)width;                            // default is 2 pt
     + (void)setRingRadius:(CGFloat)radius;                              // default is 18 pt
     + (void)setRingNoTextRadius:(CGFloat)radius;                        // default is 24 pt
     + (void)setCornerRadius:(CGFloat)cornerRadius;                      // default is 14 pt
     + (void)setBorderColor:(nonnull UIColor*)color;                     // default is nil
     + (void)setBorderWidth:(CGFloat)width;                              // default is 0
     */
    
    //[SVProgressHUD setMaxSupportedWindowLevel:UIWindowLevelNormal];
}

+ (void)showSuccess:(NSString *)success {
    [self SetConfig];
    [SVProgressHUD showSuccessWithStatus:success];
    [SVProgressHUD dismissWithDelay:DefaultInterval];
}

+ (void)showError:(NSString *)error {
    [self SetConfig];
    
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 100)];
    
    [SVProgressHUD showErrorWithStatus:error];
    [SVProgressHUD dismissWithDelay:DefaultInterval];
}

+ (void)showWarning:(NSString *)warning {
    [self SetConfig];
    [SVProgressHUD showInfoWithStatus:warning];
    [SVProgressHUD dismissWithDelay:DefaultInterval];
}

+ (void)showMessage:(NSString *)message {
    [self SetConfig];
    [SVProgressHUD showWithStatus:message];
}

+ (void)hideHUD {
    [SVProgressHUD dismiss];
}


@end
