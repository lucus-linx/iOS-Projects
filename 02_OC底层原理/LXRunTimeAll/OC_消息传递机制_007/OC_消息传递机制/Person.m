//
//  Person.m
//  OC_消息传递机制
//
//  Created by linxiang on 2017/9/7.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "Person.h"

#import <objc/runtime.h>

#import "Person_1.h"

@implementation Person

-(void)A {
    NSLog(@"A");
}

void dynamicMethodIMP(id self, SEL _cmd) {
    
    // implementation ....
    NSLog(@"dynamicMethodIMP");
}

void AAAA() {
    NSLog(@"AAAA");
}

+(BOOL)resolveInstanceMethod:(SEL)sel {
    
//    if (sel == @selector(resolveThisMethodDynamically)) {
//        
//        class_addMethod([self class], sel, (IMP) dynamicMethodIMP, "v@:");
//        
//        return YES;
//        
//    }
//    
//    return [super resolveInstanceMethod:sel];

    return NO;
    
}


//Message Forwarding(消息转发)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    
    Person_1 * per = [Person_1 new];
    
    if (!signature) {
        
        signature = [per methodSignatureForSelector:selector];
        
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation

{
    Person_1 * per = [Person_1 new];
    
    if ([per respondsToSelector:
         
         [anInvocation selector]])
        
        [anInvocation invokeWithTarget:per];
    
    else
        
        [super forwardInvocation:anInvocation];
    
}    



@end
