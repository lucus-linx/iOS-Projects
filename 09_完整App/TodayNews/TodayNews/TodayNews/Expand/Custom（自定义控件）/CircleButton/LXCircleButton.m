//
//  LXCircleButton.m
//  TodayNews
//
//  Created by linxiang on 2018/2/24.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXCircleButton.h"

@implementation LXCircleButton

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化
        [self CreateBtn:frame];
    }
    return self;
}

-(void)CreateBtn:(CGRect)frame {
    // 设置圆角
    self.layer.cornerRadius = self.frame.size.width/2.0;
    
    /*
     UIView的clipsToBounds和CALayer的masksToBounds的区别?
     - clipsToBounds：是指视图上的子视图,如果超出父视图的部分就截取掉,
     - masksToBounds：是指视图的图层上的子图层,如果超出父图层的部分就截取掉
     */
    self.layer.masksToBounds = YES;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    //首先调用父类的方法确定点击的区域确实在按钮的区域中
    BOOL res = [super pointInside:point withEvent:event];
    if (res) {
        //绘制一个圆形path
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
        if ([path containsPoint:point]) {
            //如果在path区域内，返回YES
            return YES;
        }
        return NO;
    }
    return NO;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
