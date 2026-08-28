//
//  AppUseTime+CoreDataProperties.h
//  
//
//  Created by linxiang on 2018/3/2.
//
//

#import "AppUseTime+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AppUseTime (CoreDataProperties)

+ (NSFetchRequest<AppUseTime *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *starttime;
@property (nullable, nonatomic, copy) NSString *endtime;
@property (nullable, nonatomic, copy) NSString *timediff;

@end

NS_ASSUME_NONNULL_END
