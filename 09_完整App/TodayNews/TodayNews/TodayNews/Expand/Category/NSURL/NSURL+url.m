//
//  NSURL+url.m
//  PAL-iOS
//
//  Created by linxiang on 2017/12/21.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "NSURL+url.h"

//导入runtime头文件
#import <objc/runtime.h>

@implementation NSURL (url)

+(void)load {
    //交换我们的URLWithString和LX_URLWithString方法
    //第一步：拿到这两个方法
    //class_getClassMethod     获取类方法
    //class_getInstanceMethod  获取对象方法
    Method URLWithStr = class_getClassMethod(self, @selector(URLWithString:));
    Method LXURLWithStr = class_getClassMethod(self, @selector(LX_URLWithString:));
    //第二步：交换方法
    method_exchangeImplementations(URLWithStr, LXURLWithStr);
}

//重新创建一个
+(instancetype)LX_URLWithString:(NSString *)URLString {
    // 对URLString进行处理，汉字或者空格等无法被识别
    NSString * URLString_new = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL * url = [NSURL LX_URLWithString:URLString_new];   //这里的"LX_URLWithString"是已经交换过的 == 以前的"URLWithString"
    if (url == nil) {
        NSLog(@"url为空");
    }
    return url;
}

@end
