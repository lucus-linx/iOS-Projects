//
//  MNAssistiveBtn.m
//  LevitationButtonDemo
//
//  Created by 梁宇航 on 2018/3/8.
//  Copyright © 2018年 xmhccf. All rights reserved.
//

#import "MNAssistiveBtn.h"

#import <UIKit/UIKit.h>

#import "LXLog.h"




//#define screenW  [UIScreen mainScreen].bounds.size.width
//#define screenH  [UIScreen mainScreen].bounds.size.height

@interface MNAssistiveBtn() {
    dispatch_source_t _timer;
}
@end

@implementation MNAssistiveBtn{
    
    MNAssistiveTouchType  _type;
}

+ (instancetype)mn_touchWithFrame:(CGRect)frame{
    return [self mn_touchWithType:MNAssistiveTouchTypeNone
                            Frame:frame
                            title:nil
                       titleColor:nil
                        titleFont:nil
                  backgroundColor:[UIColor orangeColor]
                  backgroundImage:nil];
}


+ (instancetype)mn_touchWithType:(MNAssistiveTouchType)type
                           Frame:(CGRect)frame
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
                 backgroundColor:(UIColor *)backgroundColor
                 backgroundImage:(UIImage *)backgroundImage{
    
    return [[self alloc]initWithType:type
                               frame:frame
                               title:title
                          titleColor:titleColor
                           titleFont:titleFont
                     backgroundColor:backgroundColor
                     backgroundImage:backgroundImage];
}

- (instancetype)initWithType:(MNAssistiveTouchType)type
                       frame:(CGRect)frame
                       title:(NSString *)title
                  titleColor:(UIColor *)titleColor
                   titleFont:(UIFont *)titleFont
             backgroundColor:(UIColor *)backgroundColor
             backgroundImage:(UIImage *)backgroundImage{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        
        //UIbutton的换行显示
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.backgroundColor = backgroundColor;
        self.titleLabel.font = titleFont;
        [self setTitle:title forState:UIControlStateNormal];
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self setBackgroundColor:backgroundColor];
        
        //添加拖拽手势-改变控件的位置
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

+(instancetype)LX_initWithMoveType:(MNAssistiveTouchType)movetype
                          showType:(LXLogShowPFSAndMemoryType)showtype
                    widthAndHeight:(float)widthAndHeight
                   backgroundColor:(UIColor *)backgroundColor
                   backgroundImage:(UIImage *)backgroundImage {
    
    return [[self alloc]initWithMoveType:movetype
                                showType:showtype
                          widthAndHeight:widthAndHeight
                         backgroundColor:backgroundColor
                         backgroundImage:backgroundImage];
}

-(instancetype)initWithMoveType:(MNAssistiveTouchType)movetype
                       showType:(LXLogShowPFSAndMemoryType)showtype
                 widthAndHeight:(float)widthAndHeight
                backgroundColor:(UIColor *)backgroundColor
                backgroundImage:(UIImage *)backgroundImage {
    self = [super initWithFrame:CGRectMake(0, widthAndHeight, widthAndHeight, widthAndHeight)];
    if (!self) {
        return nil;
    }
    NSAssert(widthAndHeight > 0, @"按钮长宽必须大于0");    // 断言，防止传递参数
    
    _type = movetype;
    
    if (backgroundImage) {
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    
    if (backgroundColor) {
        UIColor * AlphaColor = [backgroundColor colorWithAlphaComponent:0.4];
        [self setBackgroundColor:AlphaColor];
    } else {
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    }

    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self addTarget:self action:@selector(callBack) forControlEvents:UIControlEventTouchUpInside];
    
    //添加拖拽手势-改变控件的位置
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
    [self addGestureRecognizer:pan];
 
    switch (showtype) {
        case LXLogShowPFSAndMemoryTypeNone:
        {
            // 计算高度
            float h = self.frame.size.width / 2 / 1.414;
            
            FPSLabel * label = [[FPSLabel alloc]init];
            label.frame = CGRectMake(self.frame.size.width/2 - h, self.frame.size.width/2 - h, h*2, h);
            [self addSubview:label];
            
            LXLogMemoryLabel * memlabel = [[LXLogMemoryLabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - h,  self.frame.size.height/2,  h*2, h)];
            [self addSubview:memlabel];
            
//            UILabel * memShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - h,  self.frame.size.height/2,  h*2, h)];
//            memShowLabel.text = @"0M";
//            memShowLabel.backgroundColor = [UIColor clearColor];
//            memShowLabel.adjustsFontSizeToFitWidth = YES;
//            memShowLabel.textColor = [UIColor blackColor];
//            memShowLabel.textAlignment = NSTextAlignmentCenter;
//            [self addSubview:memShowLabel];
//
//            // 获取全局队列
//            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//            // 创建定时器
//            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//            // 开始时间
////                dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));   // 3秒后
//            dispatch_time_t start = dispatch_walltime(NULL, 0);
//            // 重复间隔
//            uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
//            // 设置定时器
//            dispatch_source_set_timer(_timer, start, interval, 0);
//            // 设置需要执行的事件
//            dispatch_source_set_event_handler(_timer, ^{
//                //在这里执行事件
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    memShowLabel.text = [[LXLogMemoryHelper shared] appUsedMemoryAndFreeMemory];
//                });
//                /*
//                 // 关闭定时器
//                 dispatch_source_cancel(_timer);
//                 */
//            });
//            // 开启定时器
//            dispatch_resume(_timer);
        }

            break;
        case LXLogShowPFSAndMemoryTypeFPS:
        {
            FPSLabel * label = [[FPSLabel alloc]init];
            label.backgroundColor = [UIColor clearColor];
            label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            label.adjustsFontSizeToFitWidth = YES;
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
        }
            break;
        case LXLogShowPFSAndMemoryTypeMemory:
        {
            UILabel * memShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            memShowLabel.text = @"0M";
            memShowLabel.backgroundColor = [UIColor clearColor];
            memShowLabel.adjustsFontSizeToFitWidth = YES;
            memShowLabel.textColor = [UIColor blackColor];
            memShowLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:memShowLabel];
            
            // 获取全局队列
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            // 创建定时器
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            // 开始时间
            //                dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));   // 3秒后
            dispatch_time_t start = dispatch_walltime(NULL, 0);
            // 重复间隔
            uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
            // 设置定时器
            dispatch_source_set_timer(_timer, start, interval, 0);
            // 设置需要执行的事件
            dispatch_source_set_event_handler(_timer, ^{
                //在这里执行事件
                dispatch_async(dispatch_get_main_queue(), ^{
                    memShowLabel.text = [[LXLogMemoryHelper shared] appUsedMemoryAndFreeMemory];
                });
                /*
                 // 关闭定时器
                 dispatch_source_cancel(_timer);
                 */
            });
            // 开启定时器
            dispatch_resume(_timer);
        }
            break;
        default:
            break;
    }


    return self;
}


