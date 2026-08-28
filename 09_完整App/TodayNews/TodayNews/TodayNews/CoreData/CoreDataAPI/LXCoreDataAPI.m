//
//  LXCoreDataAPI.m
//  TodayNews
//
//  Created by linxiang on 2018/3/5.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXCoreDataAPI.h"

#import "AppUseTime+CoreDataClass.h"

@interface LXCoreDataAPI()

/**
 *  获取.xcdatamodeld文件中创建的实体的名称
 */
@property (nonatomic, readwrite, copy) NSString *entityName;

/**
 *  上下文
 */
@property (nonatomic, readwrite, strong) NSManagedObjectContext *context;

@end


@implementation LXCoreDataAPI

/*
 实例化上下文对象
 2.1 创建托管对象上下文(NSManagedObjectContext)
 2.2 创建托管对象模型(NSManagedObjectModel)
 2.3 根据托管对象模型，创建持久化存储协调器(NSPersistentStoreCoordinator)
 2.4 关联并创建本地数据库文件，并返回持久化存储对象(NSPersistentStore)
 2.5 将持久化存储协调器赋值给托管对象上下文，完成基本创建。
 */

- (instancetype)initWithCoreData:(NSString *)entityName modelName:(NSString *)modelName success:(void(^)(void))success fail:(void(^)(NSError *error))fail
{
    if (self = [super init]) {
        
        self.entityName = entityName;
        
        // 1、-----------------
        // 指定 context 的并发类型： NSMainQueueConcurrencyType 或 NSPrivateQueueConcurrencyType
        _context = [[NSManagedObjectContext alloc ] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        // 2、-----------------
        //获取模型路径 -- url为CoreDataDemo.xcdatamodeld，注意扩展名为 momd，而不是 xcdatamodeld 类型
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
        //根据模型文件创建模型对象
        NSManagedObjectModel * managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        // 3、-----------------
        // 以传入模型方式初始化持久化存储库
        NSPersistentStoreCoordinator * persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        
        // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
        NSString *sqlPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        sqlPath = [sqlPath stringByAppendingFormat:@"/%@.sqlite", modelName];
        
        // 4、-----------------
        /*
         持久化存储库的类型：
         NSSQLiteStoreType  SQLite数据库
         NSBinaryStoreType  二进制平面文件
         NSInMemoryStoreType 内存库，无法永久保存数据
         虽然这3种类型的性能从速度上来说都差不多，但从数据模型中保留下来的信息却不一样
         在几乎所有的情景中，都应该采用默认设置，使用SQLite作为持久化存储库
         */
        // 添加一个持久化存储库并设置类型和路径，NSSQLiteStoreType：SQLite作为存储库
        NSError *error = nil;
        [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:[NSURL fileURLWithPath:sqlPath]
                                                       options:nil
                                                         error:&error];
        if (error) {
            //添加数据库失败
            if (fail) {
                fail(error);
            }
        } else {
            //添加数据库成功
            
            // 5、-----------------
            // 设置上下文所要关联的持久化存储库
            _context.persistentStoreCoordinator = persistentStoreCoordinator;
            if (success) {
                success();
            }
        }
    }

    return self;
}




// 添加数据
- (void)insertNewEntity:(NSDictionary *)dict success:(void(^)(void))success fail:(void(^)(NSError *error))fail
{
    if (!dict||dict.allKeys.count == 0) return;
    // 通过传入上下文和实体名称，创建一个名称对应的实体对象（相当于数据库一组数据，其中含有多个字段）
    NSManagedObject *newEntity = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.context];
    // 实体对象存储属性值（相当于数据库中将一个值存入对应字段)
    for (NSString *key in [dict allKeys]) {
        [newEntity setValue:[dict objectForKey:key] forKey:key];
    }

    // 通过上下文保存对象，并在保存前判断是否有更改
    NSError *error = nil;
    if (self.context.hasChanges) {
        // 保存信息，同步数据
        BOOL result = [self.context save:&error];
        
        if (!result) {
            //添加数据失败
            if (fail) {
                fail(error);
            }
        } else {
            //添加数据成功
            if (success) {
                success();
            }
        }
    }
}


// 查询数据
- (void)readEntity:(NSArray *)sequenceKeys ascending:(BOOL)isAscending filterStr:(NSString *)filterStr success:(void(^)(NSArray *results))success fail:(void(^)(NSError *error))fail
{
    // 1.初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];

    // 2.设置要查询的实体
    NSEntityDescription *desc = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.context];
    request.entity = desc;
    
    // 3.设置查询结果排序
    if (sequenceKeys&&sequenceKeys.count > 0) { // 如果进行了设置排序
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *key in sequenceKeys) {
            /**
             *  设置查询结果排序
             *  sequenceKey:根据某个属性（相当于数据库某个字段）来排序
             *  isAscending:是否升序
             */
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:isAscending];
            [array addObject:sort];
        }
        if (array.count > 0) {
            request.sortDescriptors = array;// 可以添加多个排序描述器，然后按顺序放进数组即可
        }
    }
    // 4.设置条件过滤
    if (filterStr) { // 如果设置了过滤语句
        NSPredicate *predicate = [NSPredicate predicateWithFormat:filterStr];
        request.predicate = predicate;
    }
    // 5.执行请求
    NSError *error = nil;
    NSArray *objs = [self.context executeFetchRequest:request error:&error]; // 获得查询数据数据集合
    
    if (error) {
        if (fail) {
            fail(error);
        }
    } else{
        if (success) {
            success(objs);
        }
    }
}


// 更新数据
- (void)updateEntity:(void(^)(void))success fail:(void(^)(NSError *error))fail
{
    NSError *error = nil;
    [self.context save:&error];
    if (error) {
        NSLog(@"删除失败：%@",error);
        if (fail) {
            fail(error);
        }
    } else {
        if (success) {
            success();
        }
    }
    
}

// 删除数据
- (void)deleteEntity:(NSManagedObject *)entity success:(void(^)(void))success fail:(void(^)(NSError *error))fail
{
    // 传入需要删除的实体对象
    [self.context deleteObject:entity];
    // 同步到数据库
    NSError *error = nil;
    [self.context save:&error];
    if (error) {
        NSLog(@"删除失败：%@",error);
        if (fail) {
            fail(error);
        }
    } else {
        if (success) {
            success();
        }
    }
}



@end
