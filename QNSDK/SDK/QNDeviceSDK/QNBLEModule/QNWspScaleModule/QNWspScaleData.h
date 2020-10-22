///Users/qiudongquan/Yolanda/Progress/QNBLEModule
//  QNWspScaleData.h
//  QNWspScaleModule
//
//  Created by donyau on 2019/7/27.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QNWspEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNWspScaleData : NSObject
/// 序列号 (未知测量数据，无需理会该字段)
@property(nonatomic, assign) NSUInteger secretIndex;
/// 未知测量数据，无需判断序列号
@property(nonatomic, assign) BOOL unknowFlag;

@property(nonatomic, assign) NSTimeInterval timeStamp;
/// 体重
@property(nonatomic, assign) double weight;
/// BMI
@property(nonatomic, assign) double bmi;
/// 体脂肪
@property(nonatomic, assign) double bodyFat;
/// 基础代谢量
@property(nonatomic, assign) double bmr;
/// 骨骼肌率
@property(nonatomic, assign) double muscle;
/// 肌肉量
@property(nonatomic, assign) double sinew;
/// 去脂体重
@property(nonatomic, assign) double fatFreeWeight;
/// 体水分
@property(nonatomic, assign) double water;
/// 骨量
@property(nonatomic, assign) double bone;
/// 内脏脂肪
@property(nonatomic, assign) double visfat;
/// 皮下脂肪
@property(nonatomic, assign) double subFat;
/// 蛋白质
@property(nonatomic, assign) double protein;
/// 体年龄
@property(nonatomic, assign) double bodyage;
/// 心率
@property(nonatomic, assign) double heartRate;
/// 心脏指数
@property(nonatomic, assign) double cardiacIndex;
/// 分数
@property(nonatomic, assign) double bodyScore;
/// 体型
@property(nonatomic, assign) NSInteger bodyShape;

/* ----------------------- 通用秤阻抗 ----------------------------*/
/// 50阻抗
@property(nonatomic, assign) double resistance;
/// 500阻抗
@property(nonatomic, assign) double secResistance;

/* ----------------------- 八电极阻抗 ----------------------------*/
/// 左臂
@property(nonatomic, assign) double leftArmRes20;
/// 左臂
@property(nonatomic, assign) double leftArmRes100;

/// 右臂
@property(nonatomic, assign) double rightArmRes20;
/// 右臂
@property(nonatomic, assign) double rightArmRes100;

/// 左腿
@property(nonatomic, assign) double leftHamRes20;
/// 左腿
@property(nonatomic, assign) double leftHamRes100;

/// 右腿
@property(nonatomic, assign) double rightHamRes20;
/// 右腿
@property(nonatomic, assign) double rightHamRes100;

/// 腹部
@property(nonatomic, assign) double bellyRes20;
/// 腹部
@property(nonatomic, assign) double bellyRes100;
@end

NS_ASSUME_NONNULL_END
