//
//  LXADView.m
//  TodayNews
//
//  Created by linxiang on 2018/2/28.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXADView.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#define LXScreenW   [UIScreen mainScreen].bounds.size.width
#define LXScreenH   [UIScreen mainScreen].bounds.size.height

@interface LXADView()

@property (nonatomic, strong) AVPlayerViewController *avPlayerViewController;

@property (nonatomic, strong) UIButton * enterMainButton;

@end

@implementation LXADView

- (instancetype)my_init {
    
    if ([super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setMoviePlayer];
    }
    return self;
}

-(void)setMoviePlayer {
    //初始化AVPlayer
    self.avPlayerViewController = [[AVPlayerViewController alloc]init];
    //多分屏功能取消
    if (@available(iOS 9.0, *)) {
        self.avPlayerViewController.allowsPictureInPicturePlayback = NO;
    } else {
        // Fallback on earlier versions
    }
    
    //设置是否显示媒体播放组件
    self.avPlayerViewController.showsPlaybackControls = false;
    
    // 获取媒体资源地址
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"GuidePageHUD_Movie02.mp4" ofType:nil];
    
    //初始化一个播放单位。给AVplayer 使用
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:path]];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    
    //layer
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    [layer setFrame:[UIScreen mainScreen].bounds];
    /*  设置填充模式
     可以设置的值及意义如下：
     AVLayerVideoGravityResizeAspect   不进行比例缩放 以宽高中长的一边充满为基准
     AVLayerVideoGravityResizeAspectFill 不进行比例缩放 以宽高中短的一边充满为基准
     AVLayerVideoGravityResize     进行缩放充满屏幕
     */
    layer.videoGravity = AVLayerVideoGravityResize;
    
    
    //设置AVPlayerViewController内部的AVPlayer为刚创建的AVPlayer
    self.avPlayerViewController.player = player;
    //添加到self.view上面去
    [self.layer addSublayer:layer];
    //开始播放
    [self.avPlayerViewController.player play];
    
    
    //这里设置的是重复播放。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playDidEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:item];
    
    
    //进入按钮
    _enterMainButton = [[UIButton alloc] init];
    _enterMainButton.frame = CGRectMake(30, LXScreenH - 48 - 50 - BOTTOM_HEIGHT, LXScreenW - 60, 48);
    _enterMainButton.backgroundColor = [UIColor whiteColor];
    _enterMainButton.layer.borderWidth = 1;
    _enterMainButton.layer.cornerRadius = 24;
    _enterMainButton.layer.borderColor = [UIColor redColor].CGColor;
    [_enterMainButton setTitle:@"进入应用" forState:UIControlStateNormal];
    [_enterMainButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_enterMainButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_enterMainButton];
}

//播放完成的代理
- (void)playDidEnd:(NSNotification *)Notification{
    //播放完成后。设置播放进度为0 。 重新播放
    [self.avPlayerViewController.player seekToTime:CMTimeMake(0, 1)];
    //开始播放
    [self.avPlayerViewController.player play];
}


- (void)enterMainAction:(UIButton *)btn {
    
    [self removeFromSuperview];
    
}

// 点击时间的拦截
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint newPoint = [self convertPoint:point toView:_enterMainButton];
    if ( [_enterMainButton pointInside:newPoint withEvent:event]) {
        // 如果点击事件在按钮内，则按钮响应此事件
        return _enterMainButton;
    }
    // 将事件拦截给自己，防止透给其他底层图层
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
