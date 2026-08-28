//
//  GlobalConst.h
//  TodayNews
//
//  Created by linxiang on 2018/2/8.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlobalConst : NSObject

//*****************NetWork TimeOut***********************
//网络请求超时时间
UIKIT_EXTERN double const NetWorkTimeOut_Time;

//************** Just Message *****************
// 用户信息异常，请重新登录
UIKIT_EXTERN NSString * const MESSAGE_ACCOUNT_UNUSUALLY;

// 网络请求
UIKIT_EXTERN NSString * const MESSAGE_HTTPREQUEST_WAITING;   // 等待
UIKIT_EXTERN NSString * const MESSAGE_HTTPREQUEST_SUCCESS;   // 成功
UIKIT_EXTERN NSString * const MESSAGE_HTTPREQUEST_SERVERERROR; //服务器异常
UIKIT_EXTERN NSString * const MESSAGE_HTTPREQUEST_FAILURE;   // 失败


//************** NSUserDefaults Key *****************

UIKIT_EXTERN NSString * const UD_KEY_ISFIRSTUSEAPP;   //是否第一次使用APP
UIKIT_EXTERN NSString * const UD_KEY_ISOPENLAUNCH_AD;   //是否开启 启动时的广告
UIKIT_EXTERN NSString * const UD_KEY_ISCLOSELAUNCH_GUIDE;   //是否开启 启动页引导

UIKIT_EXTERN NSString * const UD_KEY_PYCOLOR;   // PY颜色设置存储key

UIKIT_EXTERN NSString * const UD_KEY_LXTHEMEMODEL;   // 存储当前LXTheme主题类型的key

UIKIT_EXTERN NSString * const UD_KEY_APPDIDACTIVETIME;  // 记录APP DidActive时间点
UIKIT_EXTERN NSString * const UD_KEY_APPRESIGNACTIVETIME;  // 记录APP ResignActive时间点

@end
