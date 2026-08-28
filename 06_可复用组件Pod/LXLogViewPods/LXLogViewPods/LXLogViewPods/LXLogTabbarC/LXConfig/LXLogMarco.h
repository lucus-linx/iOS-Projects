//
//  LXLogMarco.h
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/10.
//  Copyright © 2018年 LX. All rights reserved.
//

#ifndef LXLogMarco_h
#define LXLogMarco_h

#import "LXLogHelper.h"


#ifdef DEBUG
// 这里执行的是debug模式下
#define LXLog(fmt ,...) [LXLogHelper handleLog:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] :NSStringFromSelector(_cmd) :[NSString stringWithFormat:@"%d",__LINE__] :(fmt), ##__VA_ARGS__]; \
{\
NSLog((@"%s [line: %d] " fmt) ,__FUNCTION__ ,__LINE__, ##__VA_ARGS__);\
}

#else
// 这里执行的是release模式下
#define LXLog(fmt,...) nil
#endif



// 屏幕宽度
#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height

#define LXLogConsoleTableViewCell_DeFaultFont [UIFont fontWithName:@"Arial" size:20]


#endif /* LXLogMarco_h */
