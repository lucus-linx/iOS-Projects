//
//  Study_MVCVSMVVM_MVVM_PersonViewModel.m
//  TodayNews
//
//  Created by linxiang on 2019/3/14.
//  Copyright © 2019年 LX. All rights reserved.
//

#import "Study_MVCVSMVVM_MVVM_PersonViewModel.h"

#import "Study_MVCVSMVVM_Person.h"

@interface Study_MVCVSMVVM_MVVM_PersonViewModel()

@property (nonatomic, strong, readwrite) Study_MVCVSMVVM_Person *person;

@property (nonatomic, strong, readwrite) NSString *nameText;
@property (nonatomic, strong, readwrite) NSString *birthdateText;

@end

@implementation Study_MVCVSMVVM_MVVM_PersonViewModel

- (instancetype)initWithPerson:(Study_MVCVSMVVM_Person *)person {
    self = [super init];
    if (!self) return nil;
    
    _person = person;
    if (person.salutation.length > 0) {
        _nameText = [NSString stringWithFormat:@"%@ %@ %@", self.person.salutation, self.person.firstName, self.person.lastName];
    } else {
        _nameText = [NSString stringWithFormat:@"%@ %@", self.person.firstName, self.person.lastName];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    _birthdateText = [dateFormatter stringFromDate:person.birthdate];
    
    return self;
}

@end
