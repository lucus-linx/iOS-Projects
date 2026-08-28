//
//  LoginRAC_ViewModel.m
//  TodayNews
//
//  Created by 林祥 on 2019/3/12.
//  Copyright © 2019 LX. All rights reserved.
//

#import "LoginRAC_ViewModel.h"

@interface LoginRAC_ViewModel()

/// 按钮能否点击
@property (nonatomic, strong, readwrite) RACSignal * validLoginSignal;
/// 登录按钮点击执行的命令
@property (nonatomic, strong, readwrite) RACCommand * loginCommond;

@end


@implementation LoginRAC_ViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    @weakify(self);
    
    RAC(self, avatarUrlString) = [[RACObserve(self, username)
                                   map:^NSString *(NSString * username) {
                                       // 1.验证username合法性，有没有其他字符
                                       if ([username isEqualToString:@"user"]) {
                                           // 2.根据username从数据库获取用户头像数据
                                           return @"https://ss0.baidu.com/73F1bjeh1BF3odCf/it/u=1331072331,4134051125&fm=85&s=08A2DD172EF73A820C2CE82F0300E060";
                                       } else {
                                           return nil;
                                       }
                                   }] distinctUntilChanged]; // 忽略重复信号
    
    
    // 按钮能否点击
    _validLoginSignal = [[RACSignal
                          combineLatest:@[RACObserve(self, username), RACObserve(self, password)]
                          reduce:^id (NSString * username, NSString * password) {
                              if ([username isEqualToString:@"user"] && [password isEqualToString:@"password"]) {
                                  return @(YES);
                              }else {
                                  return @(NO);
                              }
                          }] distinctUntilChanged];   // 忽略重复信号
    
    // 点击登录按钮命令
    _loginCommond = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        
        NSLog(@"组合参数，准备发送登录请求 - %@",input);
        
        if (self.username.length < 2) {
            return [RACSignal error:[NSError errorWithDomain:@"CommandErrorDomain" code:9527 userInfo:@{@"errorkey":@"请输入正确的码"}]];
        }
        
        // 方法一： 直接调用网络接口
//        return [self loginWithUserName:self.username password:self.password];
        
        // 方法二：
        @weakify(self);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#if 1
                // 成功
                [subscriber sendNext:[NSString stringWithFormat:@"User %@, password %@, login!", self.username, self.password]];
                // 必须sendCompleted 否则command.executing一直为1 导致HUD 一直 loading
                [subscriber sendCompleted];
                return [RACDisposable disposableWithBlock:^{
                    NSLog(@"结束了");
                }];
#else
                // 失败
                [subscriber sendError:[NSError errorWithDomain:@"CommandErrorDomain" code:9527 userInfo:@{@"errorkey":@"请输入正确的码"}]];
#endif
//            });
            return nil;
        }];
    }];
    
}



- (RACSignal *)loginWithUserName:(NSString *) name password:(NSString *)password
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:[NSString stringWithFormat:@"User %@, password %@, login!",name, password]];
            [subscriber sendCompleted];
        });
        return nil;
    }];
}


@end
