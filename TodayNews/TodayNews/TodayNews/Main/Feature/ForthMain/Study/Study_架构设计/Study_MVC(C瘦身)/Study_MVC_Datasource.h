//
//  Study_MVC_Datasource.h
//  TodayNews
//
//  Created by linxiang on 2018/7/24.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

// block
typedef void(^TableViewBlock)(id cell, id model, NSIndexPath *indexPath);


@interface Study_MVC_Datasource : NSObject <UITableViewDataSource>


- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
