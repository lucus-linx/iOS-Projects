//
//  RWTSearchResultsViewModel.h
//  RWTFlickrSearch
//
//  Created by linxiang on 2019/3/15.
//  Copyright © 2019年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RWTViewModelServices.h"
#import "RWTFlickrSearchResults.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWTSearchResultsViewModel : NSObject

- (instancetype)initWithSearchResults:(RWTFlickrSearchResults *)results services:(id<RWTViewModelServices>)services;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *searchResults;

@end

NS_ASSUME_NONNULL_END
