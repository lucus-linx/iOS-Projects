//
//  AFAppDotNetAPIClient.m
//  TodayNews
//
//  Created by linxiang on 2018/4/23.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"

static NSString * const AFAppDotNetAPIBaseURLString = @"http://192.168.1.200:8086/";

@implementation AFAppDotNetAPIClient

+ (instancetype)sharedClient {
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // init  baseurl
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
    });
    
    return _sharedClient;
}

@end
