//
//  UIImage+LXGif.h
//  TodayNews
//
//  Created by linxiang on 2018/2/28.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LXGif)

+ (UIImage *)lx_animatedGIFNamed:(NSString *)name;

+ (UIImage *)lx_animatedGIFWithData:(NSData *)data;

- (UIImage *)lx_animatedImageByScalingAndCroppingToSize:(CGSize)size;


@end
