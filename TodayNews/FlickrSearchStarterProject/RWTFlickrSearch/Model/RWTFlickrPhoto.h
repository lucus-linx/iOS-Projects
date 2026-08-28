//
//  RWTFlickrPhoto.h
//  RWTFlickrSearch
//
//  Created by linxiang on 2019/3/15.
//  Copyright © 2019年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWTFlickrPhoto : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSString *identifier;

@end

NS_ASSUME_NONNULL_END
