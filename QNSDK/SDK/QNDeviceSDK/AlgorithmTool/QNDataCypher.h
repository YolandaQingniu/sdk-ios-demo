//
//  QNDataCypher.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/2/26.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNAuthDevice.h"
#import "QNUser+QNAddition.h"
#import "QNScaleData.h"

typedef NS_ENUM(NSUInteger, QNMineralLevel) {
    QNMineralNone = 0,
    QNMineralStand,
    QNMineralLow,
    QNMineralEnough,
};

NS_ASSUME_NONNULL_BEGIN

@interface QNDataCypher : NSObject

@property(nonatomic, assign, readonly) NSInteger resistance;
@property(nonatomic, assign, readonly) NSInteger secResistance;
@property(nonatomic, assign, readonly) NSInteger resistanceAdjust;
@property(nonatomic, assign, readonly) NSInteger secResistanceAdjust;
@property(nonatomic, assign, readonly) NSInteger lastResistanceAdjust;
@property(nonatomic, assign, readonly) NSInteger lastSecResistanceAdjust;
@property(nonatomic, assign, readonly) long timeTemp;
@property(nonatomic, strong, readonly) QNUser *user;
@property(nonatomic, strong, readonly) QNAuthDevice *authDevice;

@property(nonatomic, assign) NSInteger encryRes50;
@property(nonatomic, assign) NSInteger encryRes500;

@property(nonatomic, strong) NSString *hmac;
/** 身高(身高体重秤) */
@property (nonatomic, assign) double height;
/** 身高体重秤模式(身高体重秤) */
@property (nonatomic, assign) QNHeightWeightMode heigtWeightMode;
/** 体重 */
@property (nonatomic, assign) double weight;
/** 心率 */
@property (nonatomic, assign) int heartRate;
/** BMI */
@property (nonatomic, assign) double BMI;
/** 体脂率 */
@property (nonatomic, assign) double bodyfatRate;
/** 皮下脂肪率 */
@property (nonatomic, assign) double subcutaneousFat;
/** 内脏脂肪等级 */
@property (nonatomic, assign) int visceralFat;
/** 身体水分率 */
@property (nonatomic, assign) double bodyWaterRate;
/** 骨骼肌率 */
@property (nonatomic, assign) double muscleRate;
/** 骨量 */
@property (nonatomic, assign) double boneMass;
/** 基础代谢率 */
@property (nonatomic, assign) int BMR;
/** 体型 */
@property (nonatomic, assign) int bodyType;
/** 蛋白质 */
@property (nonatomic, assign) double protein;
/** 去脂体重 */
@property (nonatomic, assign) double leanBodyWeight;
/** 肌肉量 */
@property (nonatomic, assign) double muscleMass;
/** 体年龄 */
@property (nonatomic, assign) int metabolicAge;
/** 分数*/
@property (nonatomic, assign) double healthScore;
/** 心脏指数 */
@property (nonatomic, assign) double heartIndex;
/** 脂肪重量 */
@property (nonatomic, assign) double bodyFatWeight;
/** 肥胖度 */
@property (nonatomic, assign) double obesity;
/** 含水量 */
@property (nonatomic, assign) double waterWeight;
/** 蛋白质量 */
@property (nonatomic, assign) double proteinWeight;
/** 无机盐状况 */
@property (nonatomic, assign) QNMineralLevel mineralLevel;
/** 理想视觉体重 */
@property (nonatomic, assign) double dreamWeight;
/** 标准体重 */
@property (nonatomic, assign) double standWeight;
/** 体重控制量 */
@property (nonatomic, assign) double weightControl;
/** 脂肪控制量 */
@property (nonatomic, assign) double bodyFatControl;
/** 肌肉控制量 */
@property (nonatomic, assign) double muscleMassControl;
/** 肌肉率 */
@property (nonatomic, assign) double muscleMassRate;
/** 脂肪肝风险等级 */
@property (nonatomic, assign) int fattyRisk;

+ (QNDataCypher *)buildCypherWithWeight:(double)weight res:(NSInteger)res secRes:(NSInteger)secRes resAdjust:(NSInteger)resAdjust secResAdjust:(NSInteger)secResAdjust timeTemp:(long)timeTemp device:(QNAuthDevice *)device heartRate:(NSInteger)heartRate;

+ (QNDataCypher *)buildCypherWithWeight:(double)weight res:(NSInteger)res secRes:(NSInteger)secRes timeTemp:(long)timeTemp device:(QNAuthDevice *)device heartRate:(NSInteger)heartRate;

+ (QNDataCypher *)buildHeihgtWeightCypherWithWeight:(double)weight res:(NSInteger)res secRes:(NSInteger)secRes timeTemp:(long)timeTemp device:(QNAuthDevice *)device height:(double)height mode:(QNHeightWeightMode)heightWeightMode;


+ (double)calculateCurWeightWithUser:(QNUser *)user weight:(double)weight;
+ (int)calculateMethodWithUser:(QNUser *)user device:(QNAuthDevice *)device;
+ (BOOL)calculateSportModeWithUser:(QNUser *)user;


- (void)calculateMeasureDataWithUser:(QNUser *)user;
- (void)calculateWspMeasureDataWithUser:(QNUser *)user;




@end

NS_ASSUME_NONNULL_END
