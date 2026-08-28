//
//  Study_NSURLVC.m
//  TodayNews
//
//  Created by linxiang on 2018/5/24.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_NSURLVC.h"

@interface Study_NSURLVC ()

@end

@implementation Study_NSURLVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
     NSURL * url = [NSURL URLWithString:@"www.baidu.com"];
     NSURL * urll0 = [NSURL URLWithString:@"www.baidu!.com"];
     NSURL * urll1 = [NSURL URLWithString:@"www.baidu!@.com"];
     NSURL * urll2 = [NSURL URLWithString:@"www.baidu!@#.com"];
     NSURL * urll3 = [NSURL URLWithString:@"www.baidu!@#$.com"];
     NSURL * urll4 = [NSURL URLWithString:@"www.baidu!@#$%.com"];    // % ^
     NSURL * urll5 = [NSURL URLWithString:@"www.baidu!@#$.com"];
     NSURL * urll6 = [NSURL URLWithString:@"www.baidu!@#$&.com"];
     NSURL * urll7 = [NSURL URLWithString:@"www.baidu!@#$&*.com"];
     NSURL * urll8 = [NSURL URLWithString:@"www.baidu!@#$&*(.com"];
     NSURL * urll9 = [NSURL URLWithString:@"www.baidu!@#$&*().com"];
    
    
    
     NSURL * urll = [NSURL URLWithString:@"www.baidu!.com"];

    
     NSString * urlStr = @"www.baidu#$.com";
     NSString * urlStr_1 = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSURL * url_1 = [NSURL URLWithString:urlStr_1];
     
     
     NSString * urlStr_2 = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
     NSURL * url_2 = [NSURL URLWithString:urlStr_2];
     
     NSURL * DD = [[NSURL alloc]initWithString:urlStr];
    
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