/**
 btn点击事件回掉
 */
-(void)callBack {
    if (self.btncallbackblock) {
        self.btncallbackblock();
    }
}

- (void)changePostion:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self];

    CGRect originalFrame = self.frame;
    switch (_type) {
        case MNAssistiveTouchTypeNone:
        {
            originalFrame = [self changeXWithFrame:originalFrame point:point];
            originalFrame = [self changeYWithFrame:originalFrame point:point];
            break;
        }case MNAssistiveTouchTypeVerticalScroll:{
            originalFrame = [self changeYWithFrame:originalFrame point:point];
            break;
        }
        case MNAssistiveTouchTypeHorizontalScroll:{
            originalFrame = [self changeXWithFrame:originalFrame point:point];
            break;
        }
    }

    self.frame = originalFrame;
    
    [pan setTranslation:CGPointZero inView:self];
    
    UIButton *button = (UIButton *)pan.view;
    if (pan.state == UIGestureRecognizerStateBegan) {
        button.enabled = NO;
    }else if (pan.state == UIGestureRecognizerStateChanged){
    } else {
        
/*****************原版操作，防止越界********************/
    /*
        CGRect frame = self.frame;
        
        //记录该button是否屏幕越界
        BOOL isOver = NO;
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
            isOver = YES;
            
        } else if (frame.origin.x + frame.size.width > screenW) {
            frame.origin.x = screenW - frame.size.width;
            isOver = YES;
        }

        if (frame.origin.y < 0) {
            frame.origin.y = 0;
            isOver = YES;
            
        } else if (frame.origin.y+frame.size.height > screenH) {
            frame.origin.y = screenH - frame.size.height;
            isOver = YES;
        }
        
        if (isOver) {
            //如果越界-跑回来
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = frame;
            }];
        }
        button.enabled = YES;
     */
/****************************************************/
        
/*============自定义操作，在任意拖动的情况下，自动移动到边上来============*/
        if (_type == MNAssistiveTouchTypeNone) {
            CGRect frame = self.frame;
            if (self.center.x <= screenW/2) {
                frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
            } else {
                frame = CGRectMake(screenW - frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
            }
            
            if (frame.origin.y < 20) {
                frame.origin.y = 20;
            } else if (frame.origin.y+frame.size.height > screenH) {
                frame.origin.y = screenH - frame.size.height;
            }
            
            //如果越界-跑回来
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = frame;
            }];
            button.enabled = YES;
            
        }else {
            CGRect frame = self.frame;
            
            //记录该button是否屏幕越界
            BOOL isOver = NO;
            if (frame.origin.x < 0) {
                frame.origin.x = 0;
                isOver = YES;
                
            } else if (frame.origin.x + frame.size.width > screenW) {
                frame.origin.x = screenW - frame.size.width;
                isOver = YES;
            }
            
            if (frame.origin.y < 0) {
                frame.origin.y = 0;
                isOver = YES;
                
            } else if (frame.origin.y+frame.size.height > screenH) {
                frame.origin.y = screenH - frame.size.height;
                isOver = YES;
            }
            
            if (isOver) {
                //如果越界-跑回来
                [UIView animateWithDuration:0.3 animations:^{
                    self.frame = frame;
                }];
            }
            button.enabled = YES;
        }
    }
}

//拖动改变控件的水平方向x值
- (CGRect)changeXWithFrame:(CGRect)originalFrame point:(CGPoint)point{
    BOOL q1 = originalFrame.origin.x >= 0;
    BOOL q2 = originalFrame.origin.x + originalFrame.size.width <= screenW;
    
    if (q1 && q2) {
        originalFrame.origin.x += point.x;
    }
    return originalFrame;
}

//拖动改变控件的竖直方向y值
- (CGRect)changeYWithFrame:(CGRect)originalFrame point:(CGPoint)point{
    
    BOOL q1 = originalFrame.origin.y >= 0;
    BOOL q2 = originalFrame.origin.y + originalFrame.size.height <= screenH;
    if (q1 && q2) {
        originalFrame.origin.y += point.y;
    }
    return originalFrame;
}

@end
