//
//  ViewController.m
//  Class_isa
//
//  Created by linxiang on 2017/9/7.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ViewController.h"

#import "Father.h"

#import "Son.h"

#import <objc/runtime.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    
    Son *son = [Son new];
    
    Class class = object_getClass(son);
    
    do {
        // class isa
        Class isaClass = object_getClass(class);
        // class 元类
        id metaClass = objc_getMetaClass(object_getClassName(class));
        // class 父类
        Class superClass = class_getSuperclass(class);
        
        NSLog(@"Class %@->isa=%@(%p); superClass=%@(%p); metaclass=%@(%p)\n\n", class, isaClass, isaClass, superClass ?: @"nil",superClass, metaClass, metaClass);
    
        
        Class metaClassSuper = class_getSuperclass(metaClass);
        
        id metaClassIsa = object_getClass(metaClass);
        
        NSLog(@"metaclass %@(%p)->isa=%@(%p); superClass=%@(%p)\n",metaClass, metaClass, metaClassIsa, metaClassIsa, metaClassSuper, metaClassSuper);
        
        NSLog(@"-------------------------------------\n");
        
        class = superClass;
        
        
    } while (class);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
