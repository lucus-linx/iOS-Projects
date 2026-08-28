//
//  Study_KVC_VC.m
//  TodayNews
//
//  Created by linxiang on 2019/4/2.
//  Copyright © 2019年 LX. All rights reserved.
//

#import "Study_KVC_VC.h"

#import "KVCPerson.h"
#import "KVCStudent.h"

@interface Study_KVC_VC ()

@property (nonatomic, strong) KVCPerson *myperson;

@end

@implementation Study_KVC_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"KVC使用与理解";
    self.view.backgroundColor = [UIColor whiteColor];

    _myperson = [[KVCPerson alloc] init];
    
    // KVC 基本使用
    [self baseUSE];

}


// 基本使用，存取
-(void)baseUSE {
// 1 setValue: forKey: 赋值
    [_myperson setValue:@1 forKey:@"A"];
    [_myperson setValue:@(2) forKey:@"B"];
        KVCStudent * s = [KVCStudent new];
        [s setValue:@"lin" forKey:@"name"];
        [s setValue:@(26) forKey:@"age"];
    [_myperson setValue:s forKey:@"C"];
    [_myperson setValue:@[@"1",@"3"] forKey:@"D"];
    
    NSLog(@"myperson A = %ld",(long)_myperson.A);
    NSLog(@"myperson B = %@", _myperson.B);
    NSLog(@"myperson C = %@ %@ %ld", _myperson.C, _myperson.C.name, (long)_myperson.C.age);
    NSLog(@"myperson D = %@", _myperson.D);
    
    
// 2 setValue: forKeyPath: 对更深层次的对象赋值
    // [_myperson setValue:@"new name" forKey:@"C.name"];    崩溃
    [_myperson setValue:@"newname" forKeyPath:@"C.name"];
    
    NSLog(@"myperson C = %@ %@ %ld", _myperson.C, _myperson.C.name, (long)_myperson.C.age);
    
    
// 3 valueForKey: 取值
    NSLog(@"valueForKey A = %@",[_myperson valueForKey:@"A"]);
    NSLog(@"valueForKey B = %@",[_myperson valueForKey:@"B"]);
    NSLog(@"valueForKey C = %@",[_myperson valueForKey:@"C"]);
    NSLog(@"valueForKey D = %@",[_myperson valueForKey:@"D"]);
    
    
// 4 valueForKeyPath: 取值
    NSLog(@"valueForKeyPath A = %@",[_myperson valueForKeyPath:@"C.name"]);
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
