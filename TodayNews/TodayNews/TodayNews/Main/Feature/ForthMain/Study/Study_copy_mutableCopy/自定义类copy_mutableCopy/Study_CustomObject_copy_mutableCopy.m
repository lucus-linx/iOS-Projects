//
//  Study_CustomObject_copy_mutableCopy.m
//  TodayNews
//
//  Created by linxiang on 2018/10/31.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_CustomObject_copy_mutableCopy.h"

@implementation Study_CustomObject_copy_mutableCopy

- (id)copyWithZone:(NSZone *)zone
{
    Study_CustomObject_copy_mutableCopy *customobject = [[Study_CustomObject_copy_mutableCopy allocWithZone:zone] init];
    
    customobject.age = self.age;
    customobject.name = self.name;
    
//    customobject.age = [self.age copy];
//    customobject.name = [self.name copy];
    
    return customobject;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    Study_CustomObject_copy_mutableCopy *customobject = [[Study_CustomObject_copy_mutableCopy allocWithZone:zone] init];
    
    customobject.age = self.age;
    customobject.name = self.name;
    
//    customobject.age = [self.age mutableCopy];
//    customobject.name = [self.name mutableCopy];
    
    return customobject;
}

@end
