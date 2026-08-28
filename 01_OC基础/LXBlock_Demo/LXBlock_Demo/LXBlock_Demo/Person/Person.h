//
//  Person.h
//  001-RAC
//
//  Created by linxiang on 2017/4/18.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Person : NSObject


/**
 block : ARC使用strong  非ARC使用copy
 */
@property (nonatomic, strong) void(^block)();

-(void)eat:(void(^)(NSString *))block;

-(void(^)(int))run;

@end
