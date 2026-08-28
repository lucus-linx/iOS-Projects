//
//  LXBaseModel.m
//  TodayNews
//
//  Created by linxiang on 2018/2/8.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXBaseModel.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation LXBaseModel

// 归档 告诉系统需要归档的属性
- (void)encodeWithCoder:(NSCoder *)coder
{
    //如果属性过多，这样写就比较麻烦
    unsigned int count = 0;
    Ivar * ivars = class_copyIvarList([self class], &count);
    //for 搞定
    for (int i = 0; i < count; i++) {
        //拿个每一个ivar
        Ivar ivar = ivars[i];
        //ivar对应的名称
        const char * name = ivar_getName(ivar);
        //转成 OC
        NSString * key = [NSString stringWithUTF8String:name];
        //获取属性值 -- KVC
        id value = [self valueForKey:key];
        //归档
        [coder encodeObject:value forKey:key];
    }
    //这个变量不归OC管理，ARC处理不了，所以需要手动释放
    free(ivars);
}

// 解档
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        //如果属性过多，这样写就比较麻烦
        unsigned int count = 0;
        Ivar * ivars = class_copyIvarList([self class], &count);
        //for 搞定
        for (int i = 0; i < count; i++) {
            //拿个每一个ivar
            Ivar ivar = ivars[i];
            //ivar对应的名称
            const char * name = ivar_getName(ivar);
            //转成 OC
            NSString * key = [NSString stringWithUTF8String:name];
            //解档
            id value = [coder decodeObjectForKey:key];
            //设置到属性 -- KVC
            [self setValue:value forKey:key];
            //NSLog(@"BBBBB == %@",key);
        }
        //这个变量不归OC管理，ARC处理不了，所以需要手动释放
        free(ivars);
    }
    return self;
}


@end
