//
//  NSArray+LXLogChinese.m
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/11.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "NSArray+LXLogChinese.h"

@implementation NSArray (LXLogChinese)


-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    //遍历数组；
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [strM appendFormat:@"\t%@,\n",obj];
    }];
    [strM appendString:@")\n"];
    return strM;
}

@end
