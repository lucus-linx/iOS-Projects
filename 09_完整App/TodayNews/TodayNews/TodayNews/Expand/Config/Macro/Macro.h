//
//  Macro.h
//  TodayNews
//
//  Created by linxiang on 2018/2/8.
//  Copyright © 2018年 LX. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


//获取系统对象
#define KApplication        [UIApplication sharedApplication]
#define KAppWindow          [UIApplication sharedApplication].delegate.window
#define KAppDelegate        [AppDelegate shareAppDelegate]
#define KRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define KUserDefaults       [NSUserDefaults standardUserDefaults]
#define KNotificationCenter [NSNotificationCenter defaultCenter]

// W H
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#define TABBAR_HEIGHT    ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) // 适配iPhone x 底栏高度
#define STATUS_HEIGHT    ([[UIApplication sharedApplication] statusBarFrame].size.height>20?44:20) // 适配iPhone x 状态栏
#define BOTTOM_HEIGHT    ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)  // 适配iphone X 底部多出来的高度


//----------------判断当前的iPhone设备/系统版本---------------
// 判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// 判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
// 判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

//----------------判断系统版本---------------
// 获取系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
// 判断 iOS 8 或更高的系统版本
#define IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))
// 判断 iOS 10 或更高的系统版本
#define IOS_VERSION_10_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=10.0)? (YES):(NO))

//----------------判断机型 根据尺寸---------------
// 判断是否为 iPhone 4/4S - 3.5 inch
#define iPhone4_4S [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 480.0f
// 判断是否为 iPhone 5/5SE - 4.0 inch
#define iPhone5_5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
// 判断是否为iPhone 6/6S/7/8 - 4.7 inch
#define iPhone6_6S [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
// 判断是否为iPhone 6Plus/6SPlus/7P/8P - 5.5 inch
#define iPhone6Plus_8Plus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f
// 判断是否为iPhoneX - 5.8 inch
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否为iPhoneXS - 5.8 inch
#define iPhoneXS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否为iPhoneXR - 6.1 inch
#define iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否为iPhoneXS MAX - 6.5 inch
#define iPhoneXSMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

// 主要是用于区分是否是 刘海屏
#define LiuHaiPhone \
({BOOL isLiuHaiPhone = NO;\
if (@available(iOS 11.0, *)) {\
isLiuHaiPhone = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isLiuHaiPhone);})


//--------------生成随机数---------------
#define LXRandNum(i) arc4random()%i   // [0,i) 范围内随机数
#define LXRandNum_FromTo(i,j) (from + (arc4random() % (to – from +1)))


//---------------Colour-------------------
// 设置随机颜色
#define LXRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
// 设置RGB颜色/设置RGBA颜色
#define LXRGBAColor(r, g, b, a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define LXRGBColor(r, g, b)      LXRGBAColor(r,g,b,1.0f)
// 十六进制数值 eg:@"#3499DB"
#define LXCOLOR_WITH_HEX [UIColor colorFromHexString: hexValue]
#define LXCOLOR_WITH_HEX_1(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]


//--------------沙盒目录文件---------------
// 获取沙盒主目录路径
#define LXSBPath_Home = NSHomeDirectory();
//获取沙盒 Document
#define LXSBPath_Document [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Library
#define LXSBPath_Library [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
//获取沙盒 Cache
#define LXSBPath_Cache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
//获取temp
#define LXSBPath_Temp NSTemporaryDirectory()


//--------------判断为空---------------
//字符串是否为空
#define KString_Is_Empty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define KArray_Is_Empty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define KDict_Is_Empty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define KObject_Is_Empty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))


//--------------MainThread---------------
#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif


//--------------WeakSelf、StrongSelf---------------
#define WeakSelf(type)    __weak typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;


//--------------View 圆角、边框---------------
#define LXViewBorderRadius(View, Radius, Width, UIColor)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]


#endif /* Macro_h */
