//
//  HowToUseRAC_VC.m
//  TodayNews
//
//  Created by linxiang on 2019/3/12.
//  Copyright © 2019年 LX. All rights reserved.
//

#import "HowToUseRAC_VC.h"

#import "RWDummySignInService.h"

@interface HowToUseRAC_VC ()

@property (nonatomic, strong) UITextField * usernameTF;
@property (nonatomic, strong) UITextField * passwordTF;

@property (nonatomic, strong) UIButton * loginBtn;

@property (strong, nonatomic) RWDummySignInService *signInService;

@end

@implementation HowToUseRAC_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"RAC - UITextField";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // init
    self.signInService = [RWDummySignInService new];
    
    // add
    [self.view addSubview:self.usernameTF];
    [self.usernameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.8);
        make.height.equalTo(@50);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
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
    

    // textfield demo
    [self textfield_filter_demo];
    [self textfield_map_filter_demo];
    [self textfeild_validstate_demo];
    [self textfield_Combining_signals_demo];
    // 按钮点击
    [self loginBtn_click_demo];
}


#pragma mark - RAC+UITextField demo

-(void)textfield_filter_demo {
    // ReactiveCocoa有大量的操作符，您可以使用它们来操作事件流。
    // 例如，假设您只对长度超过三个字符的用户名感兴趣。您可以使用filter操作符来实现这一点。
    /*
     // 过滤器，返回一个信号
     - (RACSignal<ValueType> *)filter:(BOOL (^)(ValueType _Nullable value))block RAC_WARN_UNUSED_RESULT;
     
     简单的流程图
     length>3
     rac_textSignal --> filter --> subscribeNext
     
     在上面的图中，您可以看到rac_textSignal是事件的初始源。数据流经一个过滤器，该过滤器只允许事件在包含长度大于3的字符串时通过。管道中的最后一步是subscribeNext:您的块在其中记录事件值。
     */
    [[self.usernameTF.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        NSString *text = value;
        return text.length > 3;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    // 此时，值得注意的是过滤器操作的输出也是一个RACSignal。您可以按照如下方式排列代码，以显示离散的管道步骤:
    RACSignal *usernameTFSignal = self.usernameTF.rac_textSignal;
    
    RACSignal *filteredUsername = [usernameTFSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 3;
    }];
    [filteredUsername subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

-(void)textfield_map_filter_demo {
    /*
     // 将map中的block映射到接收器中，并返回一个带有映射值的新信号。
     - (RACSignal *)map:(id _Nullable (^)(ValueType _Nullable value))block RAC_WARN_UNUSED_RESULT;
     
     简单流程图
     rac_textSignal --> map --> filter --> subscribeNext
     ------NSString------> ---------NSNumber------>
     */
    [[[self.usernameTF.rac_textSignal map:^id _Nullable(NSString * value) {
        return @(value.length);          // 1.map中返回想要的值
    }] filter:^BOOL(NSNumber * value) {
        return [value integerValue] > 3; // 2.对map返回值进行过滤
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);                 // 3.输出符合过滤条件的map值
    }];
}

// 有效状态的信号
-(void)textfeild_validstate_demo {
    // 我们通过检测输入值，来验证内容是否合法有效
    /*
     简单的流程图
                   NSString      BOOL       UIColor
     rac_textSignal ------> map ------> map ------> subscribeNext
     */
    RACSignal *validUsernameSignal = [self.usernameTF.rac_textSignal map:^id(NSString *text) {
        if ([text isEqualToString:@"user"]) {
            return [NSNumber numberWithBool:YES];
        } else {
            return [NSNumber numberWithBool:NO];
        }
    }];
    [[validUsernameSignal map:^id(NSNumber *value) {
        return [value boolValue] ? [UIColor greenColor] : [UIColor redColor];
    }] subscribeNext:^(UIColor *color) {
        self.usernameTF.textColor = color;
    }];
    
    
    RACSignal *validPasswordSignal = [self.passwordTF.rac_textSignal map:^id(NSString *text) {
        if ([text isEqualToString:@"password"]) {
            return [NSNumber numberWithBool:YES];
        } else {
            return [NSNumber numberWithBool:NO];
        }
    }];
    RAC(self.passwordTF, textColor) = [validPasswordSignal map:^id(NSNumber *value) {
        return [value boolValue] ? [UIColor greenColor] : [UIColor redColor];
    }];
}

// 联合信号
-(void)textfield_Combining_signals_demo {
    /* 简单流程图
                              NSString      BOOL     UIColor
     usernameTF.rac_textSignal  ---- > map  ----> map ----> backgroundColor
                                        |
                                        |     把两个信号合成一个信号
                                        | --> combineLatest: reduce: --> subscribeNext
                                        |
                                        |
     passwordTF.rac_textSignal  ---- > map  ----> map ----> backgroundColor
     */

    RACSignal *validUsernameSignal = [self.usernameTF.rac_textSignal map:^id(NSString *text) {
        if ([text isEqualToString:@"user"]) {
            return [NSNumber numberWithBool:YES];
        } else {
            return [NSNumber numberWithBool:NO];
        }
    }];
    RACSignal *validPasswordSignal = [self.passwordTF.rac_textSignal map:^id(NSString *text) {
        if ([text isEqualToString:@"password"]) {
            return [NSNumber numberWithBool:YES];
        } else {
            return [NSNumber numberWithBool:NO];
        }
    }];
    /*
     上面的代码使用combineLatest:reduce:方法将validUsernameSignal和validPasswordSignal发出的最新值组合成一个闪亮的新信号。
     每当这两个源信号中的一个发出一个新值时，reduce块就会执行，它返回的值将作为组合信号的下一个值发送。
     */
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal,validPasswordSignal]
                                                      reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid) {
                                                          return @([usernameValid boolValue] && [passwordValid boolValue]);
                                                      }];
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        self.loginBtn.enabled = [signupActive boolValue];
    }];
}

