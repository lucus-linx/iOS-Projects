//
//  NSURL+url.m
//  OC程序员最受欢迎_003
//
//  Created by linxiang on 2017/3/22.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "NSURL+url.h"

#import <objc/runtime.h>

@implementation NSURL (url)

+(void)load {
    NSLog(@"%s",__func__);
    
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
    
    NSURL * url = [NSURL LX_URLWithString:URLString];
    if (url == nil) {
        NSLog(@"url为空");
    }
    return url;
}


@end
