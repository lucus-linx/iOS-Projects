//
//  Study_Animation_UIViewAnimation_VC.m
//  TodayNews
//
//  Created by linxiang on 2018/11/15.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_Animation_UIViewAnimation_VC.h"

@interface Study_Animation_UIViewAnimation_VC ()

@property (nonatomic, strong) UIView *AniV;

@end

@implementation Study_Animation_UIViewAnimation_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"UIView Animation";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.AniV];
    
    // =======================
    //创建segmentControl 分段控件
    UISegmentedControl *segC = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,50)];
    //添加小按钮
    [segC insertSegmentWithTitle:@"UIView属性变化动画" atIndex:0 animated:YES];
    [segC insertSegmentWithTitle:@"UIView转场效果动画" atIndex:1 animated:YES];
    //设置样式
    [segC setTintColor:[UIColor grayColor]];
    //设置字体样式
    [segC setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    //添加事件
    [segC addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segC];
    
    // =======================
    //创建segmentControl 分段控件
    UISegmentedControl *segC1 = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0,300,SCREEN_WIDTH,50)];
    //添加小按钮
    [segC1 insertSegmentWithTitle:@"block属性动画" atIndex:0 animated:YES];
    [segC1 insertSegmentWithTitle:@"Spring动画" atIndex:1 animated:YES];
    //设置样式
    [segC1 setTintColor:[UIColor grayColor]];
    //设置字体样式
    [segC1 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    //添加事件
    [segC1 addTarget:self action:@selector(segmentValueChanged1:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segC1];

    // =======================
    //创建segmentControl 分段控件
    UISegmentedControl *segC2 = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0,600,SCREEN_WIDTH,50)];
    //添加小按钮
    [segC2 insertSegmentWithTitle:@"Keyframes动画" atIndex:0 animated:YES];
    [segC2 insertSegmentWithTitle:@"父视图转场动画" atIndex:1 animated:YES];
    [segC2 insertSegmentWithTitle:@"单个视图转场" atIndex:2 animated:YES];
    //设置样式
    [segC2 setTintColor:[UIColor grayColor]];
    //设置字体样式
    [segC2 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    //添加事件
    [segC2 addTarget:self action:@selector(segmentValueChanged2:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segC2];
    
    
    self.AniV.transform = CGAffineTransformMakeTranslation(100, 100);
}

//点击按钮事件
-(void)segmentValueChanged:(UISegmentedControl *)seg{
    NSUInteger segIndex = [seg selectedSegmentIndex];
    //将当旧VC的view移除，然后在添加新VC的view
    if (segIndex == 0) {
        // UIView 类方法动画 -- 属性变化(frame为例)
        [self UIViewAnimation_demo1];
    }else if (segIndex == 1){
        // UIView 类方法动画 -- 转场效果动画
        [self UIViewAnimation_demo2];
    }else{
    }
}

//点击按钮事件
-(void)segmentValueChanged1:(UISegmentedControl *)seg{
    NSUInteger segIndex = [seg selectedSegmentIndex];
    //将当旧VC的view移除，然后在添加新VC的view
    if (segIndex == 0) {
        // UIView Block动画方法
        [self UIViewAnimation_block_demo3];
    }else if (segIndex == 1){
        // UIView Block动画方法 -- Spring动画
        [self UIViewAnimation_Spring_demo4];
    }else{
    }
}

//点击按钮事件
-(void)segmentValueChanged2:(UISegmentedControl *)seg{
    NSUInteger segIndex = [seg selectedSegmentIndex];
    //将当旧VC的view移除，然后在添加新VC的view
    if (segIndex == 0) {
        // UIView Keyframes
        [self UIViewAnimation_Keyframes_demo5];
    }else if (segIndex == 1){
        // UIView 父视图转场动画
        [self UIViewAnimation_trans_demo6];
    }else if (segIndex == 2){
        // UIView 单视图转场动画
        [self UIViewAnimation_trans_demo7];
    }else{
    }
}

#pragma mark - UIView 类方法动画

// 属性变化动画（以frame变化为例）
-(void)UIViewAnimation_demo1 {
    // 重置frame
    self.AniV.frame = CGRectMake(0, 0, 100, 100);
    
    [UIView beginAnimations:@"myAni" context:nil];
    //动画持续时间
    [UIView setAnimationDuration:1.0];
    //动画的代理对象
    [UIView setAnimationDelegate:self];
    //设置动画将开始时代理对象执行的SEL
    [UIView setAnimationWillStartSelector:@selector(startAni:)];
    //设置动画结束时代理对象执行的SEL
    [UIView setAnimationDidStopSelector:@selector(stopAni:)];
    //设置动画延迟执行的时间
    [UIView setAnimationDelay:0.0f];
    //设置动画的重复次数
    [UIView setAnimationRepeatCount:1.0f];
    /* 设置动画的曲线, UIViewAnimationCurve的枚举值如下：
        UIViewAnimationCurveEaseInOut,         // 慢进慢出（默认值）
        UIViewAnimationCurveEaseIn,            // 慢进
        UIViewAnimationCurveEaseOut,           // 慢出
        UIViewAnimationCurveLinear             // 匀速
     */
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    /* 设置是否从当前状态开始播放动画
     假设上一个动画正在播放，且尚未播放完毕，我们将要进行一个新的动画：
     当为YES时：动画将从上一个动画所在的状态开始播放
     当为NO时：动画将从上一个动画所指定的最终状态开始播放（此时上一个动画马上结束）
    */
    [UIView setAnimationBeginsFromCurrentState:YES];
    //设置动画是否继续执行相反的动画
    [UIView setAnimationRepeatAutoreverses:NO];
    //是否禁用动画效果（对象属性依然会被改变，只是没有动画效果）
    [UIView setAnimationsEnabled:YES];
    
    // frame
    self.AniV.frame = CGRectMake(0, 200, 200, 200);
    // 结束动画标记
    [UIView commitAnimations];
}

- (void)startAni:(NSString *)aniID {
    NSLog(@"%@ start",aniID);
}

- (void)stopAni:(NSString *)aniID {
    NSLog(@"%@ stop",aniID);
}


-(void)UIViewAnimation_demo2 {

    [UIView beginAnimations:@"FlipAni" context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(startAni2:)];
    [UIView setAnimationDidStopSelector:@selector(stopAni2:)];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    /* 设置视图的过渡效果
     第一个参数：UIViewAnimationTransition的枚举值如下
     UIViewAnimationTransitionNone,              //不使用动画
     UIViewAnimationTransitionFlipFromLeft,      //从左向右旋转翻页
     UIViewAnimationTransitionFlipFromRight,     //从右向左旋转翻页
     UIViewAnimationTransitionCurlUp,            //从下往上卷曲翻页
     UIViewAnimationTransitionCurlDown,          //从上往下卷曲翻页
     第二个参数：需要过渡效果的View
     第三个参数：是否使用视图缓存，YES：视图在开始和结束时渲染一次；NO：视图在每一帧都渲染
     */
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.AniV cache:YES];
    self.AniV.backgroundColor = [UIColor orangeColor];
    [UIView commitAnimations];
}
    

