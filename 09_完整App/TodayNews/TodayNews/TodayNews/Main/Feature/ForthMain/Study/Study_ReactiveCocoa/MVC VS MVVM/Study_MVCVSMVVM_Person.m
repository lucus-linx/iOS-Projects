//
//  Study_MVCVSMVVM_Person.m
//  TodayNews
//
//  Created by linxiang on 2019/3/14.
//  Copyright © 2019年 LX. All rights reserved.
//

#import "Study_MVCVSMVVM_Person.h"

@interface Study_MVCVSMVVM_Person()

@property (nonatomic, strong, readwrite) NSString *salutation;
@property (nonatomic, strong, readwrite) NSString *firstName;
@property (nonatomic, strong, readwrite) NSString *lastName;
@property (nonatomic, strong, readwrite) NSDate *birthdate;

@end

@implementation Study_MVCVSMVVM_Person

- (instancetype)initWithSalutation:(NSString *)salutation firstName:(NSString *)firstName lastName:(NSString *)lastName birthdate:(NSDate *)birthdate {
    self = [super init];
    if (self) {
        _salutation = salutation;
        _firstName = firstName;
        _lastName = lastName;
        _birthdate = birthdate;
    }
    
    return self;
}

@end
