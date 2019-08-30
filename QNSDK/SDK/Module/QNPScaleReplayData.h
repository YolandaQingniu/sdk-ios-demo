//
//  QNPScaleReplayData.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/15.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark 心率秤显示的脂肪率等级
typedef NS_ENUM(NSUInteger, QNScaleBodyFatLevel) {
    QNScaleBodyFatLevelStand = 0,
    QNScaleBodyFatLevelLow = 1,
    QNScaleBodyFatLevelHeight = 2,
    QNScaleBodyFatLevelHigher = 3,
};

#pragma mark 心率秤显示的BMI等级
typedef NS_ENUM(NSUInteger, QNScaleBMILevel) {
    QNScaleBMILevelStand = 0,
    QNScaleBMILevelLow = 1,
    QNScaleBMILevelHeight = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface QNPScaleReplayData : NSObject
/** 脂肪率 */
@property (nonatomic, assign) float bodyFat;
/** 脂肪率等级 */
@property (nonatomic, assign) QNScaleBodyFatLevel bodyFatLevel;
/** BMI */
@property (nonatomic, assign) float BMI;
/** BMI */
@property (nonatomic, assign) QNScaleBMILevel BMILevel;
@end

NS_ASSUME_NONNULL_END
