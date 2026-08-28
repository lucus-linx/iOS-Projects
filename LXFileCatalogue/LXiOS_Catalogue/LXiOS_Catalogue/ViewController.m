//
//  ViewController.m
//  LXiOS_Catalogue
//
//  Created by linxiang on 2017/8/21.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // 沙盒目录
    NSLog(@"%@",NSHomeDirectory());
    
    // MyApp.app
    NSLog(@"%@",[[NSBundle mainBundle] bundlePath]);
    
    // tmp
    NSLog(@"%@",NSTemporaryDirectory());
    
    // Documents
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSLog(@"%@",docPath);
    
    // Library
    NSArray *paths_1 = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [paths_1 objectAtIndex:0];
    NSLog(@"%@",libPath);

    
    // /Users/linxiang/Library/Developer/CoreSimulator/Devices/4312D65E-824F-440E-A308-79B296DBA140/data/Containers/Data/Application/302A8FF3-C121-41BC-837F-3001E5FED8FC

    // /var/mobile/Containers/Data/Application/12AE67FC-5213-4886-806A-0556F148287C
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
