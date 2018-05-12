//
//  QNScaleItemData.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 指标的数值类型

 - QNValueTypeDouble: 浮点型
 - QNValueTypeInt: 整形
 */
typedef NS_ENUM(NSUInteger, QNValueType) {
    QNValueTypeDouble = 0,
    QNValueTypeInt = 1,
};


/** 指标类型 */
typedef NS_ENUM(NSInteger, QNScaleType) {
    QNScaleTypeWeight = 1, //体重
    QNScaleTypeBMI = 2, //BMI
    QNScaleTypeBodyFatRage = 3, //体脂率
    QNScaleTypeSubcutaneousFat = 4, //皮下脂肪率
    QNScaleTypeVisceralFat = 5, //内脏脂肪等级
    QNScaleTypeBodyWaterRate = 6, //身体水分率
    QNScaleTypeMuscleRate = 7, //骨骼肌率
    QNScaleTypeBoneMass = 8, //骨量
    QNScaleTypeBMR = 9, //基础代谢率
    QNScaleTypeBodyType = 10, //体型
    QNScaleTypeProtein = 11, //蛋白质
    QNScaleTypeLeanBodyWeight = 12, //去脂体重
    QNScaleTypeMuscleMass = 13, //肌肉量
    QNScaleTypeMetabolicAge = 14, //体年龄
    QNScaleTypeHealthScore = 15, //分数
    QNScaleTypeHeartRate = 16, //心率
    QNScaleTypeHeartIndex = 17, //心脏指数
};

@interface QNScaleItemData : NSObject

/** 指标类型 */
@property (nonatomic, readonly, assign) QNScaleType type;

/** 指标数值 */
@property (nonatomic, readonly, assign) double value;

/** 指标值类型 */
@property (nonatomic, readonly, assign) QNValueType valueType;

/** 指标名称 */
@property (nonatomic, readonly, strong) NSString *name ;

@end
