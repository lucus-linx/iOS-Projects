//
//  AppUseTime_API.m
//  TodayNews
//
//  Created by linxiang on 2018/3/5.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "AppUseTime_API.h"
//#import "CoreDataAPI.h"
#import "LXCoreDataAPI.h"

#import "AppUseTime+CoreDataClass.h"

static NSString * const modelName = @"Model";
static NSString * const entityName = @"AppUseTime";



@interface AppUseTime_API()

@property (nonatomic,strong) LXCoreDataAPI * lxCoreDataAPI;

@end


@implementation AppUseTime_API

+ (instancetype)sharedInstance
{
    static AppUseTime_API * appUseTime_API = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appUseTime_API = [[AppUseTime_API alloc] init];
    });
    
    return appUseTime_API;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initUploadCoreData];
    }
    return self;
}


/**
 初始化
 */
- (void)initUploadCoreData
{
    self.lxCoreDataAPI = [[LXCoreDataAPI alloc] initWithCoreData:entityName modelName:modelName success:^{
        
    } fail:^(NSError *error) {
        
    }];

}

#pragma mark - -- 插入上传记录
- (void)insertModel:(NSDictionary *)dic success:(void(^)(void))success fail:(void(^)(NSError *error))fail;
{
    NSString * date = dic[@"date"];
    NSString * starttime = dic[@"starttime"];
    NSString * endtime = dic[@"endtime"];
    NSString * timediff = dic[@"timediff"];
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(date,starttime,endtime,timediff);
    
    [self.lxCoreDataAPI insertNewEntity:dict success:^{
        if (success) {
            success();
        }
    } fail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

#pragma mark - -- 查询所有上传记录
- (void)readAllUploadModel:(void(^)(NSArray *finishArray))success fail:(void(^)(NSError *error))fail
{
    [self.lxCoreDataAPI readEntity:nil ascending:YES filterStr:nil success:^(NSArray *results) {
        NSMutableArray *finishArray = [NSMutableArray array];
        
        if (results.count <= 0) {
            NSString *domain = @"com.MyCompany.MyApplication.ErrorDomain";
            NSString *desc = NSLocalizedString(@"Unable to…", @"数据为空");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            
            NSError *error = [NSError errorWithDomain:domain
                                                 code:-101
                                             userInfo:userInfo];
            fail(error);
            return ;
        }
        
        // 遍历输出查询结果
        [results enumerateObjectsUsingBlock:^(AppUseTime * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            LXLog(@"AAAAA === %@ BBBBB === %lu CCCCC == %@",obj.date ,(unsigned long)idx , obj.starttime);

            [finishArray addObject:obj];
        }];
        
        if (success) {
            success(results);
        }
    } fail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}



#pragma mark - -- 更新上传记录
- (void)updateUploadModel:(AppUseTime *)model success:(void(^)(void))success fail:(void(^)(NSError *error))fail
{
//    NSString *filterStr = [NSString stringWithFormat:@"date = '%@'",model.date];
    [self.lxCoreDataAPI readEntity:nil ascending:YES filterStr:nil success:^(NSArray *results) {
        if (results.count>0) {
            NSManagedObject *obj = [results firstObject];
            [obj setValue:@"2018-03-07" forKey:@"date"];
            [self.lxCoreDataAPI updateEntity:^{
                if (success) {
                    success();
                }
            } fail:^(NSError *error) {
                if (fail) {
                    fail(error);
                }
            }];
        }
    } fail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

#pragma mark - -- 删除一条上传记录
- (void)deleteUploadModel:(AppUseTime *)model success:(void(^)(void))success fail:(void(^)(NSError *error))fail
{
    NSString *filterStr = [NSString stringWithFormat:@"date = '%@'",model.date];
    [self.lxCoreDataAPI readEntity:nil ascending:YES filterStr:nil success:^(NSArray *results) {
        if (results.count>0) {
            NSManagedObject *obj = [results firstObject];
            [self.lxCoreDataAPI deleteEntity:obj success:^{
                if (success) {
                    success();
                }
            } fail:^(NSError *error) {
                if (fail) {
                    fail(error);
                }
            }];
        }
    } fail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}


#pragma mark - -- 删除所有上传记录
- (void)deleteAllUploadModel:(void(^)(void))success fail:(void(^)(NSError *error))fail
{
    [self.lxCoreDataAPI readEntity:nil ascending:YES filterStr:nil success:^(NSArray *results) {
        for (NSManagedObject *obj in results){
            [self.lxCoreDataAPI deleteEntity:obj success:^{
                if (success) {
                    success();
                }
            } fail:^(NSError *error) {
                if (fail) {
                    fail(error);
                }
            }];
        }
    } fail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}



@end
