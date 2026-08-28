//
//  Person.m
//  序列号与反序列号_004
//
//  Created by linxiang on 2017/3/22.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "Person.h"

#import <objc/runtime.h>

@implementation Person

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
    /*
        unsigned int count1 = 0;
        objc_property_t * objArr = class_copyPropertyList([Person class], &count1);
        
        for (int j = 0; j<count1; j++) {
            const char * name1 = property_getName(objArr[j]);
            
            NSString * key1 = [NSString stringWithUTF8String:name1];
            
            NSLog(@"AAAAAA == %@",key1);
        }
     */
        
        //如果属性过多，这样写就比较麻烦
        unsigned int count = 0;
        Ivar * ivars = class_copyIvarList([Person class], &count);
        
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
            
            NSLog(@"BBBBB == %@",key);
        }
        
        free(ivars);
    }
    return self;
}


//告诉系统需要归档的属性
- (void)encodeWithCoder:(NSCoder *)coder
{
    //如果属性过多，这样写就比较麻烦
    unsigned int count = 0;
    Ivar * ivars = class_copyIvarList([Person class], &count);
    
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
    
    free(ivars);
}




@end
