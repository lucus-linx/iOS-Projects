# LXLaunchGuidePods
## 启动页面 暂时仅支持png
## 最新版本 0.0.2


展示如下<br>
![image](https://github.com/lionsom/LXLaunchGuidePods/blob/master/ShowImages/show_Image_1.png)

## 如何使用<br>
### 第一步：pod<br>
```
pod 'LXLaunchGuidePods'
```
### 第二步：import<br>
```
#import "LXLaunchGuideView.h"
```
### 第三步：在首页面直接添加，不需要改动任何代码<br>
```
    if (isFirst)
    {
        // 静态引导图
        NSArray *imageNameArray = @[@"GuidePageHUD_guideImage1.png",@"GuidePageHUD_guideImage2.png",@"GuidePageHUD_guideImage3.png",@"GuidePageHUD_guideImage4.png"];
        LXLaunchGuideView *launchGuideView = [[LXLaunchGuideView alloc] my_initWithFrame:self.view.frame imageNameArray:imageNameArray isHideBtn:NO];
        launchGuideView.isSlideEnter = YES;
        [self.view addSubview:launchGuideView];
    }
```





如有侵权，请联系<br>
邮箱：lionsom_lin@qq.com
