//
//  AppUseTime_API.h
//  TodayNews
//
//  Created by linxiang on 2018/3/5.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppUseTime;

@interface AppUseTime_API : NSObject

+ (instancetype)sharedInstance;

- (void)insertModel:(NSDictionary *)dic success:(void(^)(void))success fail:(void(^)(NSError *error))fail;

- (void)readAllUploadModel:(void(^)(NSArray *finishArray))success fail:(void(^)(NSError *error))fail;

- (void)deleteUploadModel:(AppUseTime *)model success:(void(^)(void))success fail:(void(^)(NSError *error))fail;

- (void)deleteAllUploadModel:(void(^)(void))success fail:(void(^)(NSError *error))fail;


@end
