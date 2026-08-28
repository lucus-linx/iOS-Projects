//
//  LXCheckAppVersion.m
//  FutureDoctor
//
//  Created by linxiang on 2017/4/14.
//  Copyright © 2017年 misrobot. All rights reserved.
//

#import "LXCheckAppVersion.h"

static NSString *APP_ID = @"444934666";

@implementation LXCheckAppVersion

+ (void)CheckAppVersion {
    
    // 拼接链接、转换成URL
    NSString *checkUrlString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", APP_ID];
    NSURL *checkUrl = [NSURL URLWithString:checkUrlString];
    
    // 获取网络数据AppStore上app的信息
    NSString *appInfoString = [NSString stringWithContentsOfURL:checkUrl encoding:NSUTF8StringEncoding error:nil];
    
    //断网情况下，请求数据为空
    if (!appInfoString) {
        NSLog(@"请求数据失败！！！");
        return;
    }
    // 字符串转json转字典
    NSError *error = nil;
    NSData *JSONData = [appInfoString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:&error];
    
    if (!error && appInfo) {
        // 返回没错误，那就开始获取app信息啦，很多内容，要解剖这数据 results->array[0]->version
        // NSLog(@"%@", appInfo);
        NSArray *resultsAry = appInfo[@"results"];
        NSDictionary *resultsDic = resultsAry.firstObject;
        // 版本号
        NSString *version = resultsDic[@"version"];
        // 应用名称
        NSString *trackCensoredName = resultsDic[@"trackName"];
        // 下载地址
        NSString *trackViewUrl = resultsDic[@"trackViewUrl"];
        
        // 获取当前版本号
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        
        // 比较当前版本和新版本号大小
/*
        if ([version compare:appVersion options:NSNumericSearch] == NSOrderedDescending) {
            NSLog(@"App Store版本号 >>>> 本地版本号");
            NSLog(@"发现新版本 %@", version);
        }
 */
        if ([version compare:appVersion options:NSNumericSearch] != NSOrderedSame) {
            NSLog(@"发现新版本 %@", version);
            
            // 1. 实例化
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更新" message:@"已发现新版本，是否前往更新？" preferredStyle:UIAlertControllerStyleAlert];
            // 2. 添加方法
            //1.取消
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            //2.确定
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //前往更新
                //下载地址可以是trackViewUrl，也可以是itms-apps://itunes.apple.com/app/id444934666
                NSURL *url = [NSURL URLWithString:trackViewUrl];
                //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APP_ID]];
                [[UIApplication sharedApplication]openURL:url];
                
            }]];
            UIViewController *vc = [UIApplication sharedApplication].windows[0].rootViewController;
            [vc presentViewController:alert animated:YES completion:nil];
            
        }else{
            NSLog(@"没有新版本");
        }
    }else{
        // 返回错误，则相当于无更新吧，看你怎么想咯
        NSLog(@"请求数据错误");
    }
}


@end
