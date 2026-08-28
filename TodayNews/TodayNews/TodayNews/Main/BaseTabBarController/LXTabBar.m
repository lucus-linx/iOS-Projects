//
//  LXTabBar.m
//  TodayNews
//
//  Created by linxiang on 2018/2/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXTabBar.h"

#import "NSObject+PYThemeExtension.h"



@implementation LXTabBar

- (instancetype)init{
    if (self = [super init]){
        [self initView];
    }
    return self;
}

- (void)initView{
    
// 中间按钮 -- 方法一：直接通过图片来设置，不可以进行主题颜色切换
/*
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //  设定button大小为适应图片
    UIImage *normalImage = [UIImage imageNamed:@"tabbar_add"];  //tabbar_add  tab_publish_nor
    [_centerBtn setImage:normalImage forState:UIControlStateNormal];
    [_centerBtn setBackgroundColor:[UIColor clearColor]];
    //去除选择时高亮
    _centerBtn.adjustsImageWhenHighlighted = NO;
    //根据图片调整button的位置(图片中心在tabbar的中间最上部，这个时候由于按钮是有一部分超出tabbar的，所以点击无效，要进行处理)
    _centerBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - normalImage.size.width)/2.0, - normalImage.size.height/2.0, normalImage.size.width, normalImage.size.height);
    [self addSubview:_centerBtn];
 */
    
// 中间按钮 -- 方法二：便于进行主题颜色设置
    UIImage *normalImage = [UIImage imageNamed:@"tab_publish_nor"];  //tabbar_add  tab_publish_nor
    _centerBtn = [[LXCircleButton alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - normalImage.size.width)/2.0, - normalImage.size.height/2.0, normalImage.size.width, normalImage.size.height)];
    [_centerBtn setBackgroundColor:[UIColor whiteColor]];
    _centerBtn.layer.borderWidth = 6;
    _centerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    //去除选择时高亮
    _centerBtn.adjustsImageWhenHighlighted = NO;
    // UIImageRenderingModeAlwaysTemplate - 始终根据Tint Color绘制图片，忽略图片的颜色信息。
    [_centerBtn setImage:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

    [self addSubview:_centerBtn];
    
    
    // 设置主题需要的操作
    [self py_addToThemeColorPool:@"tintColor"];
}

//处理超出区域点击无效的问题
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    // 方法一：此处仅仅检测超出范围按钮的点击事件的截取
    /*
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil){
        //转换坐标
        CGPoint tempPoint = [self.centerBtn convertPoint:point fromView:self];
        //判断点击的点是否在按钮区域内
        if (CGRectContainsPoint(self.centerBtn.bounds, tempPoint)){
            //返回按钮
            return _centerBtn;
        }
    }
    return view;
     */
    
    // 方法二：此处是对整个按钮点击事件的截取
    if (self.isHidden == NO) {
        
        CGPoint newPoint = [self convertPoint:point toView:self.centerBtn];
        
        if ( [self.centerBtn pointInside:newPoint withEvent:event]) {
            return self.centerBtn;
        }else{
            
            return [super hitTest:point withEvent:event];
        }
    } else {
        return [super hitTest:point withEvent:event];
    }
}


@end
