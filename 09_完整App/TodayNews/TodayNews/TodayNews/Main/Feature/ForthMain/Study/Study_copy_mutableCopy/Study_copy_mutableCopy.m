//
//  Study_copy_mutableCopy.m
//  TodayNews
//
//  Created by linxiang on 2018/8/17.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_copy_mutableCopy.h"

#import "Study_CustomObject_copy_mutableCopy.h"

@interface Study_copy_mutableCopy ()

@end

@implementation Study_copy_mutableCopy

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

// =======================
    //创建segmentControl 分段控件
    UISegmentedControl *segC = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0,50,SCREEN_WIDTH,50)];
    //添加小按钮
    [segC insertSegmentWithTitle:@"NSString的copy与mutableCopy" atIndex:0 animated:YES];
    [segC insertSegmentWithTitle:@"NSArray的copy与mutableCopy" atIndex:1 animated:YES];
    //设置样式
    [segC setTintColor:[UIColor grayColor]];
    //设置字体样式
    [segC setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    //添加事件
    [segC addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segC];
    
// =======================
    //创建segmentControl 分段控件
    UISegmentedControl *segC1 = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0,150,SCREEN_WIDTH,50)];
    //添加小按钮
    [segC1 insertSegmentWithTitle:@"容器浅拷贝" atIndex:0 animated:YES];
    [segC1 insertSegmentWithTitle:@"单层深拷贝" atIndex:1 animated:YES];
    [segC1 insertSegmentWithTitle:@"双层深拷贝" atIndex:2 animated:YES];
    [segC1 insertSegmentWithTitle:@"完全深拷贝:归档解档" atIndex:3 animated:YES];
    [segC1 insertSegmentWithTitle:@"完全深拷贝:系统自带方法" atIndex:4 animated:YES];
    //设置样式
    [segC1 setTintColor:[UIColor grayColor]];
    //设置字体样式
    [segC1 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    //添加事件
    [segC1 addTarget:self action:@selector(segmentValueChanged1:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segC1];
    
// =======================
    //创建segmentControl 分段控件
    UISegmentedControl *segC2 = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0,250,SCREEN_WIDTH,50)];
    //添加小按钮
    [segC2 insertSegmentWithTitle:@"自定义对象拷贝、深拷贝" atIndex:0 animated:YES];
    [segC2 insertSegmentWithTitle:@"未使用" atIndex:1 animated:YES];
    [segC2 insertSegmentWithTitle:@"未使用" atIndex:2 animated:YES];
    
    //设置样式
    [segC2 setTintColor:[UIColor grayColor]];
    //设置字体样式
    [segC2 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    //添加事件
    [segC2 addTarget:self action:@selector(segmentValueChanged2:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segC2];
}


//点击按钮事件
-(void)segmentValueChanged:(UISegmentedControl *)seg{
    NSUInteger segIndex = [seg selectedSegmentIndex];
    //将当旧VC的view移除，然后在添加新VC的view
    if (segIndex == 0) {
        [self NSStringCopyAndMutableCopy];
    }else if (segIndex == 1){
        [self NSArrayCopyAndMutableCopy];
    }else{
    }
}

-(void)segmentValueChanged1:(UISegmentedControl *)seg{
    NSUInteger segIndex = [seg selectedSegmentIndex];
    //将当旧VC的view移除，然后在添加新VC的view
    if (segIndex == 0) {
        [self shallowCopy];
    }else if (segIndex == 1){
        [self one_deep_copy];
    }else if (segIndex == 2){
        [self two_deep_copy];
    }else if (segIndex == 3){
        [self all_depp_copy_1];
    }else if (segIndex == 4){
        [self all_deep_copy_2];
    }else{
    }
}

-(void)segmentValueChanged2:(UISegmentedControl *)seg{
    NSUInteger segIndex = [seg selectedSegmentIndex];
    //将当旧VC的view移除，然后在添加新VC的view
    if (segIndex == 0) {
        [self CustomObject_copy_mutableCopy];
    }else if (segIndex == 1){

    }else if (segIndex == 2){

    }else{
    }
}

// #pragma mark - NSString、NSMutableString、NSArray、NSMutableArray分别进行copy和mutableCopy时的情况

#pragma mark - 1.系统的非容器类对象

-(void)NSStringCopyAndMutableCopy {
    // const是常量字符串,存在常量区
    // constStr指针存在栈区, 指针指向常量区
    NSString * constStr = @"const";
    NSString * constStrCopy = [constStr copy];
    NSMutableString * constStrMutableCopy = [constStr mutableCopy];
    NSLog(@"constStr = %p",constStr);
    NSLog(@"constStrCopy = %p",constStrCopy);
    NSLog(@"constStrMutableCopy = %p",constStrMutableCopy);

    // originStr在栈中,指向堆区的地址
    NSString * originStr = [NSString stringWithFormat:@"origin"];
    NSString * originStrCopy = [originStr copy];
    NSMutableString * originStrMutableCopy = [originStr mutableCopy];
    NSLog(@"originStr = %p",originStr);
    NSLog(@"originStrCopy = %p",originStrCopy);
    NSLog(@"originStrMutableCopy = %p",originStrMutableCopy);
    
    NSMutableString *mutableOriginStr = [NSMutableString stringWithFormat:@"mutableOrigin"];
    NSMutableString *mutableOriginStrCopy = [mutableOriginStr copy];
    NSMutableString *mutableOriginStrMutableCopy = [mutableOriginStr mutableCopy];
    NSLog(@"mutableOriginStr = %p",mutableOriginStr);
    NSLog(@"mutableOriginStrCopy = %p",mutableOriginStrCopy);
    NSLog(@"mutableOriginStrMutableCopy = %p",mutableOriginStrMutableCopy);
    
    
    [constStrMutableCopy appendString:@"const"];
    
    [originStrMutableCopy appendString:@"origin"];

#pragma warnning - ERROR
    //[mutableOriginStrCopy appendString:@"mm"];   // ERROR
}


#pragma mark - 2.系统的容器类对象
// 指NSArray，NSDictionary等。
-(void)NSArrayCopyAndMutableCopy {
    NSArray * arr = [NSArray arrayWithObjects:
                     [NSMutableString stringWithString:@"one"],
                     [NSMutableString stringWithString:@"two"],
                     [NSMutableString stringWithString:@"three"],
                     [NSMutableString stringWithString:@"four"],nil];
    NSArray * arrcopy = [arr copy];
    NSMutableArray * arrmutablecopy = [arr mutableCopy];
    NSLog(@"arr = %p = %p",arr,arr[0]);
    NSLog(@"arrcopy = %p = %p",arrcopy,arrcopy[0]);
    NSLog(@"arrmutablecopy = %p = %p",arrmutablecopy,arrmutablecopy[0]);

    NSMutableString * mStr;
    mStr = arr[0];
    [mStr appendString:@"--array"];

    NSLog(@"改变内部元素后 arr：%@ = %p",arr,arr[0]);
    NSLog(@"改变内部元素后 arrcopy：%@ = %p",arrcopy,arrcopy[0]);
    NSLog(@"改变内部元素后 arrmutablecopy：%@ = %p",arrmutablecopy,arrmutablecopy[0]);


    
    NSMutableArray *mutableArr = [NSMutableArray arrayWithObjects:
                                  [NSMutableString stringWithString:@"abc"],
                                  [NSMutableString stringWithString:@"def"],
                                  [NSMutableString stringWithString:@"ghi"],
                                  [NSMutableString stringWithString:@"jkl"], nil];
    NSArray * mutableArrcopy = [mutableArr copy];
    NSMutableArray * mutableArrmutablecopy = [mutableArr mutableCopy];
    NSLog(@"mutableArr = %p = %p",mutableArr,mutableArr[0]);
    NSLog(@"mutableArrcopy = %p = %p",mutableArrcopy,mutableArrcopy[0]);
    NSLog(@"mutableArrmutablecopy = %p = %p",mutableArrmutablecopy,mutableArrmutablecopy[0]);
    
    NSMutableString * mStr1;
    mStr1 = mutableArr[0];
    [mStr1 appendString:@"--mutablearray"];
    
    [mutableArrmutablecopy addObject:@"FFF"];
    
    NSLog(@"改变内部元素后 mutableArr：%@ = %p",mutableArr,mutableArr[0]);
    NSLog(@"改变内部元素后 mutableArrcopy：%@ = %p",mutableArrcopy,mutableArrcopy[0]);
    NSLog(@"改变内部元素后 mutableArrmutablecopy：%@ = %p",mutableArrmutablecopy,mutableArrmutablecopy[0]);
}



#pragma mark - 容器 浅copy

-(void)shallowCopy {
    // 和NSString浅copy的验证步骤一样
    NSArray *arr = [NSArray arrayWithObjects:@"1", nil];
    NSArray *copyArr = [arr copy];
    
    NSLog(@"%p", arr);
    NSLog(@"%p", copyArr);
}

#pragma mark - 容器 单层深拷贝

-(void)one_deep_copy {
    NSArray *arr = [NSArray arrayWithObjects:@"1", nil];
    NSArray *copyArr = [arr mutableCopy];
    
    NSLog(@"%p", arr);
    NSLog(@"%p", copyArr);
    
    // 打印arr、copyArr内部元素进行对比
    NSLog(@"%p", arr[0]);
    NSLog(@"%p", copyArr[0]);
}


#pragma mark - 容器 双层深copy
// 这里的双层指的是完成了NSArray对象和NSArray容器内对象的深copy（为什么不说完全，是因为无法处理NSArray中还有一个NSArray这种情况）。
-(void)two_deep_copy {
    // 随意创建一个NSMutableString对象
    NSMutableString *mutableString = [NSMutableString stringWithString:@"1"];
    // 随意创建一个包涵NSMutableString的NSMutableArray对象
    NSMutableString *mutalbeString1 = [NSMutableString stringWithString:@"1"];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithObjects:mutalbeString1, nil];
    // 将mutableString和mutableArr放入一个新的NSArray中
    NSArray *testArr = [NSArray arrayWithObjects:mutableString, mutableArr, nil];
    // 通过官方文档提供的方式创建copy
    NSArray *testArrCopy = [[NSArray alloc] initWithArray:testArr copyItems:YES];
    
    // testArr和testArrCopy指针对比
    NSLog(@"%p", testArr);
    NSLog(@"%p", testArrCopy);
    
    // testArr和testArrCopy中元素指针对比
    // mutableString对比
    NSLog(@"%p", testArr[0]);
    NSLog(@"%p", testArrCopy[0]);
    // mutableArr对比
    NSLog(@"%p", testArr[1]);
    NSLog(@"%p", testArrCopy[1]);
    
    // mutableArr中的元素对比，即mutalbeString1对比
    NSLog(@"%p", testArr[1][0]);
    NSLog(@"%p", testArrCopy[1][0]);
}


