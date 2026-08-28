//
//  GlobalConst.m
//  TodayNews
//
//  Created by linxiang on 2018/2/8.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "GlobalConst.h"

@implementation GlobalConst

//*****************NetWork TimeOut***********************
double const NetWorkTimeOut_Time = 8.0f;


//************** Just Message *****************
// 用户信息异常，请重新登录
NSString * const MESSAGE_ACCOUNT_UNUSUALLY = @"用户信息出错，请重新登录";

// 网络请求
NSString * const MESSAGE_HTTPREQUEST_WAITING = @"请稍等...";            // 等待
NSString * const MESSAGE_HTTPREQUEST_SUCCESS = @"请求成功";             // 成功
NSString * const MESSAGE_HTTPREQUEST_SERVERERROR = @"服务器异常";        //服务器异常
NSString * const MESSAGE_HTTPREQUEST_FAILURE = @"请求失败，请检测网络！";  // 失败


//************** NSUserDefaults Key *****************
NSString * const UD_KEY_ISFIRSTUSEAPP = @"UD_KEY_isFirstUseApp";         //是否第一次使用APP
NSString * const UD_KEY_ISOPENLAUNCH_AD = @"UD_KEY_isOpenLaunch_AD";     //是否开启 启动时的广告
NSString * const UD_KEY_ISCLOSELAUNCH_GUIDE = @"UD_KEY_isCloseLaunch_Guide";   //是否开启 启动页引导
NSString * const UD_KEY_PYCOLOR = @"UD_KEY_pycolor";                     // PY颜色设置存储key
NSString * const UD_KEY_LXTHEMEMODEL = @"UD_KEY_LXThemeModel";           // 存储当前LXTheme主题类型的key
NSString * const UD_KEY_APPDIDACTIVETIME = @"UD_KEY_APPDidActiveTime";          // 记录APP DidActive时间点
NSString * const UD_KEY_APPRESIGNACTIVETIME = @"UD_KEY_APPResignActiveTime";    // 记录APP ResignActive时间点

@end
