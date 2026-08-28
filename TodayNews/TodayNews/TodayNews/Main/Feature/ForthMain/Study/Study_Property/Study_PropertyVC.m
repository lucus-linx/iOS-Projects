//
//  Study_PropertyVC.m
//  TodayNews
//
//  Created by linxiang on 2018/7/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_PropertyVC.h"

@interface Study_PropertyVC ()

@end

@implementation Study_PropertyVC

@synthesize myTitle = _newtitle;

@synthesize myName = _myname;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LXRandomColor;
    
    _newtitle = @"AAAA";
    LXLog(@"title = %@",_newtitle);
    
    
    [self setMyTitle:@"BBBB"];
    LXLog(@"title = %@",self.myTitle);

    
    _myname = @"AAAAA";
    LXLog(@"自定义属性方法名 = %@",self.myName);

    self.myName = @"DDDDD";
    LXLog(@"自定义属性方法名 = %@",self.myName);

}

-(NSString *)show1 {
    return _myname;
}
-(void)show2:(NSString *)myName {
    _myname = [myName copy];
}


// 重写setter getter
- (NSString *)myTitle{
    return _newtitle;
}

- (void)setMyTitle:(NSString *)myTitle{
    _newtitle = myTitle;
}



-(id)initWithFirstName:(NSString *)firstName
                lastName:(NSString *)lastName {
    
    if (self = [super init]) {
        _firstName = [firstName copy];
        _lastName = [lastName copy];
    }
    
    return self;
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
