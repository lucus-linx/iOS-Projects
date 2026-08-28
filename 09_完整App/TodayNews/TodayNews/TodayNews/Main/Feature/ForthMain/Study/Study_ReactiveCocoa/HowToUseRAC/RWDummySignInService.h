//
//  RWDummySignInService.h
//  TodayNews
//
//  Created by linxiang on 2019/3/12.
//  Copyright © 2019年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^RWSignInResponse)(BOOL);

@interface RWDummySignInService : NSObject

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock;

@end

NS_ASSUME_NONNULL_END
