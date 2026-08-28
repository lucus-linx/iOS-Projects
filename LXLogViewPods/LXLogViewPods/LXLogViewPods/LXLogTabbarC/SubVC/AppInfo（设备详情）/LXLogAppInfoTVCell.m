//
//  LXLogAppInfoTVCell.m
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/10.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXLogAppInfoTVCell.h"

#import "LXLogMarco.h"

static NSString * reuseIdentifier = @"LXLogAppInfoTVCell_ID";

@interface LXLogAppInfoTVCell()

@end


@implementation LXLogAppInfoTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    LXLogAppInfoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[LXLogAppInfoTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
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
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"标题";
    _titleLabel.font = LXLogConsoleTableViewCell_DeFaultFont;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.text = @"细节";
    _detailLabel.font = LXLogConsoleTableViewCell_DeFaultFont;
    _detailLabel.textColor = [UIColor blackColor];
    _detailLabel.textAlignment = NSTextAlignmentRight;
    _detailLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_detailLabel];
    
    _titleLabel.frame = CGRectMake(20, 0, screenW/2, self.frame.size.height);
    _detailLabel.frame = CGRectMake(screenW/2 - 20, 0, screenW/2, self.frame.size.height);
}

//  自绘分割线 重写即可
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.3, rect.size.width, 0.3));
}


@end
