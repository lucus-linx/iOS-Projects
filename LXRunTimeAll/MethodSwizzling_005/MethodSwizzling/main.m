//
//  main.m
//  MethodSwizzling
//
//  Created by luz-lzz on 2017/8/22.
//  Copyright © 2017年 luz-lzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc.h>
#import <objc/runtime.h>

@interface Teacher : NSObject
+ (void)work;
- (void)work2;
@end

@implementation Teacher
+ (void)work{
    NSLog(@"work:I am a Teacher");
}
- (void)work2{
    NSLog(@"work2:I am a Teacher");
}
@end


//////////////////////////////////////////
@interface Teacher(RuntimeChange)
+(void)Runtimework;
-(void)Runtimework2;
@end

@implementation Teacher(RuntimeChange)
+(void)Runtimework{
    NSLog(@"Runtimework:I am a Student");
    [self Runtimework];
    
}
-(void)Runtimework2{
    NSLog(@"Runtimework2:I am a Student");
    [self Runtimework2];
    
}

+(void)load{
    NSString *className = NSStringFromClass(self.class);
    NSLog(@"classname = %@",className);
    
     //类的方法  类对象是元类的实力，这里获取元类对象的指针
//    Class class_obj = object_getClass(self);
//    SEL originaSelector = @selector(work);
//    SEL swizzleSelector = @selector(Runtimework);
    
    //实例方法  实例对象是类的实例，这里是获取类对象的指针
    Class class_obj = [self class];
    SEL originaSelector = @selector(work2);
    SEL swizzleSelector = @selector(Runtimework2);
    
    Method originaMethod = class_getInstanceMethod(class_obj, originaSelector);
    Method swizzleMethod = class_getInstanceMethod(class_obj, swizzleSelector);
    
    BOOL didAddMethod = class_addMethod(class_obj, originaSelector,
                                        method_getImplementation(swizzleMethod),
                                        method_getTypeEncoding(swizzleMethod));
    
    if(didAddMethod){
      class_replaceMethod(class_obj, swizzleSelector,
                          method_getImplementation(originaMethod),
                          method_getTypeEncoding(originaMethod));
    }else{
        method_exchangeImplementations(originaMethod, swizzleMethod);
    }
  
}

@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        //[Teacher work];
        
        Teacher* t = [[Teacher alloc]init];
        [t work2];
    }
    return 0;
}
