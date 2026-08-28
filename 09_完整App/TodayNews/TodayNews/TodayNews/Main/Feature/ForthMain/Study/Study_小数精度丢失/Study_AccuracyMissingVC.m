//
//  Study_AccuracyMissingVC.m
//  TodayNews
//
//  Created by linxiang on 2018/4/24.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_AccuracyMissingVC.h"

@interface Study_AccuracyMissingVC ()

@end

@implementation Study_AccuracyMissingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LXRandomColor;
    
    [self test1];
    
    [self test2];

    [self test3];
    
    [self test4];
    
    [self Size];
    
    // float 四舍五入
    [self floatnumToNew];
}

-(void)Size {
    size_t charSize = sizeof(char);
    NSLog(@"charSize = %zu", charSize);
    
    size_t shortSize = sizeof(short);
    NSLog(@"shortSize = %zu", shortSize);
    
    size_t NSIntegerSize = sizeof(NSInteger);
    NSLog(@"NSIntegerSize = %zu", NSIntegerSize);
    
    size_t intSize = sizeof(int);
    NSLog(@"intSize = %zu", intSize);
    
    size_t longSize = sizeof(long);
    NSLog(@"longSize = %zu", longSize);
    
    size_t floatSize = sizeof(float);
    NSLog(@"floatSize = %zu", floatSize);
    
    size_t doubleSize = sizeof(double);
    NSLog(@"doubleSize = %zu", doubleSize);
}

/**
 NSString 转 float
 */
-(void)test1 {
    NSString *test = @"34.0";
    NSString *test1 = @"34.1";
    
    float testFloat = [test floatValue];//testFloat = 34
    float testFloat1 = [test1 floatValue];//testFloat1 = 34.099998
    
    LXLog(@"AA = %f",testFloat);
    LXLog(@"BB = %f",testFloat1);
    LXLog(@"CC = %.12f",testFloat1);
    
/* Log
    AA = 34.000000
    BB = 34.099998
    CC = 34.099998474121
*/
}


/**
 NSNumber 转 NSString
 */
-(void)test2 {
    NSNumber * number = @8.2;
    
    NSString * str = number.stringValue;
    
    LXLog(@"DD = %@",str);
/*
 DD = 8.199999999999999
 */
}

-(void)test3 {
    double firstD = 11111.7;
    double secondD = 22222.6;
    
    NSString * firstDStr = [NSString stringWithFormat:@"%0.2f",firstD];
    NSString * secondDStr = [NSString stringWithFormat:@"%0.2f",secondD];
    
    LXLog(@"EE = %@ == %@",firstDStr,secondDStr);
    
    double f = [firstDStr doubleValue];
    double s = [secondDStr doubleValue];
    
    LXLog(@"FF = %f == %f",f,s);

    LXLog(@"GG = %.12f == %.12f",f,s);
    
/* Log
 EE = 11111.70 == 22222.60
 FF = 11111.700000 == 22222.600000
 GG = 11111.700000000001 == 22222.599999999999
 */
    
}


/**
 一道测试题，补码
 */
-(void)test4 {
    unsigned char ch = -1;
    
    int val = ch;
    
    LXLog(@"%d",val);
    
    
    int AA = 20;
    int BB = -20;  // int 4 byte  1byte = 8bit     4byte = 32bit   32bit/4 = 8个十六进制数
    
    LXLog(@"%x %x",AA,BB);

/* Log
 255
 14 ffffffec
 */
    
    
    char a = 'a';
    NSLog(@"%x",a);
    //char 型变量 c = ‘a’，字符’a’对应的ASCALL编码是97，则它可以用二进制表示为 0110 0001 = OX61
/* Log
 61
 */
    
    char b = 'A';
    NSLog(@"%x",b);
    
}



#pragma mark - float保留2位小数

-(void)floatnumToNew {
    float A = 0.124000;
    float B = 0.124200;
    float C = 0.125000;
    float D = 0.125001;
    float E = 0.126000;
    
    // 方法一
    NSString * showA = [NSString stringWithFormat:@"%0.2f",A];
    NSString * showB = [NSString stringWithFormat:@"%0.2f",B];
    NSString * showC = [NSString stringWithFormat:@"%0.2f",C];
    NSString * showD = [NSString stringWithFormat:@"%0.2f",D];
    NSString * showE = [NSString stringWithFormat:@"%0.2f",E];
    NSLog(@"\n A = %@ \n B = %@ \n C = %@ \n D = %@ \n E = %@",showA,showB,showC,showD,showE);
    
    // 方法二：NSDecimalNumber
    /*
     枚举
     NSRoundPlain,   // Round up on a tie ／／貌似取整 翻译出来是个圆 吗的垃圾百度翻译
     NSRoundDown,    // Always down == truncate  ／／只舍不入
     NSRoundUp,      // Always up    ／／ 只入不舍
     NSRoundBankers  // on a tie round so last digit is even  貌似四舍五入
     */
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                                                                                      scale:2
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:YES];
    NSDecimalNumber * ouncesDecimalA = [[NSDecimalNumber alloc] initWithFloat:A];
    NSDecimalNumber * roundedOuncesA = [ouncesDecimalA decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString * showA_2 = [NSString stringWithFormat:@"%@",roundedOuncesA];
    
    NSDecimalNumber * ouncesDecimalB = [[NSDecimalNumber alloc] initWithFloat:B];
    NSDecimalNumber * roundedOuncesB = [ouncesDecimalB decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString * showB_2 = [NSString stringWithFormat:@"%@",roundedOuncesB];
    
    NSDecimalNumber * ouncesDecimalC = [[NSDecimalNumber alloc] initWithFloat:C];
    NSDecimalNumber * roundedOuncesC = [ouncesDecimalC decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString * showC_2 = [NSString stringWithFormat:@"%@",roundedOuncesC];
    
    NSDecimalNumber * ouncesDecimalD = [[NSDecimalNumber alloc] initWithFloat:D];
    NSDecimalNumber * roundedOuncesD = [ouncesDecimalD decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString * showD_2 = [NSString stringWithFormat:@"%@",roundedOuncesD];
    
    NSDecimalNumber * ouncesDecimalE = [[NSDecimalNumber alloc] initWithFloat:E];
    NSDecimalNumber * roundedOuncesE = [ouncesDecimalE decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString * showE_2 = [NSString stringWithFormat:@"%@",roundedOuncesE];
    NSLog(@"\n A = %@ \n B = %@ \n C = %@ \n D = %@ \n E = %@",showA_2,showB_2,showC_2,showD_2,showE_2);

    
    // 方法三：自带函数 round
    NSString * showA_3 = [NSString stringWithFormat:@"%0.2f",roundf(A * 100)/100];
    NSString * showB_3 = [NSString stringWithFormat:@"%0.2f",roundf(B * 100)/100];
    NSString * showC_3 = [NSString stringWithFormat:@"%0.2f",roundf(C * 100)/100];
    NSString * showD_3 = [NSString stringWithFormat:@"%0.2f",roundf(D * 100)/100];
    NSString * showE_3 = [NSString stringWithFormat:@"%0.2f",roundf(E * 100)/100];
    NSLog(@"\n A = %@ \n B = %@ \n C = %@ \n D = %@ \n E = %@",showA_3,showB_3,showC_3,showD_3,showE_3);
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
