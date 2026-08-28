//
//  LXLogModel.h
//  LXLogViewPods
//
//  Created by linxiang on 2018/5/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LXLogType) {
    LXLogTypeDefault,    // 默认类型，为白色
    LXLogTypeRed,        // 红色类型
    LXLogTypeGreen       // 绿色类型
};

@interface LXLogModel : NSObject <NSCoding>

/**
 Id  ==  UUID
 */
@property (nonatomic, strong) NSString * Id;

/**
 当前thread
 */
@property (nonatomic, strong) NSString * Thread;

/**
 当前时间
 */
@property (nonatomic, strong) NSString * Date;

/**
 log具体的文件名、函数名、行
 */
@property (nonatomic, strong) NSString * FileInfo;

/**
 log具体的内容
 */
@property (nonatomic, strong) NSString * Content;


// 类型
@property (nonatomic, assign) LXLogType Type;




/**
 最基本的init

 @return self
 */
-(instancetype)init;


/**
 常用init
 
 @param thread 当前线程
 @param fileinfo 当前文件具体信息
 @param content log具体内容
 @return self
 */
-(instancetype)initWithThread:(NSString *)thread FileInfo:(NSString *)fileinfo Content:(NSString *)content ;


/**
 最详细自定义初始化

 @param thread 当前线程
 @param fileinfo 当前文件具体信息
 @param content log具体内容
 @param type 具体类型
 @return self
 */
-(instancetype)initWithThread:(NSString *)thread FileInfo:(NSString *)fileinfo Content:(NSString *)content Type:(LXLogType)type;



@end
