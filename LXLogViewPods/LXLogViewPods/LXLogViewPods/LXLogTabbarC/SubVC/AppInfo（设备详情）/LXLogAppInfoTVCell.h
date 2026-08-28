//
//  LXLogAppInfoTVCell.h
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/10.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXLogAppInfoTVCell : UITableViewCell

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UILabel * detailLabel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
