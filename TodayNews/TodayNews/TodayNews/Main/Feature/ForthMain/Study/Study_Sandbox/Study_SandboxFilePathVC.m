//
//  Study_SandboxFilePathVC.m
//  TodayNews
//
//  Created by 林祥 on 2018/4/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_SandboxFilePathVC.h"

@interface Study_SandboxFilePathVC ()

@end

@implementation Study_SandboxFilePathVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"沙盒路径";
    self.view.backgroundColor = LXRandomColor;
    
    
    
    
    // 沙盒目录
    LXLog(@"Home == %@",NSHomeDirectory());
    
    // MyApp.app
    LXLog(@"MyApp.app == %@",[[NSBundle mainBundle] bundlePath]);
    
    // Documents
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    LXLog(@"Documents == %@",docPath);
    
    // NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    // LXLog(@"Documents == %@",path);
    
    // Library
    NSArray *paths_1 = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [paths_1 objectAtIndex:0];
    LXLog(@"Library == %@",libPath);
    
    // tmp
    NSString * paths_2 = NSTemporaryDirectory();
    LXLog(@"tmp == %@",paths_2);
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
