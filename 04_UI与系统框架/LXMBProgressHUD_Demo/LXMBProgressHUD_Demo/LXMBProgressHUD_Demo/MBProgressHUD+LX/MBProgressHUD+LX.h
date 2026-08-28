//
//  MBProgressHUD+LX.h
//  LXMBProgressHUD_Demo
//
//  Created by linxiang on 2017/5/11.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (LX)

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end
