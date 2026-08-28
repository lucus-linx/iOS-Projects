//
//  Study_BlockVC.m
//  TodayNews
//
//  Created by linxiang on 2018/6/27.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_BlockVC.h"

@interface Study_BlockVC ()


@end

@implementation Study_BlockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"bloacks";
    self.view.backgroundColor = LXRandomColor;

    
    [self get_value];
    
    [self change_value_by___block];
    
    [self change_value_by___block_1];
    
    [self change_value_by___block_2];
    
    [self get_OC_object];
}


#pragma mark - Block类型变量 与 C语言变量
// C 函数
int func(int count) {
    return count+1;
}

-(void)block_and_C_test {
    // 函数func的地址赋值给 函数指针类型变量 funcptr中
    int (*funcptr)(int) = &func;
    
    // 定义一个Block类型变量
    int (^blk)(int);
    // 将block语法生成的block赋值给Block类型变量
    blk = ^(int count) { return count + 1; };
    
    // typedef简化block类型变量
    typedef int (^blk_1)(int);
    
// C语言的函数指针 与 Block类型变量中的block方法
    // 可见：通过Block类型变量调用block 与 C语言通常的函数调用没有区别。
    int result_C = (*funcptr)(10);
    int result_block = blk(10);
    
    
// 指向Block类型变量的指针
    typedef int(^blk_t)(int);  // 别名
    blk_t blk_a = ^(int count){ return count + 1; };
    blk_a(10);
}



#pragma mark - 截取自动变量值
// 截取自动变量
-(void)get_value {
    int val = 10;
    NSLog(@"1. == %d",val);
    
    // block定义
    void (^blk)(void) = ^{
        NSLog(@"2. == %d",val);
    };
    
    // 修改值
    val = 2;
    NSLog(@"3. == %d",val);
    
    // block调用
    blk();
    NSLog(@"4. == %d",val);
}

// 使用__block修改自动变量值
-(void)change_value_by___block {
    __block int val = 1;
    void (^blk)(void) = ^{
        val = 2;
    };
    
    blk();
    NSLog(@"val = %d",val);
}

-(void)change_value_by___block_1 {
    __block int a = 0;
    NSLog(@"定义前：%p", &a);         //栈区
    void (^foo)(void) = ^{
        a = 1;
        NSLog(@"block内部：%p", &a);    //堆区
    };
    NSLog(@"定义后：%p", &a);         //堆区
    foo();
}

-(void)change_value_by___block_2 {
    
    __block NSMutableString *a = [NSMutableString stringWithString:@"Tom"];
    NSLog(@"定以前：指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);               //a在栈区
    
    void (^foo)(void) = ^{
        a.string = @"Jerry";
        NSLog(@"block内部：指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);       //a在栈区
        
#pragma mark - ERROR   Variable is not assignable (missing __block type specifier)
        //a = [NSMutableString stringWithString:@"William"];
    };
   
    foo();
    NSLog(@"定以后：指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);              //a在栈区
}

// 截取OC对象
-(void)get_OC_object {
    id array = [[NSMutableArray alloc] init];
    
    void (^blk)(void) = ^{
        id obj = [[NSObject alloc] init];
        [array addObject:obj];
    };
    
    blk();
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
