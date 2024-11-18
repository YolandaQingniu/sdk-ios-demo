//
//  ScaleDataTargetTool.h
//  QNDeviceSDKDemo
//
//  Created by JuneLee on 2019/10/23.
//  Copyright © 2019 Yolanda. All rights reserved.
//  测量数据指标工具类

#import <Foundation/Foundation.h>
#import <QNDeviceSDK/QNDeviceSDK.h>


NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, TargetType) {
    TargetTypeWeight = 1,
    TargetTypeBmi = 2,
    TargetTypeBodyfat = 3,
    TargetTypeSubfat = 4,
    TargetTypeVisfat = 5,
    TargetTypeWater = 6,
    TargetTypeMuscle = 7,
    TargetTypeBone = 8,
    TargetTypeBmr = 9,
    TargetTypeBodyShape= 10,
    TargetTypeProtein = 11,
    TargetTypeFatFreeWeight = 12,
    TargetTypeSinew = 13,
    TargetTypeBodyage = 14,
    TargetTypeHeartRate = 15,
    TargetTypeCardiacIndex = 16,
    TargetTypeFatMass = 17,
};

#pragma mark - 测量数据的指标模型
@interface ScaleDataTargetModel : NSObject
// 指标标识
@property (nonatomic, assign) TargetType targetType;
// 等级集合
@property (nonatomic, strong) NSArray *levelNames;
// 当前等级
@property (nonatomic, strong) NSString *currentLevel;

@end

@interface ScaleDataTargetTool : NSObject

+ (ScaleDataTargetModel *)getScaleDataTargetModelWithScaleData:(QNScaleItemData *)scaleData
                                                          user:(QNUser *)user
                                                 currentWeight:(CGFloat)currentWeight;

@end

NS_ASSUME_NONNULL_END
