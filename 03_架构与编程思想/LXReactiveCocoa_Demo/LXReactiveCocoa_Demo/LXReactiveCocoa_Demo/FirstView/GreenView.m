//
//  GreenView.m
//  LXReactiveCocoa_Demo
//
//  Created by linxiang on 2017/5/4.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "GreenView.h"

@implementation GreenView

-(IBAction)btnOnclick:(id)sender {
    NSLog(@"%s",__func__);
    
    [self PassValue:@"AAAVVV" :@"VVVVV"];

}

-(void)PassValue:(NSString *)str :(NSString *)VVV{
//    NSLog(@"需要传值");
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
