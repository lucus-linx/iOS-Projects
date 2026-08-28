//
//  LXLaunchGuideView.h
//  LXLaunchGuidePods
//
//  Created by linxiang on 2017/4/13.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXLaunchGuideView : UIView

/**
 是否支持滑动进入主页面
 */
@property (nonatomic, assign)BOOL isSlideEnter;

/**
 创建界面

 @param frame 界面大小
 @param imageNameArray 资源名称数组  //格式限制：png、jpg、gif
 @param isHideBtn 是否显示最后一页的进入按钮
 @return LXLaunchGuideView对象
 */
- (instancetype)my_initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray isHideBtn:(BOOL)isHideBtn;

//注：NSArray<NSString *> *)   这是Xcode7加入，表示数组里面存的是NSString类型的元素。

@end
