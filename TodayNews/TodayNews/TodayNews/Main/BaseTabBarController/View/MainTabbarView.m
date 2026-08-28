//
//  MainTabbarView.m
//  TodayNews
//
//  Created by linxiang on 2018/2/11.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "MainTabbarView.h"

@implementation MainTabbarView

-(instancetype)init {
    self = [super init];
    if (self) {
        [self CreateView];
    }
    return self;
}


-(void)CreateView {
    [self setBackgroundColor:[[UIColor grayColor]colorWithAlphaComponent:0.5]];
    
    UIButton * oneBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [oneBtn addTarget:self action:@selector(oneBtnCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [oneBtn setBackgroundColor:[UIColor greenColor]];
    oneBtn.tag = 10001;
    [self addSubview:oneBtn];
    
}

-(void)oneBtnCallBack:(id)sender {
    LXLog(@"");
    
    UIButton * btn = (UIButton *)sender;
    
    //当代理响应sendValue方法时，把_tx.text中的值传到VCA
    if ([_delegate respondsToSelector:@selector(TouchEvent:)]) {
        [_delegate TouchEvent:btn.tag];
    }
}





-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //当代理响应sendValue方法时，把_tx.text中的值传到VCA
    if ([_delegate respondsToSelector:@selector(TouchEvent:)]) {
        [_delegate TouchEvent:10000];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
