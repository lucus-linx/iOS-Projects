//
//  Study_MVC_User_Cell.m
//  TodayNews
//
//  Created by linxiang on 2018/7/23.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_MVC_User_Cell.h"

#import "Study_MVC_User.h"

static NSString * const reuseIdentifier = @"Study_MVC_User_Cell_ID";


@implementation Study_MVC_User_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



//+ (instancetype)cellWithTableView:(UITableView *)tableView{
//
//    Study_MVC_User_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
//
//    if (cell == nil) {
//        cell = [[Study_MVC_User_Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
//    }
//    return cell;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // 设置背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        [self CreateUI];
    }
    return self;
}

-(void)CreateUI {
    
    self.TitleLabel = [[UILabel alloc]init];
    self.TitleLabel.text = @"AAA";
    self.TitleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.TitleLabel];
    
    self.DateLabel = [[UILabel alloc]init];
    self.DateLabel.text = @"2012.12.20";
    self.DateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.DateLabel];
    
    UIButton * btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"AA" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(CenterBtnCallBack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    
    [self.TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
    }];
    
    [self.DateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.and.bottom.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.top.and.bottom.equalTo(self);
        make.centerX.equalTo(self.mas_centerX);
    }];
}



/**
 给cell赋值
 
 @param model 对象
 */
-(void)setModel:(Study_MVC_User *)model {
    
    _model = model;
    
    self.DateLabel.textColor = LXRandomColor;
    
    self.TitleLabel.text = model.title;
    self.DateLabel.text = model.date;
}



#pragma mark - Delegate Method
/**
 按钮点击事件，通过delegate传递出去
 */
-(void)CenterBtnCallBack {
    
    if ([self.delegate respondsToSelector:@selector(CenterBtn_CellDelegate:)]) {
        [self.delegate CenterBtn_CellDelegate:self];
    }
}


@end
