//
//  FourMainComponent.m
//  TodayNews
//
//  Created by linxiang on 2018/2/8.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "FourMainComponent.h"

#import "FirstViewController.h"
#import "SecondViewController.h"

@implementation FourMainComponent

+ (UIViewController *)FirstViewController {
    FirstViewController *controller = [[FirstViewController alloc] init];
    return controller;
}

+ (UIViewController *)SecondViewController {
    SecondViewController *controller = [[SecondViewController alloc] init];
    return controller;
}

@end
