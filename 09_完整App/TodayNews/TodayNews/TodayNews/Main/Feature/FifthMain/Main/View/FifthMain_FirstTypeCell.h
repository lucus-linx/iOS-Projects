//
//  FifthMain_FirstTypeCell.h
//  TodayNews
//
//  Created by linxiang on 2018/3/2.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FifthMain_FirstTypeCell;
/**
 代理
 */
@protocol FifthMain_FirstTypeCellDelegate <NSObject>

/**
 *  cell关于按钮的代理方法
 *
 *  @param cell    cell
 *  @param Btn cell 是否
 */
- (void)FifthMain_FirstTypeCellDelegate:(FifthMain_FirstTypeCell *)cell WithButton:(UIButton *)Btn;

@end


@interface FifthMain_FirstTypeCell : UITableViewCell


/**
 这里的参数是指 默认图片、点击图片、下方文字
 */
@property (nonatomic, strong) NSDictionary * parameterDic;

/**
 添加代理
 */
@property (nonatomic, strong) id<FifthMain_FirstTypeCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
