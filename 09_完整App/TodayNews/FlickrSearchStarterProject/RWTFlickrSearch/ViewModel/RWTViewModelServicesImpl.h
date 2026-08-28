//
//  RWTViewModelServicesImpl.h
//  RWTFlickrSearch
//
//  Created by linxiang on 2019/3/15.
//  Copyright © 2019年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RWTViewModelServices.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWTViewModelServicesImpl : NSObject <RWTViewModelServices>

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end

NS_ASSUME_NONNULL_END
