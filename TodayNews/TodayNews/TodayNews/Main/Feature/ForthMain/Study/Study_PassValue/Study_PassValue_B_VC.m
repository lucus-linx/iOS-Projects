//
//  Study_PassValue_B_VC.m
//  TodayNews
//
//  Created by linxiang on 2018/4/27.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_PassValue_B_VC.h"

@interface Study_PassValue_B_VC ()

@property (nonatomic, strong)UITextField * myTF;

@end

@implementation Study_PassValue_B_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = LXRandomColor;
    self.title = @"页面传值-Block";
    
    _myTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 50, SCREEN_WIDTH - 100, 50)];
    _myTF.placeholder = @"随意输入";
    _myTF.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_myTF];
    
    
    float W = SCREEN_WIDTH/2;
    float H = 50;
    [self createBtn:CGRectMake(0, H*3, W, H) :1 :@"POP跳转页面"];
}

-(void)btnCallBack:(id)sender {
    UIButton * btn = (UIButton *)sender;
    
    if (btn.tag == 1) {
        NSDictionary * dict1 = @{@"参数1":@"AAA",
                                @"参数2":@"BBB",
                                @"value":_myTF.text
                                };
        NSUserDefaults * defaultA = [NSUserDefaults standardUserDefaults];
        [defaultA setObject:dict1 forKey:@"Value2"];
        [defaultA synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
        if (self.myblock != nil) {
            NSDictionary * dict = @{@"参数1":@"AAA",
                                    @"参数2":@"BBB",
                                    @"value":_myTF.text
                                    };
            
            self.myblock(dict);
        }
    }
}

#pragma mark -- CraeteView
-(void)createBtn:(CGRect)frame :(NSInteger)tag :(NSString *)title {
    UIButton * btn = [[UIButton alloc]initWithFrame:frame];
    btn.backgroundColor = LXRandomColor;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
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
