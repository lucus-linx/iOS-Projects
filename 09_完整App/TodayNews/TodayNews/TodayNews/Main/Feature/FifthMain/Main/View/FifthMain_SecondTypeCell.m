//
//  FifthMain_SecondTypeCell.m
//  TodayNews
//
//  Created by linxiang on 2018/3/2.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "FifthMain_SecondTypeCell.h"

static NSString * reuseIdentifier = @"FifthMain_SecondTypeCell_ID";

@implementation FifthMain_SecondTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    FifthMain_SecondTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[FifthMain_SecondTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

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
    
    self.mySwitch = [[UISwitch alloc]init];
    [self addSubview:self.mySwitch];
    
    //缩小或者放大switch的size
//    self.mySwitch.transform = CGAffineTransformMakeScale(0.5, 0.5);
//    self.mySwitch.layer.anchorPoint = CGPointMake(0, 0.3);
    
    // 设置开关状态(默认是 关)
//    [self.mySwitch setOn:YES animated:true];  //animated

    //判断开关的状态
    if (self.mySwitch.on) {
        NSLog(@"switch is on");
    } else {
        NSLog(@"switch is off");
    }
    
    //添加事件监听
    [self.mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
/*
    //定制开关颜色UI
    //tintColor 关状态下的背景颜色
    self.mySwitch.tintColor = [UIColor redColor];
    //onTintColor 开状态下的背景颜色
    self.mySwitch.onTintColor = [UIColor yellowColor];
    //thumbTintColor 滑块的背景颜色
    self.mySwitch.thumbTintColor = [UIColor blueColor];
 */
 
    [self.mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
//        make.width.equalTo(@100);   //默认大小
//        make.height.equalTo(@40);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
}

-(void)switchAction:(id)sender {
    UISwitch * switchbtn = (UISwitch *)sender;
    if ([self.delegate respondsToSelector:@selector(FifthMain_SecondTypeCellDelegate:WithSwitch:)]) {
        [self.delegate FifthMain_SecondTypeCellDelegate:self WithSwitch:switchbtn];
    }
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
