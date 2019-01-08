//
//  QNResultData.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNUser.h"

typedef NS_ENUM(NSUInteger, QNAlgorithmMethod) {
    QNAlgorithmMethodTwoElectrodeV1 = 2,
    QNAlgorithmMethodTwoElectrodeV2 = 5,
    QNAlgorithmMethodFourElectrodeV1 = 3,
    QNAlgorithmMethodFourElectrodeV2 = 4,
};

@interface QNResultData : NSObject
/** 50电阻的值 */
@property (nonatomic, assign) int resistance;
/** 500电阻的值 */
@property (nonatomic, assign) int secResistance;
/** 是否支持心率 */
@property (nonatomic, assign) BOOL supportHeartRate;
/** 是否支持充电 */
@property (nonatomic, assign) BOOL supportCharge;
/** 显示的指标 */
@property (nonatomic, assign) NSInteger bodyIndexFlag;
/** 算法 */
@property (nonatomic, assign) QNAlgorithmMethod method;
/** 用户信息 */
@property (nonatomic, strong) QNUser *user;
/** 体重 */
@property (nonatomic, assign) double weight;
/** 心率 */
@property (nonatomic, assign) int heartRate;
/** 测量的时间戳 */
@property (nonatomic, assign) long timeTemp;
/** BMI */
@property (nonatomic, assign, readonly) double BMI;
/** 体脂率 */
@property (nonatomic, assign, readonly) double bodyfatRate;
/** 皮下脂肪率 */
@property (nonatomic, assign, readonly) double subcutaneousFat;
/** 内脏脂肪等级 */
@property (nonatomic, assign, readonly) int visceralFat;
/** 身体水分率 */
@property (nonatomic, assign, readonly) double bodyWaterRate;
/** 骨骼肌率 */
@property (nonatomic, assign, readonly) double muscleRate;
/** 骨量 */
@property (nonatomic, assign, readonly) double boneMass;
/** 基础代谢率 */
@property (nonatomic, assign, readonly) int BMR;
/** 体型 */
@property (nonatomic, assign, readonly) int bodyType;
/** 蛋白质 */
@property (nonatomic, assign, readonly) double protein;
/** 去脂体重 */
@property (nonatomic, assign, readonly) double leanBodyWeight;
/** 肌肉量 */
@property (nonatomic, assign, readonly) double muscleMass;
/** 体年龄 */
@property (nonatomic, assign, readonly) int metabolicAge;
/** 分数*/
@property (nonatomic, assign, readonly) double healthScore;
/** 心脏指数 */
@property (nonatomic, assign, readonly) double heartIndex;

/** 计算测试结果 */
- (QNResultData *)reckonMeasureResult;

@end
