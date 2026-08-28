//
//  NSDictionary+LXLogChese.m
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/11.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "NSDictionary+LXLogChese.h"

@implementation NSDictionary (LXLogChese)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSArray *allKeys = [self allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
    for (NSString *key in allKeys) {
        id value= self[key];
        [str appendFormat:@"\t \"%@\" = %@,\n",key, value];
    }
    [str appendString:@"}"];
    
    return str;
}

@end
