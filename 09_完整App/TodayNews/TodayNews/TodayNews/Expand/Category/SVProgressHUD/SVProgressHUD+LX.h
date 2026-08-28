//
//  SVProgressHUD+LX.h
//  TodayNews
//
//  Created by linxiang on 2018/2/13.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (LX)

/*成功*/
+ (void)showSuccess:(NSString *)success;

/*失败*/
+ (void)showError:(NSString *)error;

/*警告*/
+ (void)showWarning:(NSString *)warning;

/*等待页面*/
+ (void)showMessage:(NSString *)message;

/*隐藏*/
+ (void)hideHUD;

@end
