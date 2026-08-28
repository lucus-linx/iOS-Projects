//
//  Study_Property_copy.m
//  TodayNews
//
//  Created by linxiang on 2018/10/24.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_Property_copy.h"

@interface Study_Property_copy ()

@property (nonatomic, strong) NSString *str1;
@property (nonatomic, copy) NSString *str2;

@property (nonatomic, strong) NSMutableString * mutablestr1;
@property (nonatomic, copy) NSMutableString * mutablestr2;

@property (nonatomic, strong) NSArray * arr1;
@property (nonatomic, copy) NSArray * arr2;

@property (nonatomic, strong) NSMutableArray * mutablearr1;
@property (nonatomic, copy) NSMutableArray * mutablearr2;

@end

@implementation Study_Property_copy

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];

    // 创建view
    [self createView];
}


#pragma mark - NSString -- Copy Strong

-(void)string_Strong {
    NSMutableString *mutableStr = [NSMutableString stringWithFormat:@"123"];
    self.str1 = mutableStr;
    [mutableStr appendString:@"456"];
    
    NSLog(@"NSString Strong修饰词 : 此时string和copystring的内存地址都是一样的，修改一个，两个就同时被修改");
    NSLog(@"%@ == %p", self.str1, self.str1);
    NSLog(@"%@ == %p", mutableStr, mutableStr);
}

-(void)string_Copy {
    NSMutableString *mutableStr = [NSMutableString stringWithFormat:@"123"];
    self.str2 = mutableStr;
    [mutableStr appendString:@"456"];
    
    NSLog(@"**推荐** NSString copy修饰词 : 此时string和copystring的内存地址都是不同的，修改一个，互不影响");
    NSLog(@"%@ == %p", self.str2, self.str2);
    NSLog(@"%@ == %p", mutableStr, mutableStr);
}


#pragma mark - NSMutableString -- Copy Strong

-(void)mutablestring_Strong {
    NSMutableString *mutableStr = [NSMutableString stringWithFormat:@"123"];
    self.mutablestr1 = mutableStr;
    [mutableStr appendString:@"456"];
    
    NSLog(@"**推荐** NSMutableString Strong修饰词 : 此时string和copystring的内存地址都是一样的，修改一个，两个就同时被修改");
    NSLog(@"%@ == %p", self.mutablestr1, self.mutablestr1);
    NSLog(@"%@ == %p", mutableStr, mutableStr);
}

-(void)mutablestring_Copy {
    NSMutableString *mutableStr = [NSMutableString stringWithFormat:@"123"];
    self.mutablestr2 = mutableStr;
    [self.mutablestr2 appendString:@"789"];
    [mutableStr appendString:@"456"];
    
    NSLog(@"**崩溃** NSMutableString Copy修饰词 : copy之后，就把变量string变成了不可变的NSString类型，对不可变的NSString使用了NSMutableString的方法appendString。");
    NSLog(@"%@ == %p", self.mutablestr2, self.mutablestr2);
    NSLog(@"%@ == %p", mutableStr, mutableStr);
}


#pragma mark - NSArray -- Copy Strong

-(void)array_Strong {
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    [mutableArray addObject:@"1"];
    
    self.arr1 = [NSArray array];
    self.arr1 = mutableArray;
    
    NSLog(@"**** NSArray Strong修饰词 : 此时内存地址都是一样的，修改一个，两个就同时被修改");
    NSLog(@"修改前 == %@ == %p", self.arr1, self.arr1);
    NSLog(@"修改前 == %@ == %p", mutableArray, mutableArray);
    
    [mutableArray addObject:@"2"];

    NSLog(@"修改后 == %@ == %p", self.arr1, self.arr1);
    NSLog(@"修改后 == %@ == %p", mutableArray, mutableArray);
}

-(void)array_Copy {
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    [mutableArray addObject:@"1"];
    
    self.arr2 = [NSArray array];
    self.arr2 = mutableArray;
    
    NSLog(@"**** NSArray Copy修饰词 : 此时内存地址都是不同的，修改一个，互不影响");
    NSLog(@"修改前 == %@ == %p", self.arr2, self.arr2);
    NSLog(@"修改前 == %@ == %p", mutableArray, mutableArray);
    
    [mutableArray addObject:@"2"];
    
    NSLog(@"修改后 == %@ == %p", self.arr2, self.arr2);
    NSLog(@"修改后 == %@ == %p", mutableArray, mutableArray);
}


#pragma mark - NSMutableArray -- Copy Strong

