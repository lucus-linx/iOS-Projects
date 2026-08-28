//
//  NSString+LXLogStringSize.m
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/14.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "NSString+LXLogStringSize.h"

@implementation NSString (LXLogStringSize)

- (CGSize)sizeWithLabelWidth:(CGFloat)width font:(UIFont *)font{
    NSDictionary *dict=@{NSFontAttributeName : font};
    CGRect rect=[self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dict context:nil];
    CGFloat sizeWidth=ceilf(CGRectGetWidth(rect));
    CGFloat sizeHieght=ceilf(CGRectGetHeight(rect));
    return CGSizeMake(sizeWidth, sizeHieght);
}

@end
