//
//  LXLogConfig.h
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LXLogConfig : NSObject

/**
 * the maximum count of logs which LXLog display. default value is `NSIntegerMax`.
 */
@property (nonatomic, assign) NSInteger logMaxCount;

+(instancetype)shared;

@end

