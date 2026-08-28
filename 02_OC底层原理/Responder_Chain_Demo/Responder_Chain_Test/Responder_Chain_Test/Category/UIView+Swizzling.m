//
//  UIView+Swizzling.m
//  Responder_Chain_Test
//
//  Created by linxiang on 2017/12/22.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "UIView+Swizzling.h"

//runtime
#import <objc/runtime.h>

@implementation UIView (Swizzling)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        SEL oriSEL = @selector(hitTest:withEvent:);
        SEL swiSEL = @selector(wcq_hitTest:withEvent:);

        Method oriMethod = class_getInstanceMethod(class, oriSEL);
        Method swiMethod = class_getInstanceMethod(class, swiSEL);

        BOOL didAddMethod = class_addMethod(class, oriSEL,
                                            method_getImplementation(swiMethod),
                                            method_getTypeEncoding(swiMethod));

        if (didAddMethod) {

            class_replaceMethod(class,
                                swiSEL,
                                method_getImplementation(oriMethod),
                                method_getTypeEncoding(oriMethod));
        }else {

            method_exchangeImplementations(oriMethod, swiMethod);
        }
        
        
        
        
        SEL oriSEL_1 = @selector(touchesBegan:withEvent:);
        SEL swiSEL_1 = @selector(wcq_touchesBegan:withEvent:);
        
        Method oriMethod_1 = class_getInstanceMethod(class, oriSEL_1);
        Method swiMethod_1 = class_getInstanceMethod(class, swiSEL_1);
        
        BOOL didAddMethod_1 = class_addMethod(class, oriSEL_1,
                                            method_getImplementation(swiMethod_1),
                                            method_getTypeEncoding(swiMethod_1));
        
        if (didAddMethod_1) {
            
            class_replaceMethod(class,
                                swiSEL_1,
                                method_getImplementation(oriMethod_1),
                                method_getTypeEncoding(oriMethod_1));
        }else {
            
            method_exchangeImplementations(oriMethod_1, swiMethod_1);
        }
        
        
        
    });
}

- (UIView *)wcq_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    NSLog(@"%@ %s",[self class], __PRETTY_FUNCTION__);
    return [self wcq_hitTest:point withEvent:event];
}

- (void)wcq_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%@ %s",[self class], __PRETTY_FUNCTION__);
    [super touchesBegan:touches withEvent:event];
}


/*
作者：KeepMoveingOn
鏈接：https://www.jianshu.com/p/eacb86714799
來源：簡書
著作權歸作者所有。商業轉載請聯繫作者獲得授權，非商業轉載請註明出處。
*/

@end
