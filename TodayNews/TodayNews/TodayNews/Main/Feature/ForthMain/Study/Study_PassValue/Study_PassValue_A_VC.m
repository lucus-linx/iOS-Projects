//
//  Study_PassValue_A_VC.m
//  TodayNews
//
//  Created by linxiang on 2018/4/27.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_PassValue_A_VC.h"

#import "Study_PassValue_B_VC.h"

@interface Study_PassValue_A_VC ()

@property (assign, nonatomic) BOOL ISPOP;

@property (nonatomic, strong) Study_PassValue_B_VC * B_VC;

@end

@implementation Study_PassValue_A_VC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_ISPOP) {
        //执行POP的方法，比如你POP回来后需要刷新表格。
        NSLog(@"POP");
        NSUserDefaults * defaultA = [NSUserDefaults standardUserDefaults];
        NSDictionary * dict = [defaultA valueForKey:@"Value2"];
        
        if ([dict[@"value"] isEqualToString:@"123"]) {
            Study_PassValue_B_VC * vc = [Study_PassValue_B_VC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        //执行PUSH进来时的方法。
        NSLog(@"PUSH");
    }
    _ISPOP = YES;  //将标志设置为YES。
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LXRandomColor;
    self.title = @"页面传值-Block";
    
    _ISPOP = NO;
    
    
    float W = SCREEN_WIDTH/2;
    float H = 50;
    [self createBtn:CGRectMake(0, H, W, H) :1 :@"Push跳转页面"];
}

-(void)btnCallBack:(id)sender {
    UIButton * btn = (UIButton *)sender;
    
    if (btn.tag == 1) {
        LXLog(@"Push");
        
        Study_PassValue_B_VC * vc = [[Study_PassValue_B_VC alloc]init];
        __weak __typeof(self)wself = self;
        vc.myblock = ^(NSDictionary * dict) {
            NSLog(@"传递参数： = %@", dict[@"value"]);
        };
        [self.navigationController pushViewController:vc animated:YES];
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