#pragma mark - 容器 完全深copy

-(void)all_depp_copy_1 {
    // 随意创建一个NSMutableString对象
    NSMutableString *mutableString = [NSMutableString stringWithString:@"1"];
    // 随意创建一个包涵NSMutableString的NSMutableArray对象
    NSMutableString *mutalbeString1 = [NSMutableString stringWithString:@"1"];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithObjects:mutalbeString1, nil];
    // 将mutableString和mutableArr放入一个新的NSArray中
    NSArray *testArr = [NSArray arrayWithObjects:mutableString, mutableArr, nil];
    // 通过归档、解档方式创建copy
    NSArray *testArrCopy = [NSKeyedUnarchiver unarchiveObjectWithData:
                            [NSKeyedArchiver archivedDataWithRootObject:testArr]];;
    
    // testArr和testArrCopy指针对比
    NSLog(@"%p", testArr);
    NSLog(@"%p", testArrCopy);
    
    // testArr和testArrCopy中元素指针对比
    // mutableString对比
    NSLog(@"%p", testArr[0]);
    NSLog(@"%p", testArrCopy[0]);
    // mutableArr对比
    NSLog(@"%p", testArr[1]);
    NSLog(@"%p", testArrCopy[1]);
    
    // mutableArr中的元素对比，即mutalbeString1对比
    NSLog(@"%p", testArr[1][0]);
    NSLog(@"%p", testArrCopy[1][0]);
}


