//
//  KFC.m
//  RAC_GatherClass
//
//  Created by linxiang on 2017/4/25.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "KFC.h"

@implementation KFC

+(instancetype)kfcWithDict:(NSDictionary *)dic {
    KFC * kfc = [[KFC alloc]init];
    
    //如果键值对出错，就报错
    [kfc setValuesForKeysWithDictionary:dic];
    
    return kfc;
}

@end
