//
//  LXLaunchGuideView.m
//  LXLaunchGuidePods
//
//  Created by linxiang on 2017/4/13.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "LXLaunchGuideView.h"

#define DDHidden_TIME   1.0
#define DDScreenW   [UIScreen mainScreen].bounds.size.width
#define DDScreenH   [UIScreen mainScreen].bounds.size.height

@interface LXLaunchGuideView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray       *imageArray;
@property (nonatomic, strong) UIPageControl *imagePageControl;
@property (nonatomic, assign) NSInteger     slideIntoNumber;

@end

@implementation LXLaunchGuideView


- (instancetype)my_initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray isHideBtn:(BOOL)isHideBtn {
    
    if ([super initWithFrame:frame]) {
        
        //默认值
        self.isSlideEnter = NO;
        
        self.imageArray = imageNameArray;
        
        //1. 设置引导视图的scrollview
        UIScrollView *guidePageView = [[UIScrollView alloc]initWithFrame:frame];
        [guidePageView setBackgroundColor:[UIColor lightGrayColor]];
        [guidePageView setContentSize:CGSizeMake(DDScreenW*imageNameArray.count, DDScreenH)];
        [guidePageView setBounces:NO];
        [guidePageView setPagingEnabled:YES];
        [guidePageView setShowsHorizontalScrollIndicator:NO];
        [guidePageView setDelegate:self];
        [self addSubview:guidePageView];
        
        //2. 设置引导页上的跳过按钮
        UIButton *skipButton = [[UIButton alloc]initWithFrame:CGRectMake(DDScreenW*0.8, DDScreenW*0.1, 50, 25)];
        [skipButton setBackgroundImage:[UIImage imageNamed:@"GuidePageHUD_Pass_normal.png"] forState:UIControlStateNormal];
        [skipButton setBackgroundImage:[UIImage imageNamed:@"GuidePageHUD_Pass_pressed.png"] forState:UIControlStateHighlighted];
        
        [skipButton.layer setCornerRadius:5.0];
        [skipButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:skipButton];
        
        //3. 添加在引导视图上的多张引导图片
        for (int i=0; i<imageNameArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(DDScreenW*i, 0, DDScreenW, DDScreenH)];
            
            imageView.image = [UIImage imageNamed:imageNameArray[i]];
            [guidePageView addSubview:imageView];
            
            // 设置在最后一张图片上显示进入体验按钮
            if (i == imageNameArray.count-1 && isHideBtn == NO) {
                [imageView setUserInteractionEnabled:YES];
                UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(DDScreenW*0.3, DDScreenH*0.8, DDScreenW*0.4, DDScreenH*0.08)];
             
                [startButton setBackgroundImage:[UIImage imageNamed:@"GuidePageHUD_Enter_normal.png"] forState:UIControlStateNormal];
                [startButton setBackgroundImage:[UIImage imageNamed:@"GuidePageHUD_Enter_pressed.png"] forState:UIControlStateHighlighted];
                
                [startButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:startButton];
            }
        }

        //4. 设置引导页上的页面控制器
        self.imagePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(DDScreenW*0.0, DDScreenH*0.9, DDScreenW*1.0, DDScreenH*0.1)];
        self.imagePageControl.currentPage = 0;
        self.imagePageControl.numberOfPages = imageNameArray.count;
        self.imagePageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.imagePageControl.currentPageIndicatorTintColor = [UIColor greenColor];
        self.imagePageControl.enabled = NO;
        [self addSubview:self.imagePageControl];
        
    }
    
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    int page = scrollview.contentOffset.x / scrollview.frame.size.width;
    [self.imagePageControl setCurrentPage:page];
    if (self.imageArray && page < self.imageArray.count-1 && self.isSlideEnter == YES) {
        self.slideIntoNumber = 1;
    }
    if (self.imageArray && page == self.imageArray.count-1 && self.isSlideEnter == YES) {
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:nil action:nil];
        if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight){
            self.slideIntoNumber++;
            if (self.slideIntoNumber == 3) {
                [self buttonClick:nil];
            }
        }
    }
}

- (void)buttonClick:(UIButton *)button {
    [UIView animateWithDuration:DDHidden_TIME animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DDHidden_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeGuidePageHUD) withObject:nil afterDelay:1];
        });
    }];
}

- (void)removeGuidePageHUD {
    [self removeFromSuperview];
}



@end