- (void)startAni2:(NSString *)aniID {
    NSLog(@"%@ start",aniID);
}

- (void)stopAni2:(NSString *)aniID {
    NSLog(@"%@ stop",aniID);
}


#pragma mark - UIview Block动画

-(void)UIViewAnimation_block_demo3 {
    // 重置frame
    self.AniV.frame = CGRectMake(0, 0, 100, 100);
    
    /*  1.动画持续时间
        2.动画延迟执行的时间
        3.动画的过渡效果
        4.执行的动画
        5.动画执行完毕后的操作 */
    
    /* UIViewAnimationOptions枚举值
     UIViewAnimationOptionLayoutSubviews            //进行动画时布局子控件
     UIViewAnimationOptionAllowUserInteraction      //进行动画时允许用户交互
     UIViewAnimationOptionBeginFromCurrentState     //从当前状态开始动画
     UIViewAnimationOptionRepeat                    //无限重复执行动画
     UIViewAnimationOptionAutoreverse               //执行动画回路
     UIViewAnimationOptionOverrideInheritedDuration //忽略嵌套动画的执行时间设置
     UIViewAnimationOptionOverrideInheritedCurve    //忽略嵌套动画的曲线设置
     UIViewAnimationOptionAllowAnimatedContent      //转场：进行动画时重绘视图
     UIViewAnimationOptionShowHideTransitionViews   //转场：移除（添加和移除图层的）动画效果
     UIViewAnimationOptionOverrideInheritedOptions  //不继承父动画设置
     
     UIViewAnimationOptionCurveEaseInOut            //时间曲线，慢进慢出（默认值）
     UIViewAnimationOptionCurveEaseIn               //时间曲线，慢进
     UIViewAnimationOptionCurveEaseOut              //时间曲线，慢出
     UIViewAnimationOptionCurveLinear               //时间曲线，匀速
     
     UIViewAnimationOptionTransitionNone            //转场，不使用动画
     UIViewAnimationOptionTransitionFlipFromLeft    //转场，从左向右旋转翻页
     UIViewAnimationOptionTransitionFlipFromRight   //转场，从右向左旋转翻页
     UIViewAnimationOptionTransitionCurlUp          //转场，下往上卷曲翻页
     UIViewAnimationOptionTransitionCurlDown        //转场，从上往下卷曲翻页
     UIViewAnimationOptionTransitionCrossDissolve   //转场，交叉消失和出现
     UIViewAnimationOptionTransitionFlipFromTop     //转场，从上向下旋转翻页
     UIViewAnimationOptionTransitionFlipFromBottom  //转场，从下向上旋转翻页
     */
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
        self.AniV.frame = CGRectMake(0, 400, 200, 200);
    } completion:^(BOOL finished) {
        NSLog(@"动画完成！！");
    }];
}


