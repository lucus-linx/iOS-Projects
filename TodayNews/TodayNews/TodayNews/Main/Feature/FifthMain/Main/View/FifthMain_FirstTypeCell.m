//
//  FifthMain_FirstTypeCell.m
//  TodayNews
//
//  Created by linxiang on 2018/3/2.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "FifthMain_FirstTypeCell.h"

#import "UIButton+ImageTitleSpacing.h"

static NSString * reuseIdentifier = @"FifthMain_FirstTypeCell_ID";

@interface FifthMain_FirstTypeCell()

@property (nonatomic, strong) UIButton * LevelBtn_1;  // 优
@property (nonatomic, strong) UIButton * LevelBtn_2;  // 良
@property (nonatomic, strong) UIButton * LevelBtn_3;  // 中

@end

@implementation FifthMain_FirstTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
    if (selected) {

    }else{

    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    FifthMain_FirstTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[FifthMain_FirstTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // 设置背景颜色
        self.backgroundColor = LXRGBColor(233, 232, 233);
    }
    return self;
}


-(void)setParameterDic:(NSDictionary *)parameterDic {
    
    NSMutableArray * norImageArr = parameterDic[@"nor"];
    
    NSMutableArray * highImageArr = parameterDic[@"high"];
                                     
    NSMutableArray * titleArr = parameterDic[@"title"];
    
    if (norImageArr.count != highImageArr.count || norImageArr.count != titleArr.count ) {
        [SVProgressHUD showError:@"cell按钮数据异常"];
        return;
    }
    
    NSInteger num = norImageArr.count;
    
    CGFloat w = SCREEN_WIDTH/num;
    
    for (int i = 0; i < num; i++) {
        UIButton * btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(w*i, 0, w, 70);
        // title进行设置
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // image设置
        [btn setImage:[UIImage imageNamed:norImageArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:highImageArr[i]] forState:UIControlStateHighlighted];
        // title位置便宜
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
        
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(BtnCallBack:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }

}

/**
 按钮点击事件，传递出去
 
 @param sender btn
 */
-(void)BtnCallBack:(id)sender {
    UIButton * btn = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(FifthMain_FirstTypeCellDelegate:WithButton:)]) {
        [self.delegate FifthMain_FirstTypeCellDelegate:self WithButton:btn];
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
