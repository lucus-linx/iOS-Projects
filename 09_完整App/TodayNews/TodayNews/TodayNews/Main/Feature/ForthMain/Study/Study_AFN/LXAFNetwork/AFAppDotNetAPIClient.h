//
//  AFAppDotNetAPIClient.h
//  TodayNews
//
//  Created by linxiang on 2018/4/23.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@class AFNetworking;

@interface AFAppDotNetAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
