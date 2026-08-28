//
//  algorithm001_VC.m
//  TodayNews
//
//  Created by linxiang on 2018/12/17.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "algorithm001_VC.h"

@interface algorithm001_VC ()

@property (nonatomic, strong) NSArray * MapArr;

@property (nonatomic, strong) NSArray * DirectionArr;  // 四个方向

@property (nonatomic, strong) NSMutableArray  * BookArr;   // 标记已经走过的点

@property (nonatomic, strong) NSMutableArray  * PathArr;

// 初始点 和 终点
@property (nonatomic, assign) NSInteger Start_X;
@property (nonatomic, assign) NSInteger Start_Y;
@property (nonatomic, assign) NSInteger End_X;
@property (nonatomic, assign) NSInteger End_Y;

// 计算 Map 所有 * 点
@property (nonatomic, assign) NSInteger allSteps;

@end

static ALLFunc = 0;

@implementation algorithm001_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Deep Fisrt Search";
    self.view.backgroundColor = LXRandomColor;

/*
// 测试地图一
    // 设置出发点 和 终点
    _Start_X = 0;
    _Start_Y = 0;
    _End_X = 2;
    _End_Y = 0;
 */

/*
// 测试地图二
    _Start_X = 3;
    _Start_Y = 1;
 */
/*
// 测试地图三
    // 设置出发点 和 终点
    _Start_X = 1;
    _Start_Y = 1;
    _End_X = 3;
    _End_Y = 5;
*/
// 测试地图四
    _Start_X = 1;
    _Start_Y = 2;
    
    
    // 出发点做好标记
    [self.BookArr[_Start_X] replaceObjectAtIndex:_Start_Y withObject:@(1)];
    // 出发点加入路径中
    [self.PathArr addObject:@[@(_Start_X),@(_Start_Y)]];
    
    // 开始遍历
    [self dfs:_Start_X :_Start_Y :1];
    
    NSLog(@"所有的方法 = %d", ALLFunc);
}


/**
 当前坐标(tx,ty)
 
 @param step 总步数
 */
-(void)dfs:(NSInteger)tx :(NSInteger)ty :(NSInteger)step {
    // 如果成功了。也要返回
    if (step == self.allSteps /*&& tx == _End_X && ty == _End_Y*/) {
        NSLog(@"+++++++++++++ 成功！！！+++++++++++++");
        ALLFunc++;
        for (int j = 0; j < self.PathArr.count; j++) {
            NSMutableArray * objArr = self.PathArr[j];
            NSLog(@"[%@,%@]",objArr[0],objArr[1]);
        }
        return;
    }
    
    // 四个方向进行判断
    for (int i = 0; i <= 3; i++) {
        @autoreleasepool {
            // 下一步的点位
            NSInteger new_tx = tx + [self.DirectionArr[i][0] integerValue];
            NSInteger new_ty = ty + [self.DirectionArr[i][1] integerValue];
            
            NSMutableArray * objArr = self.MapArr[0];
            if (new_tx < 0 || new_tx > (self.MapArr.count-1) || new_ty < 0 || new_ty > (objArr.count-1)) {
//                NSLog(@"坐标越界");
                continue;
            }
            
            if ( [self.MapArr[new_tx][new_ty] isEqualToString:@"*"] && [self.BookArr[new_tx][new_ty] isEqualToNumber:@(0)] ) {
                // 做好标记
                [self.BookArr[new_tx] replaceObjectAtIndex:new_ty withObject:@(1)];
                [self.PathArr addObject:@[@(new_tx),@(new_ty)]];

                // 递归
                [self dfs:new_tx :new_ty :step+1];
                
                // 清空标记
                [self.BookArr[new_tx] replaceObjectAtIndex:new_ty withObject:@(0)];
                [self.PathArr removeObject:@[@(new_tx),@(new_ty)]];
            }
        }
    }
}


#pragma mark - Lazy int


-(NSArray *)MapArr {
    if (!_MapArr) {
        /*
        // 测试地图一
        _MapArr = @[@[@"*",@"*",@"*",@"#"],
                    @[@"#",@"*",@"*",@"#"],
                    @[@"*",@"*",@"*",@"*"],
                    @[@"*",@"*",@"*",@"*"],];
         */
        /*
        // 测试地图二
        _MapArr = @[@[@"*",@"*",@"*"],
                    @[@"*",@"*",@"*"],
                    @[@"*",@"*",@"*"],
                    @[@"*",@"*",@"*"],
                    @[@"*",@"*",@"*"],
                    @[@"*",@"*",@"*"],
                    @[@"*",@"*",@"*"]];
         */
        /*
        // 测试地图三
        _MapArr = @[@[@"*",@"*",@"*",@"*",@"*",@"*"],
                    @[@"*",@"*",@"*",@"*",@"*",@"*"],
                    @[@"*",@"*",@"*",@"#",@"*",@"*"],
                    @[@"*",@"*",@"*",@"#",@"#",@"*"],
                    @[@"#",@"*",@"*",@"*",@"*",@"#"],
                    @[@"*",@"*",@"*",@"*",@"*",@"*"],
                    @[@"*",@"*",@"*",@"*",@"*",@"*"],
                    @[@"*",@"*",@"*",@"*",@"*",@"*"]];
        */
        // 测试地图四
        _MapArr = @[@[@"*",@"*",@"*",@"*"],
                    @[@"*",@"#",@"*",@"*"],
                    @[@"*",@"*",@"*",@"*"],
                    @[@"*",@"*",@"#",@"*"],
                    @[@"*",@"*",@"*",@"*"],
                    @[@"*",@"#",@"*",@"*"],
                    @[@"*",@"*",@"*",@"*"]];
        
    }
    return _MapArr;
}

-(NSArray *)DirectionArr {
    if (!_DirectionArr) {
        _DirectionArr = @[@[@(-1),@(0)],     // 上
                          @[@(0),@(1)],      // 右
                          @[@(1),@(0)],      // 下
                          @[@(0),@(-1)]];    // 左
    }
    return _DirectionArr;
}

-(NSMutableArray *)BookArr {
    if (!_BookArr) {
        _BookArr = [[NSMutableArray alloc] initWithCapacity:5];

        for (int i = 0; i < self.MapArr.count; i++) {
            NSMutableArray * newObjArr = [[NSMutableArray alloc]initWithCapacity:5];
            NSMutableArray * objArr = self.MapArr[i];
            for (int j = 0; j < objArr.count; j++) {
                [newObjArr addObject:@(0)];
            }
            [_BookArr addObject:newObjArr];
        }
    }
    return _BookArr;
}

-(NSMutableArray *)PathArr {
    if (!_PathArr) {
        _PathArr = [[NSMutableArray alloc]initWithCapacity:5];
    }
    return _PathArr;
}

-(NSInteger)allSteps {
    NSInteger steps = 0;
    for (int i = 0; i < self.MapArr.count; i++) {
        NSMutableArray * objArr = self.MapArr[i];
        for (int j = 0; j < objArr.count; j++) {
            if ([self.MapArr[i][j] isEqualToString:@"*"]) {
                steps++;
            }
        }
    }
    return steps;
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
