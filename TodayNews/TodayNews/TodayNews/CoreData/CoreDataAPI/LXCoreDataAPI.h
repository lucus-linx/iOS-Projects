//
//  LXCoreDataAPI.h
//  TodayNews
//
//  Created by linxiang on 2018/3/5.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LXCoreDataAPI : NSObject


- (instancetype)initWithCoreData:(NSString *)entityName modelName:(NSString *)modelName success:(void(^)(void))success fail:(void(^)(NSError *error))fail;


// 添加数据
- (void)insertNewEntity:(NSDictionary *)dict success:(void(^)(void))success fail:(void(^)(NSError *error))fail;


// 查询数据
- (void)readEntity:(NSArray *)sequenceKeys ascending:(BOOL)isAscending filterStr:(NSString *)filterStr success:(void(^)(NSArray *results))success fail:(void(^)(NSError *error))fail;

// 更新数据
- (void)updateEntity:(void(^)(void))success fail:(void(^)(NSError *error))fail;

// 删除数据
- (void)deleteEntity:(NSManagedObject *)entity success:(void(^)(void))success fail:(void(^)(NSError *error))fail;


@end
