//
//  Study_MVCVSMVVM_Person.h
//  TodayNews
//
//  Created by linxiang on 2019/3/14.
//  Copyright © 2019年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Study_MVCVSMVVM_Person : NSObject

@property (nonatomic, readonly) NSString *salutation;
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSDate *birthdate;

- (instancetype)initWithSalutation:(NSString *)salutation firstName:(NSString *)firstName lastName:(NSString *)lastName birthdate:(NSDate *)birthdate;

@end

NS_ASSUME_NONNULL_END
