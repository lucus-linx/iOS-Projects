//
//  LoginRAC_Model.h
//  TodayNews
//
//  Created by 林祥 on 2019/3/12.
//  Copyright © 2019 LX. All rights reserved.
//


/*Model网络请求。参考：https://www.open-open.com/lib/view/open1482979146614.html*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^successBlock)(void);
typedef void(^failBlock)(void);

@interface LoginRAC_Model : NSObject

@property (nonatomic, copy, readwrite) NSString * ID;
@property (nonatomic, copy, readwrite) NSString * username;
@property (nonatomic, copy, readwrite) NSString * password;
@property (nonatomic, copy, readwrite) NSString * phone;

+(void)getData:(successBlock)success :(failBlock)fail;

@end

NS_ASSUME_NONNULL_END