#pragma mark - UIview Spring动画   iOS7.0后新增Spring动画

-(void)UIViewAnimation_Spring_demo4 {

    [UIView animateWithDuration:2.0f     // 动画持续时间
                          delay:0.0      // 动画延迟执行的时间
         usingSpringWithDamping:0.8      // 震动效果，范围0~1，数值越小震动效果越明显
          initialSpringVelocity:10       // 初始速度，数值越大初始速度越快
                        options:UIViewAnimationOptionRepeat    // 动画的过渡效果
                     animations:^{
                         
                         self.AniV.frame = CGRectMake(0, 400, 200, 200);
                     } completion:^(BOOL finished) {
                         NSLog(@"动画完成！！");
                     }];
}


#pragma mark - UIview Keyframes动画   iOS7.0后新增关键帧动画

-(void)UIViewAnimation_Keyframes_demo5 {
    
    [UIView animateKeyframesWithDuration:5.0    // 动画持续时间
                                   delay:0.0    // 动画延迟执行的时间
                                 options:UIViewKeyframeAnimationOptionRepeat
                              animations:^{
                                  
                                  // 增加关键帧的方法
                                  [UIView addKeyframeWithRelativeStartTime:0.f relativeDuration:1.0 / 4 animations:^{
                                      self.AniV.backgroundColor = [UIColor colorWithRed:0.9475 green:0.1921 blue:0.1746 alpha:1.0];
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:1.0 / 4 relativeDuration:1.0 / 4 animations:^{
                                      self.AniV.backgroundColor = [UIColor colorWithRed:0.1064 green:0.6052 blue:0.0334 alpha:1.0];
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:2.0 / 4 relativeDuration:1.0 / 4 animations:^{
                                      self.AniV.backgroundColor = [UIColor colorWithRed:0.1366 green:0.3017 blue:0.8411 alpha:1.0];
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:3.0 / 4 relativeDuration:1.0 / 4 animations:^{
                                      self.AniV.backgroundColor = [UIColor colorWithRed:0.619 green:0.037 blue:0.6719 alpha:1.0];
                                  }];
                              } completion:^(BOOL finished) {
                                  
                              }];
}

#pragma mark - UIview 父视图转场动画

-(void)UIViewAnimation_trans_demo6 {
    /*
     在该动画过程中，fromView 会从父视图中移除，并讲 toView 添加到父视图中，注意转场动画的作用对象是父视图（过渡效果体现在父视图上）。
     调用该方法相当于执行下面两句代码：
        [fromView.superview addSubview:toView];
        [fromView removeFromSuperview];
     */
    UIView * newV = [[UIView alloc]initWithFrame:self.AniV.frame];
    newV.backgroundColor = [UIColor blueColor];
    
    [UIView transitionFromView:self.AniV
                        toView:newV
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
        
                    }];
}

#pragma mark - UIview 单个视图转场动画

-(void)UIViewAnimation_trans_demo7 {
    
    [UIView transitionWithView:self.AniV
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        
                        self.AniV.backgroundColor = [UIColor purpleColor];
                    } completion:^(BOOL finished) {
        
                    }];
}



#pragma mark - lazy init

-(UIView *)AniV {
    if (!_AniV) {
        _AniV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _AniV.backgroundColor = [UIColor redColor];
    }
    return _AniV;
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
