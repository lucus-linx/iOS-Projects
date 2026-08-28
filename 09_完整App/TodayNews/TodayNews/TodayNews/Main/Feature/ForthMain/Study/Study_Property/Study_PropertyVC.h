//
//  Study_PropertyVC.h
//  TodayNews
//
//  Created by linxiang on 2018/7/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Study_PropertyVC : UIViewController

@property (nonatomic, copy, getter=show1 ,setter=show2:) NSString * myName;
// 重写setter getter
-(NSString *)show1;
-(void)show2:(NSString *)myname;


@property (copy, nonatomic) NSString *myTitle;
// 重写setter getter
-(NSString *)myTitle;
-(void)setMyTitle:(NSString *)myTitle;



@property (nonatomic, copy, readonly) NSString *firstName;
@property (nonatomic, copy, readonly) NSString *lastName;

// 初始化
-(id)initWithFirstName:(NSString *)firstName
                lastName:(NSString *)lastName;



@end