-(void)all_deep_copy_2 {
    NSMutableArray *marry1 = [[NSMutableArray alloc] init];
    
    NSMutableString *mstr1 = [[NSMutableString alloc]initWithString:@"value1"];
    NSMutableString *mstr2 = [[NSMutableString alloc]initWithString:@"value2"];
    
    [marry1 addObject:mstr1];
    [marry1 addObject:mstr2];
    
    NSArray *marray2 = [[NSArray alloc] initWithArray:marry1 copyItems:YES];
    
    NSLog(@"marry1:%p - %@ \r\n",marry1,marry1);
    NSLog(@"marry2:%p - %@ \r\n",marray2,marray2);
    NSLog(@"数组元素地址:value1:%p - value2:%p \r\n",marry1[0],marry1[1]);
    NSLog(@"数组元素地址:value1:%p - value2:%p \r\n",marray2[0],marray2[1]);
}


#pragma mark - 3. 自定义对象copy mutableCopy

-(void)CustomObject_copy_mutableCopy {
    
    Study_CustomObject_copy_mutableCopy *object = [[Study_CustomObject_copy_mutableCopy alloc]init];
    object.age = @"99";
    object.name = @"lionsom";
    
    Study_CustomObject_copy_mutableCopy *objectCopy = [object copy];
    Study_CustomObject_copy_mutableCopy *objectMutableCopy = [object mutableCopy];
    
    NSLog(@"object === %p , name === %p , age === %p",object, object.name, object.age);
    NSLog(@"objectCopy === %p , name === %p , age === %p",objectCopy, objectCopy.name, objectCopy.age);
    NSLog(@"objectMutableCopy === %p , name === %p , age === %p",objectMutableCopy, objectMutableCopy.name, objectMutableCopy.age);
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
