//
//  KVCPerson.h
//  TodayNews
//
//  Created by linxiang on 2019/4/2.
//  Copyright © 2019年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KVCStudent;

NS_ASSUME_NONNULL_BEGIN

@interface KVCPerson : NSObject

@property (nonatomic, assign) NSInteger A;
@property (nonatomic, strong) NSNumber *B;
@property (nonatomic, strong) KVCStudent *C;
@property (nonatomic, strong) NSArray<NSString *> *D;

@end

NS_ASSUME_NONNULL_END
