//
//  MainTabbarView.h
//  TodayNews
//
//  Created by linxiang on 2018/2/11.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainTabbarViewDelegate <NSObject>
- (void)TouchEvent:(NSInteger)index;
@end

@interface MainTabbarView : UIView

@property(nonatomic, weak) id<MainTabbarViewDelegate> delegate;

-(instancetype)init;

@end
