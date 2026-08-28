//
//  Person.h
//  序列号与反序列号_004
//
//  Created by linxiang on 2017/3/22.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import <Foundation/Foundation.h>

//归档、解档的协议
@interface Person : NSObject<NSCoding>

@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) int age;

@property (assign, nonatomic) int age1;
@property (assign, nonatomic) int age2;
@property (assign, nonatomic) int age3;
@property (assign, nonatomic) int age4;

@end
