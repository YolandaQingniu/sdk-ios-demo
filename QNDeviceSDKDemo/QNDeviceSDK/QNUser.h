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
/**
 设置使用算法的类型
 1表示运动员算法，0是普通算法
 当用户年龄小于18岁时，即使设置为运动员模式，也是使用普通模式
 */
@property (nonatomic, assign, readonly) int athleteType;

@end
