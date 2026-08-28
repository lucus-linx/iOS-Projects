//
//  Study_MVCVSMVVM_MVVM_PersonViewModel.h
//  TodayNews
//
//  Created by linxiang on 2019/3/14.
//  Copyright © 2019年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Study_MVCVSMVVM_Person;

NS_ASSUME_NONNULL_BEGIN

@interface Study_MVCVSMVVM_MVVM_PersonViewModel : NSObject

- (instancetype)initWithPerson:(Study_MVCVSMVVM_Person *)person;

@property (nonatomic, readonly) Study_MVCVSMVVM_Person *person;

@property (nonatomic, readonly) NSString *nameText;
@property (nonatomic, readonly) NSString *birthdateText;

@end

NS_ASSUME_NONNULL_END
