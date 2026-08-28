//
//  Study_SDWebImageVC.m
//  TodayNews
//
//  Created by 林祥 on 2018/4/3.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_SDWebImageVC.h"

// MD5 加密头文件
#import <CommonCrypto/CommonDigest.h>

#import <SDWebImage/UIImageView+WebCache.h>

@interface Study_SDWebImageVC (){
    UIImageView * imageV;
}

@end

@implementation Study_SDWebImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"SDWebImage";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 200, 200)];
    [self.view addSubview:imageV];
    
    
    [self cachedFileNameForKey:@"123"];

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    SDImageCacheConfig *conf = [[SDImageCacheConfig alloc]init];
    
    [imageV sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.baidu.com/73F1bjeh1BF3odCf/it/u=1331072331,4134051125&fm=85&s=08A2DD172EF73A820C2CE82F0300E060"] placeholderImage:[UIImage imageNamed:@"camera2"] options:SDWebImageRetryFailed];
}


#pragma mark - SD_MD5
- (nullable NSString *)cachedFileNameForKey:(nullable NSString *)key {
    const char *str = key.UTF8String;
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [key.pathExtension isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", key.pathExtension]];
    
    return filename;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
