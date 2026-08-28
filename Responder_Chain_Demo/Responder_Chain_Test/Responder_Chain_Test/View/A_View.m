//
//  A_View.m
//  Responder_Chain_Test
//
//  Created by linxiang on 2017/12/22.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "A_View.h"

@implementation A_View

-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

//touchesBegan 要删除，不然会拦截事件，导致响应中断
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%s",__func__);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
