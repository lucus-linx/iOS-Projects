//
//  AppUseTime+CoreDataProperties.m
//  
//
//  Created by linxiang on 2018/3/2.
//
//

#import "AppUseTime+CoreDataProperties.h"

@implementation AppUseTime (CoreDataProperties)

+ (NSFetchRequest<AppUseTime *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AppUseTime"];
}

@dynamic date;
@dynamic starttime;
@dynamic endtime;
@dynamic timediff;

@end
