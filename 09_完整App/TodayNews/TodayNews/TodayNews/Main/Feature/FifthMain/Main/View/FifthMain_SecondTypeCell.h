//
//  FifthMain_SecondTypeCell.h
//  TodayNews
//
//  Created by linxiang on 2018/3/2.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FifthMain_SecondTypeCell;
/**
 代理
 */
@protocol FifthMain_SecondTypeCellDelegate <NSObject>

/**
 *  cell关于按钮的代理方法
 *
 *  @param cell    cell
 *  @param Switch cell 是否
 */
- (void)FifthMain_SecondTypeCellDelegate:(FifthMain_SecondTypeCell *)cell WithSwitch:(UISwitch *)Switch;

@end



@interface FifthMain_SecondTypeCell : UITableViewCell

/**
 添加代理
 */
@property (nonatomic, strong) id<FifthMain_SecondTypeCellDelegate> delegate;

@property (nonatomic, strong) UISwitch * mySwitch;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
