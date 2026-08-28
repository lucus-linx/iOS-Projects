//
//  LXLogConsoleTVCell.m
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/10.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXLogConsoleTVCell.h"

#import "LXLogMarco.h"

#import <Masonry/Masonry.h>  // 布局依赖下Masonry

static NSString * reuseIdentifier = @"LXLogConsoleTVCell_ID";

@interface LXLogConsoleTVCell (){
    UILabel * timeLabel;
    UILabel * threadLabel;
    UILabel * detailLabel;
    UILabel * contentLabel;
    
    UILabel * fengeLable_1;
    UILabel * fengeLable_2;
    UILabel * fengeLable_3;
}
@end

@implementation LXLogConsoleTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    LXLogConsoleTVCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[LXLogConsoleTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //创建UI
        [self CreateUI];
    }
    return self;
}

-(void)CreateUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    // timelabel 设置
    timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"20154523652";
    timeLabel.font = LXLogConsoleTableViewCell_DeFaultFont;
    timeLabel.numberOfLines = 0;   //多行
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:timeLabel];
    
    threadLabel = [[UILabel alloc]init];
    threadLabel.text = @"threadLabel";
    threadLabel.font = LXLogConsoleTableViewCell_DeFaultFont;
    threadLabel.adjustsFontSizeToFitWidth = YES;
    threadLabel.textColor = [UIColor whiteColor];
    threadLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:threadLabel];
    
    detailLabel = [[UILabel alloc]init];
    detailLabel.text = @"detailLabel";
    detailLabel.font = LXLogConsoleTableViewCell_DeFaultFont;
    detailLabel.adjustsFontSizeToFitWidth = YES;    // 自适应缩小
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:detailLabel];
    
    contentLabel = [[UILabel alloc]init];
    contentLabel.text = @"contentLabel";
    contentLabel.font = LXLogConsoleTableViewCell_DeFaultFont;
    contentLabel.numberOfLines = 0;   //多行
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:contentLabel];
    
    fengeLable_1 = [[UILabel alloc]init];
    fengeLable_1.text = @"-------------------------------------------------------------------------------------------------------------------------------";
    fengeLable_1.lineBreakMode = NSLineBreakByWordWrapping;
    fengeLable_1.backgroundColor = [UIColor clearColor];
    fengeLable_1.textColor = [UIColor whiteColor];
    [self addSubview:fengeLable_1];
    
    
    fengeLable_2 = [[UILabel alloc]init];
    fengeLable_2.text = @"-------------------------------------------------------------------------------------------------------------------------------";
    fengeLable_2.lineBreakMode = NSLineBreakByWordWrapping;
    fengeLable_2.backgroundColor = [UIColor clearColor];
    fengeLable_2.textColor = [UIColor whiteColor];
    [self addSubview:fengeLable_2];
    
    
    fengeLable_3 = [[UILabel alloc]init];
    fengeLable_3.text = @"==============================================================================================================";
    fengeLable_3.lineBreakMode = NSLineBreakByWordWrapping;
    fengeLable_3.backgroundColor = [UIColor clearColor];
    fengeLable_3.textColor = [UIColor whiteColor];
    [self addSubview:fengeLable_3];
    
    
    // 设置背景色
    timeLabel.backgroundColor = [UIColor redColor];
    threadLabel.backgroundColor = [UIColor blueColor];
    detailLabel.backgroundColor = [UIColor blackColor];
    contentLabel.backgroundColor = [UIColor orangeColor];
    
    fengeLable_1.backgroundColor = [UIColor purpleColor];
    fengeLable_2.backgroundColor = [UIColor purpleColor];
    fengeLable_3.backgroundColor = [UIColor purpleColor];

    
// ================ Masonry ================
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.bottom.equalTo(self).offset(-20);
        make.width.equalTo(self.mas_width).dividedBy(5);
    }];
    
    [threadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right);
        make.top.and.right.equalTo(self);
        make.height.equalTo(@25);
    }];
    
    [fengeLable_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right);
        make.top.equalTo(threadLabel.mas_bottom);
        make.right.equalTo(self);
        make.height.equalTo(@10);
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right);
        make.top.equalTo(fengeLable_1.mas_bottom);
        make.right.equalTo(self);
        make.height.equalTo(@25);
    }];
    
    [fengeLable_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right);
        make.top.equalTo(detailLabel.mas_bottom);
        make.right.equalTo(self);
        make.height.equalTo(@10);
    }];
    
    [fengeLable_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.equalTo(self);
        make.height.equalTo(@20);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right);
        make.top.equalTo(fengeLable_2.mas_bottom);
        make.right.equalTo(self);
        make.bottom.equalTo(fengeLable_3.mas_top);
    }];
}


-(void)setModel:(LXLogModel *)model {
    timeLabel.text = model.Date;
    
    threadLabel.text = model.Thread;
    
    detailLabel.text = model.FileInfo;
  
    contentLabel.text = model.Content;
}

//
//// 重绘
//- (void)drawRect:(CGRect)rect {
//
//    float samllW = screenW/5;
//    float bigW = screenW/5*4;
//
//    // timelable / detailLabel 高度
//    float h_1 = 25;
//    // fenge_1 / 2 高度
//    float h_2 = 10;
//    // fengge_3 高度
//    float h_3 = 20;
//
//    timeLabel.frame = CGRectMake(0, 0, samllW, rect.size.height - h_3);
//
//    threadLabel.frame = CGRectMake(samllW, 0, bigW, h_1);
//
//    fengeLable_1.frame = CGRectMake(samllW, h_1, bigW, h_2);
//
//    detailLabel.frame = CGRectMake(samllW, h_1 + h_2, bigW, h_1);
//
//    fengeLable_2.frame = CGRectMake(samllW, h_1 + h_2 + h_1, bigW, h_2);
//
//    contentLabel.frame = CGRectMake(samllW, h_1 + h_2 + h_1 + h_2, bigW, rect.size.height - (h_1 + h_2 + h_1 + h_2 + h_3));
//
//    fengeLable_3.frame = CGRectMake(0, rect.size.height - h_3, rect.size.width, h_3);
//}



@end
