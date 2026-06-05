//
//  QNSlimUserSlimConfig.h
//  QNDeviceSDK
//
//  Created by yolanda on 2025/10/27.
//  Copyright © 2025 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNConfig.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QNSlimDayCountRule) {
    QNSlimDayCountRuleAutoIncrement = 0, // 自动递增
    QNSlimDayCountRuleByMeasurement = 1  // 按测量天数递增
};

typedef NS_ENUM(NSUInteger, QNSlimCurveWeightSelection) {
    QNSlimCurveWeightSelectionLastOfDay = 0, // 当天最后测量值(使用当天最后一次测量的体重值绘制曲线（默认方式）)
    QNSlimCurveWeightSelectionMinOfDay  = 1  // 当天最小值(使用当天测量的最小体重值绘制曲线)
};

@interface QNSlimUserSlimConfig : NSObject
/// 减重天数计算规则，用于设置减重天数的计算方式，决定减重进度天数如何增加，默认值QNSlimDayCountRuleAutoIncrement
@property (nonatomic, assign) QNSlimDayCountRule  slimDayCountRule;
/// 减重进度天数，表示用户当前的减重进度天数，用于跟踪用户减重计划的执行天数
@property (nonatomic, assign) int  slimDays;
/// 体重曲线数据选择规则，用于指定体重曲线图使用的体重数据
@property (nonatomic, assign) QNSlimCurveWeightSelection  curveWeightSelection;
/// 用户目标体重（单位：kg）
@property (nonatomic, assign) double targetWeight;
/// 用户初始体重（单位：kg）
@property (nonatomic, assign) double initialWeight;

@end

NS_ASSUME_NONNULL_END
