//
//  LXLaunchGuideView.m
//  LXLaunchGuidePods
//
//  Created by linxiang on 2017/4/13.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "LXLaunchGuideView.h"

#import "UIImage+LXGif.h"
#import "NSString+FileType.h"

#define LXHidden_TIME   1.0
#define LXScreenW   [UIScreen mainScreen].bounds.size.width
#define LXScreenH   [UIScreen mainScreen].bounds.size.height

@interface LXLaunchGuideView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray       *imageArray;
@property (nonatomic, strong) UIPageControl *imagePageControl;
@property (nonatomic, assign) NSInteger     slideIntoNumber;

@end

@implementation LXLaunchGuideView

#pragma mark - PNG,JPG,GIF
- (instancetype)my_initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray isHideBtn:(BOOL)isHideBtn {
    
    if ([super initWithFrame:frame]) {
        
        //默认值
        self.isSlideEnter = NO;
        
        self.imageArray = imageNameArray;
        
        //1. 设置引导视图的scrollview
        UIScrollView *guidePageView = [[UIScrollView alloc]initWithFrame:frame];
        [guidePageView setBackgroundColor:[UIColor lightGrayColor]];
        [guidePageView setContentSize:CGSizeMake(LXScreenW*imageNameArray.count, LXScreenH)];
        [guidePageView setBounces:NO];
        [guidePageView setPagingEnabled:YES];
        [guidePageView setShowsHorizontalScrollIndicator:NO];
        [guidePageView setDelegate:self];
        [self addSubview:guidePageView];
        
        //2. 设置引导页上的跳过按钮
        UIButton *skipButton = [[UIButton alloc]initWithFrame:CGRectMake(LXScreenW*0.8, LXScreenW*0.1, 50, 25)];
        [skipButton setBackgroundImage:[UIImage imageNamed:@"GuidePageHUD_Pass_normal.png"] forState:UIControlStateNormal];
        [skipButton setBackgroundImage:[UIImage imageNamed:@"GuidePageHUD_Pass_pressed.png"] forState:UIControlStateHighlighted];
        
        [skipButton.layer setCornerRadius:5.0];
        [skipButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:skipButton];
        
        //3. 添加在引导视图上的多张引导图片
        for (int i=0; i<imageNameArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(LXScreenW*i, 0, LXScreenW, LXScreenH)];
            [guidePageView addSubview:imageView];
            
            // 判断图片类型
            NSString * type = [NSString lx_FileType:imageNameArray[i]];
            
            if ([type isEqualToString:@"gif"]) {
            // Gif播放 方法一：使用SDWebImage扩展类 播放NSData数据的GIF
                //获取文件名，不带后缀
                NSString * name = [imageNameArray[i] stringByDeletingPathExtension];
                NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
                NSData *data = [NSData dataWithContentsOfFile:path];
                UIImage *image = [UIImage lx_animatedGIFWithData:data]; //此处用的是老版本的SDWebImage中的扩展
                imageView.image = image;

            // Gif播放 方法二：将GIF图片分解成多张PNG图片，使用UIImageView播放。
                /*
                NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"GuidePageHUD_Gif01" withExtension:@"gif"]; //加载GIF图片
                CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef) fileUrl, NULL);           //将GIF图片转换成对应的图片源
                size_t frameCout = CGImageSourceGetCount(gifSource);                                         //获取其中图片源个数，即由多少帧图片组成
                NSMutableArray *frames = [[NSMutableArray alloc] init];                                      //定义数组存储拆分出来的图片
                for (size_t i = 0; i < frameCout; i++) {
                    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL); //从GIF图片中取出源图片
                    UIImage *imageName = [UIImage imageWithCGImage:imageRef];                  //将图片源转换成UIimageView能使用的图片源
                    [frames addObject:imageName];                                              //将图片加入数组中
                    CGImageRelease(imageRef);
                }
                imageView.animationImages = frames; //将图片数组加入UIImageView动画数组中
                imageView.animationDuration = 2; //每次动画时长
                [imageView startAnimating];         //开启动画，此处没有调用播放次数接口，UIImageView默认播放次数为无限次，故这里不做处理
                */
                
            // Gif播放 方法三：UIWebView
                //未实现，可自行百度
            } else if([type isEqualToString:@"png"] || [type isEqualToString:@"jpg"]) {
                imageView.image = [UIImage imageNamed:imageNameArray[i]];
            }
            
         
            // 设置在最后一张图片上显示进入体验按钮
            if (i == imageNameArray.count-1 && isHideBtn == NO) {
                [imageView setUserInteractionEnabled:YES];
                UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(LXScreenW*0.3, LXScreenH*0.8, LXScreenW*0.4, LXScreenH*0.08)];
             
                [startButton setBackgroundImage:[UIImage imageNamed:@"GuidePageHUD_Enter_normal.png"] forState:UIControlStateNormal];
                [startButton setBackgroundImage:[UIImage imageNamed:@"GuidePageHUD_Enter_pressed.png"] forState:UIControlStateHighlighted];
                
                [startButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:startButton];
            }
        }

        //4. 设置引导页上的页面控制器
        self.imagePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(LXScreenW*0.0, LXScreenH*0.9, LXScreenW*1.0, LXScreenH*0.1)];
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
    [UIView animateWithDuration:LXHidden_TIME animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(LXHidden_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeGuidePageHUD) withObject:nil afterDelay:1];
        });
    }];
}

- (void)removeGuidePageHUD {
    [self removeFromSuperview];
}


@end
