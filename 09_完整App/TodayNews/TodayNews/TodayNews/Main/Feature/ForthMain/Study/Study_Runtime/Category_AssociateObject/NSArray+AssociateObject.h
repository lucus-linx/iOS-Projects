//
//  NSArray+AssociateObject.h
//  TodayNews
//
//  Created by linxiang on 2018/4/26.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (AssociateObject)

// 不会生成添加属性的getter和setter方法，必须我们手动生成
@property (nonatomic, copy) NSString * blog;

@end
