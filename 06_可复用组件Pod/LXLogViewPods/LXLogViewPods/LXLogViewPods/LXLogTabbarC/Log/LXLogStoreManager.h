//
//  LXLogStoreManager.h
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LXLogModel.h"
#import "LXLogConfig.h"

@interface LXLogStoreManager : NSObject


/**
 * default LXLog Store Array
 */
@property (nonatomic, strong) NSMutableArray * defaultLogArr;

/**
 *  Cache Config object - storing all kind of settings
 */
@property (nonatomic, strong ,readonly) LXLogConfig *config;

/**
 singleton

 @return LXLogStoreManager
 */
+(instancetype)shared;


/**
 新增
 */
-(void)addLXLog:(LXLogModel *)model;
/**
 移除
 */
-(void)removeLXLog:(LXLogModel *)model;
/**
 重置
 */
-(void)resetLXLogs;




@end
