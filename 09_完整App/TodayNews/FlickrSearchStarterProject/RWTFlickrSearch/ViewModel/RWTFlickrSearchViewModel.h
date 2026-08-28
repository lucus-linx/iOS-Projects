//
//  RWTFlickrSearchViewModel.h
//  RWTFlickrSearch
//
//  Created by linxiang on 2019/3/15.
//  Copyright © 2019年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "RWTViewModelServices.h"

#import "RWTSearchResultsViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWTFlickrSearchViewModel : NSObject

@property (nonatomic, strong, readwrite) NSString *searchText;
@property (nonatomic, strong, readwrite) NSString *title;


@property (strong, nonatomic) RACCommand *executeSearch;

- (instancetype)initWithServices:(id<RWTViewModelServices>)services;

@end

NS_ASSUME_NONNULL_END
