//
//  Study_MVCVSMVVM_ViewController.m
//  TodayNews
//
//  Created by linxiang on 2019/3/14.
//  Copyright © 2019年 LX. All rights reserved.
//

#import "Study_MVCVSMVVM_ViewController.h"
#import "Study_MVCVSMVVM_Person.h"

#import "Study_MVCVSMVVM_MVVM_PersonViewModel.h"

@interface Study_MVCVSMVVM_ViewController ()

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * birthdateLabel;

@property (nonatomic, strong) UIButton * CodeByMVCBtn;
@property (nonatomic, strong) UIButton * CodeByMVVMBtn;

@property (nonatomic, strong, readwrite) Study_MVCVSMVVM_Person * model;

@property (nonatomic, strong, readwrite) Study_MVCVSMVVM_MVVM_PersonViewModel * viewModel;

@end

@implementation Study_MVCVSMVVM_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"MVC VS MVVM";
    
    
    // add
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.birthdateLabel];
    [self.view addSubview:self.CodeByMVCBtn];
    [self.view addSubview:self.CodeByMVVMBtn];
    
    // Masonry
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.top.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.birthdateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(20);
        make.height.equalTo(@50);
    }];
    [self.CodeByMVCBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.birthdateLabel.mas_bottom).offset(50);
        make.height.equalTo(@50);
    }];
    [self.CodeByMVVMBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.CodeByMVCBtn.mas_bottom).offset(20);
        make.height.equalTo(@50);
    }];
    
}


#pragma mark - Btn Call Back

- (void)CodeByMVCBtnCallBack {
    // 初始化
    self.model = [[Study_MVCVSMVVM_Person alloc] initWithSalutation:@"外号" firstName:@"王" lastName:@"二" birthdate:[NSDate date]];
    
/*
    由此可见，一些判断逻辑 给 Controller 增加了负担
 */
    // 再赋值
    if (self.model.salutation.length > 0) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@ %@", self.model.salutation, self.model.firstName, self.model.lastName];
    } else {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.model.firstName, self.model.lastName];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    self.birthdateLabel.text = [dateFormatter stringFromDate:self.model.birthdate];
}

- (void)CodeByMVVMBtnCallBack {
    Study_MVCVSMVVM_Person * newmodel = [[Study_MVCVSMVVM_Person alloc] initWithSalutation:@"昵称" firstName:@"李" lastName:@"四" birthdate:[NSDate date]];
    self.viewModel = [[Study_MVCVSMVVM_MVVM_PersonViewModel alloc] initWithPerson:newmodel];
    
/*
    MVVM将一些逻辑放到了ViewModel中，减轻了Controller负担
 */
    self.nameLabel.text = self.viewModel.nameText;
    self.birthdateLabel.text = self.viewModel.birthdateText;
}


#pragma mark - Lazy init

-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _nameLabel;
}

-(UILabel *)birthdateLabel {
    if (!_birthdateLabel) {
        _birthdateLabel = [[UILabel alloc] init];
        _birthdateLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _birthdateLabel;
}

-(UIButton *)CodeByMVCBtn {
    if (!_CodeByMVCBtn) {
        _CodeByMVCBtn = [[UIButton alloc] init];
        _CodeByMVCBtn.backgroundColor = [UIColor orangeColor];
        [_CodeByMVCBtn setTitle:@"Code by MVC" forState:UIControlStateNormal];
        [_CodeByMVCBtn addTarget:self action:@selector(CodeByMVCBtnCallBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _CodeByMVCBtn;
}

-(UIButton *)CodeByMVVMBtn {
    if (!_CodeByMVVMBtn) {
        _CodeByMVVMBtn = [[UIButton alloc] init];
        _CodeByMVVMBtn.backgroundColor = [UIColor redColor];
        [_CodeByMVVMBtn setTitle:@"Code by MVVC" forState:UIControlStateNormal];
        [_CodeByMVVMBtn addTarget:self action:@selector(CodeByMVVMBtnCallBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _CodeByMVVMBtn;
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
