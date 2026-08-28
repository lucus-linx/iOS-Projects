//
//  KFC.h
//  RAC_GatherClass
//
//  Created by linxiang on 2017/4/25.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFC : NSObject

@property (nonatomic, strong) NSString * name;

@property (nonatomic, strong) NSString * icon;

+(instancetype)kfcWithDict:(NSDictionary *)dic;

@end
