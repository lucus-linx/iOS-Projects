//
//  ViewController.m
//  LXLaunchGuidePods
//
//  Created by linxiang on 2017/4/13.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ViewController.h"

#import "LXLaunchGuideView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // 设置APP引导页
  
    if (1)
    {
        // 静态引导图
        NSArray *imageNameArray = @[@"GuidePageHUD_guideImage1.png",@"GuidePageHUD_guideImage2.png",@"GuidePageHUD_guideImage3.png",@"GuidePageHUD_guideImage4.png"];
        
        // 动态引导图
        // NSArray *imageNameArray = @[@"guideImage6.gif",@"guideImage7.gif",@"guideImage8.gif"];
        
        LXLaunchGuideView *launchGuideView = [[LXLaunchGuideView alloc] my_initWithFrame:self.view.frame imageNameArray:imageNameArray isHideBtn:NO];
        launchGuideView.isSlideEnter = YES;
        [self.view addSubview:launchGuideView];
    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
