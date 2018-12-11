//
//  QNUser.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNCallBackConst.h"

typedef NS_ENUM(NSUInteger,YLUserShapeType) {
    YLUserShapeNone = 0, //none 无
    YLUserShapeSlim, // Slim 纤瘦、苗条
    YLUserShapeNormal, // Normal 均匀、标准
    YLUserShapeStrong, // Strong 肌肉发达、有型
    YLUserShapePlim, // full 圆润，丰满
};

typedef NS_ENUM(NSUInteger,YLUserGoalType) {
    YLUserGoalNone = 0, // none 无
    YLUserGoalLost, // Fat loss  减脂
    YLUserGoalGain, // Muscle gain  增肌
    YLUserGoalStay, // stay healthy 保持健康
};

typedef NS_ENUM(NSUInteger,YLAthleteType) {
    YLAthleteDefault = 0,// 普通模式
    YLAthleteSport, //运动员模式
};

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
@property (nonatomic, assign, readonly) YLAthleteType athleteType;

/** 用户的身材 */
@property (nonatomic, assign) YLUserShapeType shapeType;
/** 用户目标 */
@property (nonatomic, assign) YLUserGoalType goalType;
@end
