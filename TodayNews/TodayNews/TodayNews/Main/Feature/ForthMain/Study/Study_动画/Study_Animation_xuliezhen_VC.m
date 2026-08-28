//
//  Study_Animation_xuliezhen_VC.m
//  TodayNews
//
//  Created by linxiang on 2018/11/15.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_Animation_xuliezhen_VC.h"

@interface Study_Animation_xuliezhen_VC ()

@property (nonatomic, strong) UIImageView * imageV;

@end

@implementation Study_Animation_xuliezhen_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"序列帧动画";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.imageV];
    
    
    //创建可变数组存放序列帧图片
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < 81; i++) {
        // 图片名。%02d -- 当整数位数小于两位时，在前面自动补1个零
        NSString *name = [NSString stringWithFormat:@"drink_%02d.jpg", i];
        UIImage *img = [UIImage imageNamed:name];
        [images addObject:img];
    }
    
    self.imageV.animationImages = images;
    self.imageV.animationRepeatCount = 0;
    self.imageV.animationDuration = 81 * 0.1;
    [self.imageV startAnimating];
}

-(UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 512)];
    }
    return _imageV;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
