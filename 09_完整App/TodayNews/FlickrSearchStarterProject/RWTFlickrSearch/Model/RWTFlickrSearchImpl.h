//
//  RWTFlickrSearchImpl.h
//  RWTFlickrSearch
//
//  Created by linxiang on 2019/3/15.
//  Copyright © 2019年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RWTFlickrSearch.h"

#import "RWTFlickrSearchResults.h"
#import "RWTFlickrPhoto.h"
#import <objectiveflickr/ObjectiveFlickr.h>  // 包装Flickr API
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>  // 这个库为查询、筛选和转换数组和字典提供了一个流畅的功能接口。

NS_ASSUME_NONNULL_BEGIN

@interface RWTFlickrSearchImpl : NSObject <RWTFlickrSearch, OFFlickrAPIRequestDelegate>   // 新增协议


@property (strong, nonatomic) NSMutableSet *requests;
@property (strong, nonatomic) OFFlickrAPIContext *flickrContext;

@end

NS_ASSUME_NONNULL_END
