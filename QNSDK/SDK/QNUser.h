//
//  QNUser.h
//  QNDeviceSDK
//
//  Created by com.qn.device on 2018/1/9.
//  Copyright © 2018年 com.qn.device. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNCallBackConst.h"
#import "QNIndicateConfig.h"

typedef NS_ENUM(NSUInteger,YLUserShapeType) {
    YLUserShapeNone = 0, //none 无
    YLUserShapeSlim = 1, // Slim 纤瘦、苗条型
    YLUserShapeNormal = 2, // Normal 匀称、标准型
    YLUserShapeStrong = 3, // Strong 健美、肌肉型
    YLUserShapePlim = 4, // full 丰满、超重
};

typedef NS_ENUM(NSUInteger,YLUserGoalType) {
    YLUserGoalNone = 0, // none 无
    YLUserGoalLoseFat = 1, // Fat loss  减脂
    YLUserGoalStayHealth = 2, // Stay Health  保持健康
    YLUserGoalGainMuscle = 3, // Muscle gain  增肌
    YLUserGoalPowerOftenExercise = 5, // 每周数次力量型运动，如器械练习
    YLUserGoalPowerLittleExercise = 6, // 基础不错，但缺乏系统性训练
    YLUserGoalPowerOftenRun = 7, // 每周数次有氧型运动，如跑步
};

typedef NS_ENUM(NSUInteger,YLAthleteType) {
    YLAthleteDefault = 0,// 普通模式
    YLAthleteSport, //运动员模式
};

/**
 用于计算其他指标（除了体重、身高和BMI外的其他指标） 说明：针对身高体重秤，BMI指标值是测量身高与测量体重计算得出的
 */
typedef NS_ENUM(NSUInteger,YLHeightDecision) {
    YLHeightDecisionScaleDataHeight = 0,// 测量数据身高，即设备测量得到的身高值
    YLHeightDecisionUserInfoHeight = 1 //用户信息身高，即传入的用户身高值
};

@interface QNUser : NSObject
/** userID(如果秤端支持用户名显示，则该字段内容会下发到设备) */
@property (nonatomic, strong) NSString *userId;
/** height */
@property (nonatomic, assign) int height;
/** gender : male or female */
@property (nonatomic, strong) NSString *gender;
/** birthday */
@property (nonatomic, strong) NSDate *birthday;
/** clothesWeight */
@property (nonatomic, assign) double clothesWeight;
/**
 设置使用算法的类型
 1表示运动员算法，0是普通算法
 当用户年龄小于18岁时，即使设置为运动员模式，也是使用普通模式
 */
@property (nonatomic, assign) YLAthleteType athleteType;

/** 用户的身材 */
@property (nonatomic, assign) YLUserShapeType shapeType;
/** 用户目标 */
@property (nonatomic, assign) YLUserGoalType goalType;

/** 秤端该用户索引，该值由向秤注册用户成功时，秤端返回 */
@property (nonatomic, assign) int index;
/** 秤端该用户秘钥，默认1000 */
@property (nonatomic, assign) int secret;

@property(nonatomic, strong) QNIndicateConfig *indicateConfig;

/** WSP 设备专用, 控制秤端是否进行测量脂肪*/
@property(nonatomic, assign) BOOL measureFat;
/** WSP 设备专用, 控制秤端是否进行显示测量后除体重与BMI以外的指标）*/
@property(nonatomic, assign) BOOL indicateDis;

/** 用户特性*/
@property(nonatomic, assign) int selfhood;

/** 是否调整体年龄显示（部分秤支持，NO：不调整；Yes：调整）*/
@property (nonatomic, assign) BOOL isAdjustBodyAge;

/** 身高体重秤（身高体重一体机） 设备专用，用于计算其他指标（除了体重、身高和BMI外的其他指标），默认使用测量数据身高 */
@property (nonatomic, assign) YLHeightDecision heightDecision;

/**
 建立用户模型
 
 @param userId 用户id
 @param height 用户身高
 @param gender 用户性别 male female
 @param birthday 用户的出生日期 age 3~80
 @param callback 结果的回调
 @return QNUser
 */
+ (QNUser *)buildUserId:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday callback:(QNResultCallback)callback NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "0.5.2版本开始不必使用指定的构建方法");

/**
 建立用户模型
 
 @param userId 用户id
 @param height 用户身高
 @param gender 用户性别 male female
 @param birthday 用户的出生日期 age 3~80
 @param athleteType 是否是运动员模式
 @param callback 结果的回调
 @return QNUser
 */
+ (QNUser *)buildUserId:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday athleteType:(YLAthleteType)athleteType callback:(QNResultCallback)callback NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "0.5.2版本开始不必使用指定的构建方法");

/**
 建立用户模型

 @param userId 用户id
 @param height 用户身高
 @param gender 用户性别 male female
 @param birthday 用户的出生日期 age 3~80
 @param athleteType 是否是运动员模式
 @param shapeType 用户的身材
 @param goalType 用户目标
 @param callback 回调
 @return QNUser
 */
+ (QNUser *)buildUserId:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday athleteType:(YLAthleteType)athleteType shapeType:(YLUserShapeType)shapeType goalType:(YLUserGoalType)goalType callback:(QNResultCallback)callback NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "0.5.2版本开始不必使用指定的构建方法");


@end
