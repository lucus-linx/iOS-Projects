//
//  RWTViewModelServices.h
//  RWTFlickrSearch
//
//  Created by linxiang on 2019/3/15.
//  Copyright © 2019年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RWTFlickrSearch.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RWTViewModelServices <NSObject>

// 该协议定义了一个方法，允许ViewModel获取对RWTFlickrSearch协议实现的引用。
- (id<RWTFlickrSearch>) getFlickrSearchService;

- (void)pushViewModel:(id)viewModel;

@end

NS_ASSUME_NONNULL_END
