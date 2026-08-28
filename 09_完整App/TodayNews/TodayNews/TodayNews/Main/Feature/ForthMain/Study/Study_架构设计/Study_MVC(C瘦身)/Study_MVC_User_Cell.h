//
//  Study_MVC_User_Cell.h
//  TodayNews
//
//  Created by linxiang on 2018/7/23.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Study_MVC_User;
@class Study_MVC_User_Cell;

/**
 代理
 */
@protocol Study_MVC_User_CellDelegate <NSObject>

/**
 cell 左侧 按钮 代理方法
 
 @param cell self
 */
- (void)CenterBtn_CellDelegate:(Study_MVC_User_Cell *)cell;


@end




@interface Study_MVC_User_Cell : UITableViewCell

@property (nonatomic, strong) UILabel *TitleLabel;
@property (nonatomic, strong) UILabel *DateLabel;

/**
 cell的数据模型
 */
@property (nonatomic, strong) Study_MVC_User * model;

/**
 添加代理
 */
@property (nonatomic, strong) id<Study_MVC_User_CellDelegate> delegate;

/**
 init cell
 */
//+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
