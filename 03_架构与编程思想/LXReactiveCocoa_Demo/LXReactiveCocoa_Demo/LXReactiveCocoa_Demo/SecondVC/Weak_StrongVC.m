//
//  Weak_StrongVC.m
//  LXReactiveCocoa_Demo
//
//  Created by linxiang on 2017/5/8.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "Weak_StrongVC.h"

#import <ReactiveObjC/ReactiveObjC.h>

@interface Weak_StrongVC ()

@property (nonatomic, strong) RACSignal * mysignal;

@end

@implementation Weak_StrongVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @weakify(self);
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSLog(@"%@",self);
        
        return nil;
    }];

    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    _mysignal = signal;
    
    [self createUI];
}

-(void)createUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [backBtn addTarget:self action:@selector(backBtnCallBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:backBtn];
}

-(void)backBtnCallBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)dealloc {
    NSLog(@"哥们走了");
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
