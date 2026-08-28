//
//  RWTFlickrSearchViewModel.m
//  RWTFlickrSearch
//
//  Created by linxiang on 2019/3/15.
//  Copyright © 2019年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewModel.h"

@interface RWTFlickrSearchViewModel ()

@property (nonatomic, weak) id<RWTViewModelServices> services;

@end

@implementation RWTFlickrSearchViewModel

- (instancetype) initWithServices:(id<RWTViewModelServices>)services {
    self = [super init];
    if (self) {
        _services = services;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.title = @"Flickr Search";

    /*
     map操作将文本转换为true和false信号
     distinctUntilChanged：确保此信号仅在状态更改时才发出值。
     */
    RACSignal * validSearchSignal = [[RACObserve(self, searchText)
                                      map:^id(NSString * value) {
                                          return @(value.length > 3);
                                      }]distinctUntilChanged];
    [validSearchSignal subscribeNext:^(NSNumber * x) {
        NSLog(@"search text is valid %@",x);
    }];


    self.executeSearch = [[RACCommand alloc] initWithEnabled:validSearchSignal
                                                 signalBlock:^RACSignal *(id input) {
                                                     return [self executeSearchSignal];
                                                 }];
}

//-(RACSignal *)executeSearchSignal {
//
//    // return [[[[RACSignal empty] logAll] delay:2.0] logAll];
//
//    return [[[self.services getFlickrSearchService] flickrSearchSignal:self.searchText] logAll];
//}

- (RACSignal *)executeSearchSignal {
    return [[[self.services getFlickrSearchService]  flickrSearchSignal:self.searchText]
            doNext:^(id result) {
                RWTSearchResultsViewModel *resultsViewModel = [[RWTSearchResultsViewModel alloc] initWithSearchResults:result services:self.services];
                [self.services pushViewModel:resultsViewModel];
            }];
}

@end
