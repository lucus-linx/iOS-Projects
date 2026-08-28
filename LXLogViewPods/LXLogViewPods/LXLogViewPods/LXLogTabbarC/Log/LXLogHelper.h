//
//  LXLogHelper.h
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXLogHelper : NSObject

+(void)handleLog:(NSString *)file :(NSString *)function :(NSString *)line :(NSString *)format, ...;

@end
