//
//  LoginRAC_ViewController.m
//  TodayNews
//
//  Created by 林祥 on 2019/3/12.
//  Copyright © 2019 LX. All rights reserved.
//

#import "LoginRAC_ViewController.h"
#import "LoginRAC_ViewModel.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface LoginRAC_ViewController ()

@property (nonatomic, strong, readwrite) UITextField * usernameTF;
@property (nonatomic, strong, readwrite) UITextField * passwordTF;

@property (nonatomic, strong, readwrite) UIImageView * userAvatar;
@property (nonatomic, strong, readwrite) UIButton * loginBtn;
@property (nonatomic, strong, readwrite) UIButton * logoutBtn;

@property (nonatomic, strong, readwrite) LoginRAC_ViewModel * loginViewModel;

@end

@implementation LoginRAC_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"MVVM+RAC 登录页面";
    
    [self createView];
    
    [self bindViewModel];
}



/// binding viewModel
- (void)bindViewModel
{
    @weakify(self);
    
    // 添加观察者 监听属性值改变，如果值改变了，则刷新页面
    [RACObserve(self.loginViewModel, avatarUrlString) subscribeNext:^(NSString * avatarurlstring) {
        // SDWebimage
        [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:avatarurlstring] placeholderImage:[UIImage imageNamed:@"camera2"] options:SDWebImageRetryFailed];
    }];
    
    /***
     /// Fixed：rac_textSignal只有用户输入才有效，如果只是直接赋值 eg:self.inputView.phoneTextField.text = @"xxxx"  这样self.inputView.phoneTextField.rac_textSignal就不会触发的。
     /// 解决办法：利用 RACObserve 来观察self.inputView.phoneTextField.text的赋值办法即可
     /// 用户输入的情况 触发rac_textSignal
     /// 用户非输入而是直接赋值的情况 触发RACObserve
     
     RAC(self.viewModel , mobilePhone) = self.inputView.phoneTextField.rac_textSignal;
     **/
    RAC(self.loginViewModel, username) = [RACSignal merge:@[RACObserve(self.usernameTF, text), self.usernameTF.rac_textSignal]];
    RAC(self.loginViewModel, password) = [RACSignal merge:@[RACObserve(self.passwordTF, text), self.passwordTF.rac_textSignal]];
    
    // 按钮是否
    RAC(self.loginBtn, enabled) = self.loginViewModel.validLoginSignal;
    
    // 按钮点击 转化为 信号，并订阅这个信号
    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
      doNext:^(__kindof UIControl * _Nullable x) {
          @strongify(self);
          // 处理写其他操作，比如键盘下移
          [self.view endEditing:YES];
          [SVProgressHUD showMessage:@"正在请求..."];
      }] subscribeNext:^(__kindof UIControl * _Nullable x) {
          @strongify(self);
//          [self.loginViewModel.loginCommond execute:nil];
//          [self.loginViewModel.loginCommond executionSignals];
          [self.loginViewModel.loginCommond execute:@{@"account":_usernameTF.text,@"password":_passwordTF.text}];
      }];

    [[self.loginViewModel.loginCommond.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            NSLog(@"正在执行中……");
        }else{
            NSLog(@"执行结束了");
        }
    }];


    // 数据请求成功
    [self.loginViewModel.loginCommond.executionSignals.switchToLatest
     subscribeNext:^(id x) {
         @strongify(self);
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

             [SVProgressHUD hideHUD];
             [SVProgressHUD showSuccess:@"请求成功"];

             NSLog(@"请求成功");
         });
     }];

/* switchToLatest的作用，上面代码等价于下面代码
    [[self.loginViewModel.loginCommond executionSignals]
     subscribeNext:^(RACSignal *x) {
         [x subscribeNext:^(id x) {
             //  Do something...

             NSLog(@"请求成功");
         }];
     }];
 */

    // 数据请求失败
    [self.loginViewModel.loginCommond.errors subscribeNext:^(NSError * error) {
        if ([error.domain isEqualToString:@"CommandErrorDomain"]) {
            [SVProgressHUD hideHUD];
            [SVProgressHUD showError:@"请求成功"];
            NSLog(@"请求失败");
            return ;
        }
    }];
    
}


#pragma mark - de

-(void)createView {
    // add
    [self.view addSubview:self.userAvatar];
    [self.userAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@50);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(25);
    }];
    
    [self.view addSubview:self.usernameTF];
    [self.usernameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.8);
        make.height.equalTo(@50);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
    }];
    
    [self.view addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.8);
        make.height.equalTo(@50);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.usernameTF.mas_bottom).offset(20);
    }];
    
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.8);
        make.height.equalTo(@50);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.passwordTF.mas_bottom).offset(20);
    }];
}


#pragma mark - touchesBegan

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - Lazy init

-(UIImageView *)userAvatar {
    if (!_userAvatar) {
        _userAvatar = [[UIImageView alloc] init];
        _userAvatar.backgroundColor = [UIColor grayColor];
    }
    return _userAvatar;
}

-(UITextField *)usernameTF {
    if (!_usernameTF) {
        _usernameTF = [[UITextField alloc] init];
        _usernameTF.borderStyle = UITextBorderStyleLine;
        _usernameTF.placeholder = @"输入user，有惊喜";
    }
    return _usernameTF;
}

-(UITextField *)passwordTF {
    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc] init];
        _passwordTF.borderStyle = UITextBorderStyleLine;
        _passwordTF.placeholder = @"输入password，有惊喜";
    }
    return _passwordTF;
}

-(UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:@"sign in" forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[self createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [_loginBtn setBackgroundImage:[self createImageWithColor:[UIColor greenColor]] forState:UIControlStateNormal];
        _loginBtn.enabled = NO;
    }
    return _loginBtn;
}

-(LoginRAC_ViewModel *)loginViewModel {
    if (!_loginViewModel) {
        _loginViewModel = [LoginRAC_ViewModel new];
    }
    return _loginViewModel;
}

#pragma mark - Private Method
// 根据颜色获取图片
- (UIImage *)createImageWithColor:(UIColor *)color
{
    //图片尺寸
    CGRect rect = CGRectMake(0, 0, 10, 10);
    //填充画笔
    UIGraphicsBeginImageContext(rect.size);
    //根据所传颜色绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    //显示区域
    CGContextFillRect(context, rect);
    // 得到图片信息
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //消除画笔
    UIGraphicsEndImageContext();
    return image;
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
