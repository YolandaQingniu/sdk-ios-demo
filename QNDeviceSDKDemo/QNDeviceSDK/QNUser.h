//
//  QNUser.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNCallBackConst.h"

/**
 该用户类必须使用 QNBleApi 类中 "- (QNUser *)buildUser:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday callback:(QNResultCallback)callback" 方法创建用户
 */

@interface QNUser : NSObject
/** userID */
@property (nonatomic, strong, readonly) NSString *userId;
/** height */
@property (nonatomic, assign, readonly) int height;
/** gender : male or female */
@property (nonatomic, strong, readonly) NSString *gender;
/** brithday */
@property (nonatomic, strong, readonly) NSDate *birthday;
@end
