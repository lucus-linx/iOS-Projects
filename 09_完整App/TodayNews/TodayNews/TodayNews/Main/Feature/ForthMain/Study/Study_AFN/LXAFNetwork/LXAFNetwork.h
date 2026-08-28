//
//  LXAFNetwork.h
//  TodayNews
//
//  Created by linxiang on 2018/4/23.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXAFNetwork : NSObject

+(NSURLSessionDataTask *)LXAFNetwork_POST:(NSString *)URLString
                               parameters:(id)parameters
                                 progress:(void (^)(NSProgress *))uploadProgress
                                  success:(void (^)(NSURLSessionDataTask *, id))success
                                  failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end
