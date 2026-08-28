//
//  RWTFlickrSearch.h
//  RWTFlickrSearch
//
//  Created by linxiang on 2019/3/15.
//  Copyright © 2019年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RWTFlickrSearch <NSObject>

// 该协议定义了模型层的初始接口，并将搜索Flickr的任务移出了ViewModel。
- (RACSignal *)flickrSearchSignal:(NSString *)searchString;

@end

NS_ASSUME_NONNULL_END
