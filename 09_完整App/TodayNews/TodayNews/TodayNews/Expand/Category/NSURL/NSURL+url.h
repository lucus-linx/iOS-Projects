//
//  NSURL+url.h
//  PAL-iOS
//
//  Created by linxiang on 2017/12/21.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    此Category是为了解决"urlstr"中含有中文或者空格符等特殊字符，从而导致"URL"为nil的情况
        NSURL * URL = [NSURL URLWithString:urlstr];
 */
@interface NSURL (url)

@end
