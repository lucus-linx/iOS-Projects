//
//  NSArray+AssociateObject.m
//  TodayNews
//
//  Created by linxiang on 2018/4/26.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "NSArray+AssociateObject.h"

#import <objc/runtime.h>

@implementation NSArray (AssociateObject)

// 定义关联的key
static const char *key = "blog";


/**
 blog的getter方法
 */
- (NSString *)blog
{
    // 根据关联的key，获取关联的值。
    return objc_getAssociatedObject(self, key);
}

/**
 blog的setter方法
 */
- (void)setBlog:(NSString *)blog
{
    // 第一个参数：给哪个对象添加关联
    // 第二个参数：关联的key，通过这个key获取
    // 第三个参数：关联的value
    // 第四个参数:关联的策略
    objc_setAssociatedObject(self, key, blog, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