-(void)loginBtn_click_demo {
// 进阶一：
/*
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"button clicked = %@",x);
    }];
*/
    
// 进阶二
    /* 简单流程图
                               UIButton    RACSignal
     rac_signalForControlEvents  ---->  map  ---->  subscribeNext
     */
/*
    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id (id x) {
        return [self signInSignal];
    }] subscribeNext:^(id x) {
        NSLog(@"button clicked = %@",x);
    }];
 */
    
// 进阶三
    /*
     flattenMap 与 map 区别 ？
     
     */
/*
    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
         return [self signInSignal];
    }]subscribeNext:^(NSNumber * value) {
        NSLog(@"button clicked = %@",value);
        BOOL success = [value boolValue];
        if (success) {
            NSLog(@"登录成功，跳转页面");
        }else {
            NSLog(@"登录失败");
        }
    }];
 */
    
// 进阶四
    /*
     donext 无返回值，只是辅助作用，它保持事件本身不变。
     
     简单流程图
                                doNext
                                   |
                                   | UIButton            RACSignal
     rac_signalForControlEvents  ---------->  flattenMap  ---->  subscribeNext
     */
    [[[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        // 登录过程中设置背景
        self.usernameTF.backgroundColor = [UIColor lightGrayColor];
        self.passwordTF.backgroundColor = [UIColor lightGrayColor];
        [SVProgressHUD showMessage:@"登录中..."];
    }] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
        // 这里将登录的请求进行信号化
        return [self signInSignal];
    }] subscribeNext:^(NSNumber * value) {
        [SVProgressHUD hideHUD];
        // 恢复
        self.usernameTF.backgroundColor = [UIColor whiteColor];
        self.passwordTF.backgroundColor = [UIColor whiteColor];
        
        NSLog(@"button clicked = %@",value);
        BOOL success = [value boolValue];
        if (success) {
            NSLog(@"登录成功，跳转页面");
        }else {
            NSLog(@"登录失败");
        }
    }];
}

#pragma mark - 登录按钮信号化

-(RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self.signInService signInWithUsername:self.usernameTF.text password:self.passwordTF.text complete:^(BOOL success) {
            [subscriber sendNext:[NSNumber numberWithBool:success]];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


#pragma mark - touchesBegan

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - Lazy init

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
    }
    return _loginBtn;
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
