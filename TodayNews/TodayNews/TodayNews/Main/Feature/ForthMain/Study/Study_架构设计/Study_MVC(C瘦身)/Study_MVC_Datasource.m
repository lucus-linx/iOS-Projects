//
//  Study_MVC_Datasource.m
//  TodayNews
//
//  Created by linxiang on 2018/7/24.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Study_MVC_Datasource.h"

#import "Study_MVC_User_Cell.h"

@interface Study_MVC_Datasource()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewBlock myblock;

@end


@implementation Study_MVC_Datasource

- (id)initWithItems:(NSArray *)anItems cellIdentifier:(NSString *)aCellIdentifier configureCellBlock:(TableViewBlock)block {
    
    self = [super init];
    if (self) {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.myblock = block;
    }
    return  self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.items[(NSUInteger) indexPath.row];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    id item = [self itemAtIndexPath:indexPath];
    self.myblock(cell, item, indexPath);
    return cell;
}



@end
