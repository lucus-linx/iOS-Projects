//
//  Person.m
//  001-RAC
//
//  Created by linxiang on 2017/4/18.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "Person.h"

@implementation Person

-(void)eat:(void (^)(NSString *))block {
    block(@"参数");
}
 
-(void(^)(int))run{
    return ^(int m) {
        NSLog(@"哥们起来了！！== %d",m);
    };
}

@end