-(void)mutablearray_Strong {
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    [mutableArray addObject:@"1"];
    
    self.mutablearr1 = [NSMutableArray array];
    self.mutablearr1 = mutableArray;
    
    NSLog(@"**** NSMutableArray Strong修饰词 : 此时内存地址都是一样的，修改一个，两个就同时被修改");
    NSLog(@"修改前 == %@ == %p", self.mutablearr1, self.mutablearr1);
    NSLog(@"修改前 == %@ == %p", mutableArray, mutableArray);
    
    [mutableArray addObject:@"2"];
    
    NSLog(@"修改后 == %@ == %p", self.mutablearr1, self.mutablearr1);
    NSLog(@"修改后 == %@ == %p", mutableArray, mutableArray);
}

-(void)mutablearray_Copy {
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    [mutableArray addObject:@"1"];
    
    self.mutablearr2 = [NSMutableArray array];
    self.mutablearr2 = mutableArray;
    
    NSLog(@"**** NSMutableArray Copy修饰词 : 此时的内存地址都是不同的，修改一个，互不影响");
    NSLog(@"修改前 == %@ == %p", self.mutablearr2, self.mutablearr2);
    NSLog(@"修改前 == %@ == %p", mutableArray, mutableArray);
    
    [mutableArray addObject:@"2"];
    
    [self.mutablearr2 addObject:@"3"];
    
    NSLog(@"修改后 == %@ == %p", self.mutablearr2, self.mutablearr2);
    NSLog(@"修改后 == %@ == %p", mutableArray, mutableArray);
}



#pragma mark - createView

-(void)createView {
    
    //创建segmentControl 分段控件
    UISegmentedControl *segC = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0,50,SCREEN_WIDTH,50)];
    //添加小按钮
    [segC insertSegmentWithTitle:@"NSString - Strong" atIndex:0 animated:YES];
    [segC insertSegmentWithTitle:@"NSString - Copy（推荐）" atIndex:1 animated:YES];
    //设置样式
    [segC setTintColor:[UIColor grayColor]];
    //设置字体样式
    [segC setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    //添加事件
    [segC addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segC];
    
    
    //创建segmentControl 分段控件
    UISegmentedControl *segC1 = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0,150,SCREEN_WIDTH,50)];
    //添加小按钮
    [segC1 insertSegmentWithTitle:@"NSMutableString - Strong（推荐）" atIndex:0 animated:YES];
    [segC1 insertSegmentWithTitle:@"NSMutableString - Copy（崩溃）" atIndex:1 animated:YES];
    //设置样式
    [segC1 setTintColor:[UIColor grayColor]];
    //设置字体样式
    [segC1 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    //添加事件
    [segC1 addTarget:self action:@selector(segmentValueChanged1:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segC1];
    
    
    //创建segmentControl 分段控件
    UISegmentedControl *segC2 = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0,250,SCREEN_WIDTH,50)];
    //添加小按钮
    [segC2 insertSegmentWithTitle:@"NSString - Strong" atIndex:0 animated:YES];
    [segC2 insertSegmentWithTitle:@"NSString - Copy" atIndex:1 animated:YES];
    //设置样式
    [segC2 setTintColor:[UIColor grayColor]];
    //设置字体样式
    [segC2 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    //添加事件
    [segC2 addTarget:self action:@selector(segmentValueChanged2:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segC2];
    
    
    //创建segmentControl 分段控件
    UISegmentedControl *segC3 = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0,350,SCREEN_WIDTH,50)];
    //添加小按钮
    [segC3 insertSegmentWithTitle:@"NSString - Strong" atIndex:0 animated:YES];
    [segC3 insertSegmentWithTitle:@"NSString - Copy" atIndex:1 animated:YES];
    //设置样式
    [segC3 setTintColor:[UIColor grayColor]];
    //设置字体样式
    [segC3 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    //添加事件
    [segC3 addTarget:self action:@selector(segmentValueChanged3:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segC3];
}


#pragma mark - segment action

-(void)segmentValueChanged:(UISegmentedControl *)seg {
    NSUInteger segIndex = [seg selectedSegmentIndex];
    if (segIndex == 0) {
        [self string_Strong];
    }else if (segIndex == 1){
        [self string_Copy];
    }else{
    }
}

-(void)segmentValueChanged1:(UISegmentedControl *)seg {
    NSUInteger segIndex = [seg selectedSegmentIndex];
    if (segIndex == 0) {
        [self mutablestring_Strong];
    }else if (segIndex == 1){
        [self mutablestring_Copy];
    }else{
    }
}

-(void)segmentValueChanged2:(UISegmentedControl *)seg {
    NSUInteger segIndex = [seg selectedSegmentIndex];
    if (segIndex == 0) {
        [self array_Strong];
    }else if (segIndex == 1){
        [self array_Copy];
    }else{
    }
}

-(void)segmentValueChanged3:(UISegmentedControl *)seg {
    NSUInteger segIndex = [seg selectedSegmentIndex];
    if (segIndex == 0) {
        [self mutablearray_Strong];
    }else if (segIndex == 1){
        [self mutablearray_Copy];
    }else{
    }
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
