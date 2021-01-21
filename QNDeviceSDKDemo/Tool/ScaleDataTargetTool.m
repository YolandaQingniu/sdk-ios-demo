//
//  ScaleDataTargetTool.m
//  QNDeviceSDKDemo
//
//  Created by JuneLee on 2019/10/23.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "ScaleDataTargetTool.h"

@implementation ScaleDataTargetModel
@end


@implementation ScaleDataTargetTool

+ (ScaleDataTargetModel *)getScaleDataTargetModelWithScaleData:(QNScaleItemData *)scaleData user:(QNUser *)user currentWeight:(CGFloat)currentWeight {
    TargetType targetType = [self transToTargetType:scaleData.type];
    ScaleDataTargetModel *model = [[ScaleDataTargetModel alloc] init];
    model.targetType = targetType;
    model.levelNames = [self getTargetLevelsWith:targetType];
    model.currentLevel = [self getCurrentLevelWithType:targetType scaleData:scaleData user:user currentWeight:currentWeight];
    return model;
}

+ (TargetType)transToTargetType:(QNScaleType)scaleType {
    TargetType targetType = 0;
    switch (scaleType) {
        case QNScaleTypeWeight: targetType = TargetTypeWeight; break;
        case QNScaleTypeBMI: targetType = TargetTypeBmi; break;
        case QNScaleTypeBodyFatRate: targetType = TargetTypeBodyfat; break;
        case QNScaleTypeSubcutaneousFat: targetType = TargetTypeSubfat; break;
        case QNScaleTypeVisceralFat: targetType = TargetTypeVisfat; break;
        case QNScaleTypeBodyWaterRate: targetType = TargetTypeWater; break;
        case QNScaleTypeMuscleRate: targetType = TargetTypeMuscle; break;
        case QNScaleTypeBoneMass: targetType = TargetTypeBone; break;
        case QNScaleTypeBMR: targetType = TargetTypeBmr; break;
        case QNScaleTypeBodyType: targetType = TargetTypeBodyShape; break;
        case QNScaleTypeProtein: targetType = TargetTypeProtein; break;
        case QNScaleTypeLeanBodyWeight: targetType = TargetTypeFatFreeWeight; break;
        case QNScaleTypeMuscleMass: targetType = TargetTypeSinew; break;
        case QNScaleTypeMetabolicAge: targetType = TargetTypeBodyage; break;
        case QNScaleTypeHeartRate: targetType = TargetTypeHeartRate; break;
        case QNScaleTypeHeartIndex: targetType = TargetTypeCardiacIndex; break;
        case QNScaleTypeFatMassIndex: targetType = TargetTypeFatMass; break;
        default:break;
    }
    return targetType;
}

#pragma mark - 指标等级数组
+ (NSArray *)getTargetLevelsWith:(TargetType)targetType {
    NSArray *levelNames = @[];
    switch (targetType) {
        case TargetTypeWeight: levelNames = @[@"严重偏低",@"偏低",@"标准",@"偏高",@"严重偏高"]; break;
        case TargetTypeBmi: levelNames = @[@"偏低",@"标准",@"偏高"];break;
        case TargetTypeBodyfat: levelNames = @[@"偏低",@"标准",@"偏高",@"严重偏高"]; break;
        case TargetTypeSubfat:levelNames = @[@"偏低",@"标准",@"偏高"]; break;
        case TargetTypeVisfat: levelNames = @[@"标准",@"偏高",@"严重偏高"]; break;
        case TargetTypeWater: levelNames = @[@"充足",@"标准",@"偏低"];  break;
        case TargetTypeMuscle:levelNames = @[@"偏低",@"标准",@"偏高"]; break;
        case TargetTypeBone:levelNames = @[@"偏低",@"标准",@"偏高"]; break;
        case TargetTypeBmr:break;
        case TargetTypeBodyShape:levelNames = @[@"肥胖型",@"偏胖型",@"隐形肥胖型",@"标准型",@"标准肌肉型",@"非常肌肉型",@"偏瘦型",@"偏瘦肌肉型",@"运动不足型"]; break;
        case TargetTypeProtein:levelNames = @[@"充足",@"标准",@"偏低"]; break;
        case TargetTypeFatFreeWeight:levelNames = @[@"标准"]; break;
        case TargetTypeSinew:levelNames = @[@"偏低",@"标准",@"充足"]; break;
        case TargetTypeBodyage:levelNames = @[@"达标",@"不达标"]; break;
        case TargetTypeHeartRate:break;
        case TargetTypeCardiacIndex:levelNames = @[@"偏低",@"标准",@"偏高"]; break;
        case TargetTypeFatMass:levelNames = @[@"偏低",@"标准",@"偏高",@"严重偏高"]; break;
        default: break;
    }
    return levelNames;
}

#pragma mark - 指标当前等级
+ (NSString *)getCurrentLevelWithType:(TargetType)targetType scaleData:(QNScaleItemData *)scaleData user:(QNUser *)user currentWeight:(CGFloat)currentWeight {
    NSString *currentLevel = @"";
    switch (targetType) {
        case TargetTypeWeight: currentLevel = [self getWeightCurrentLevel:scaleData user:user]; break;
        case TargetTypeBmi: currentLevel = [self getBMICurrentLevel:scaleData]; break;
        case TargetTypeBodyfat: currentLevel = [self getBodyFatCurrentLevel:scaleData user:user]; break;
        case TargetTypeSubfat:currentLevel = [self getSubFatCurrentLevel:scaleData user:user]; break;
        case TargetTypeVisfat: currentLevel = [self getVisfatCurrentLevel:scaleData]; break;
        case TargetTypeWater: currentLevel = [self getWaterCurrentLevel:scaleData user:user]; break;
        case TargetTypeMuscle: currentLevel = [self getMuscleCurrentLevel:scaleData user:user]; break;
        case TargetTypeBone: currentLevel = [self getBoneCurrentLevel:scaleData user:user currentWeight:currentWeight]; break;
        case TargetTypeBmr:break;
        case TargetTypeBodyShape: currentLevel = [self getBodyShapeCurrentLevel:scaleData user:user]; break;
        case TargetTypeProtein: currentLevel = [self getProteinCurrentLevel:scaleData user:user]; break;
        case TargetTypeFatFreeWeight: currentLevel = @"标准"; break;
        case TargetTypeSinew: currentLevel = [self getSinewCurrentLevel:scaleData user:user]; break;
        case TargetTypeBodyage: currentLevel = @"达标"; break;
        case TargetTypeHeartRate:break;
        case TargetTypeCardiacIndex:break;
        case TargetTypeFatMass:break;
        default: break;
    }
    return currentLevel;
}

/** 体重 */
+ (NSString *)getWeightCurrentLevel:(QNScaleItemData *)scaleData user:(QNUser *)user {
    
    NSString *currentLevel = @"标准";
    CGFloat standardWeight;
    if ([user.gender isEqualToString:@"male"]) {
        standardWeight = (user.height - 80) * 0.7;
    }else {
        standardWeight = ((user.height * 1.37) - 110) * 0.45;
    }
    
    CGFloat lowerWeight = standardWeight * 0.8;
    CGFloat lowWeight = standardWeight * 0.9;
    CGFloat highWeight = standardWeight * 1.1;
    CGFloat higherWeight = standardWeight * 1.2;
    if (scaleData.value <= lowerWeight) {
        currentLevel = @"严重偏低";
    }else if (scaleData.value < lowWeight) {
        currentLevel = @"偏低";
    }else if (scaleData.value <= highWeight) {
        currentLevel = @"标准";
    }else if (scaleData.value <= higherWeight) {
        currentLevel = @"偏高";
    }else {
        currentLevel = @"严重偏高";
    }
    return currentLevel;
}

/** BMI */
+ (NSString *)getBMICurrentLevel:(QNScaleItemData *)scaleData {
    NSString *currentLevel = @"标准";
    if (scaleData.value < 18.5) {
        currentLevel = @"偏低";
    }else if (scaleData.value <= 25) {
        currentLevel = @"标准";
    }else {
        currentLevel = @"偏高";
    }
    return currentLevel;
}

/** 体脂率 */
+ (NSString *)getBodyFatCurrentLevel:(QNScaleItemData *)scaleData user:(QNUser *)user {
    NSString *currentLevel = @"标准";
    if ([user.gender isEqualToString:@"male"]) {
        if (scaleData.value < 11) {
            currentLevel = @"偏低";
        }else if (scaleData.value <= 21) {
            currentLevel = @"标准";
        }else if (scaleData.value <= 26) {
            currentLevel = @"偏高";
        }else {
            currentLevel = @"严重偏高";
        }
    }else {
        if (scaleData.value < 21) {
            currentLevel = @"偏低";
        }else if (scaleData.value <= 31) {
            currentLevel = @"标准";
        }else if (scaleData.value <= 36) {
            currentLevel = @"偏高";
        }else {
            currentLevel = @"严重偏高";
        }
    }
    return currentLevel;
}

/**  内脏脂肪 */
+ (NSString *)getVisfatCurrentLevel:(QNScaleItemData *)scaleData {
    NSString *currentLevel = @"标准";
    if (scaleData.value <= 9) {
        currentLevel = @"标准";
    }else if (scaleData.value <= 14) {
        currentLevel = @"偏高";
    }else {
        currentLevel = @"严重偏高";
    }
    return currentLevel;
}

/** 体水分 */
+ (NSString *)getWaterCurrentLevel:(QNScaleItemData *)scaleData user:(QNUser *)user {
    NSString *currentLevel = @"标准";
    if ([user.gender isEqualToString:@"male"]) {
        if (scaleData.value < 55) {
            currentLevel = @"偏低";
        }else if (scaleData.value <= 65) {
            currentLevel = @"标准";
        }else {
            currentLevel = @"充足";
        }
    }else {
        if (scaleData.value < 45) {
            currentLevel = @"偏低";
        }else if (scaleData.value <= 60) {
            currentLevel = @"标准";
        }else {
            currentLevel = @"充足";
        }
    }
    return currentLevel;
}

/** 骨量 */
+ (NSString *)getBoneCurrentLevel:(QNScaleItemData *)scaleData user:(QNUser *)user currentWeight:(CGFloat)currentWeight{
    NSString *currentLevel = @"标准";
    
    if ([user.gender isEqualToString:@"male"]) {
        
        if (currentWeight <= 60) {
            if (scaleData.value < 2.3) {
                currentLevel = @"偏低";
            }else if (scaleData.value <= 2.7) {
                currentLevel = @"标准";
            }else {
                currentLevel = @"偏高";
            }
        }else if (currentWeight <= 75) {
            if (scaleData.value < 2.7) {
                currentLevel = @"偏低";
            }else if (scaleData.value <= 3.1) {
                currentLevel = @"标准";
            }else {
                currentLevel = @"偏高";
            }
        }else {
            if (scaleData.value < 3.0) {
                currentLevel = @"偏低";
            }else if (scaleData.value <= 3.4) {
                currentLevel = @"标准";
            }else {
                currentLevel = @"偏高";
            }
        }
    }else {
        if (currentWeight <= 45) {
            if (scaleData.value < 1.6) {
                currentLevel = @"偏低";
            }else if (scaleData.value <= 2.0) {
                currentLevel = @"标准";
            }else {
                currentLevel = @"偏高";
            }
        }else if (currentWeight <= 60) {
            if (scaleData.value < 2.0) {
                currentLevel = @"偏低";
            }else if (scaleData.value <= 2.4) {
                currentLevel = @"标准";
            }else {
                currentLevel = @"偏高";
            }
        }else {
            if (scaleData.value < 2.3) {
                currentLevel = @"偏低";
            }else if (scaleData.value <= 2.7) {
                currentLevel = @"标准";
            }else {
                currentLevel = @"偏高";
            }
        }
    }
    return currentLevel;
}

/** 皮下脂肪 */
+ (NSString *)getSubFatCurrentLevel:(QNScaleItemData *)scaleData user:(QNUser *)user {
    NSString *currentLevel = @"标准";
    if ([user.gender isEqualToString:@"male"]) {
        if (scaleData.value < 8.6) {
            currentLevel = @"偏低";
        }else if (scaleData.value <= 16.7) {
            currentLevel = @"标准";
        }else {
            currentLevel = @"偏高";
        }
    }else {
        if (scaleData.value < 18.5) {
            currentLevel = @"偏低";
        }else if (scaleData.value <= 26.7) {
            currentLevel = @"标准";
        }else {
            currentLevel = @"偏高";
        }
    }
    return currentLevel;
}

/** 骨骼肌率 */
+ (NSString *)getMuscleCurrentLevel:(QNScaleItemData *)scaleData user:(QNUser *)user {
    NSString *currentLevel = @"标准";
    if ([user.gender isEqualToString:@"male"]) {
        if (scaleData.value < 49) {
            currentLevel = @"偏低";
        }else if (scaleData.value <= 59) {
            currentLevel = @"标准";
        }else {
            currentLevel = @"偏高";
        }
    }else {
        if (scaleData.value < 40) {
            currentLevel = @"偏低";
        }else if (scaleData.value <= 50) {
            currentLevel = @"标准";
        }else {
            currentLevel = @"偏高";
        }
    }
    return currentLevel;
}

/** 体型 */
+ (NSString *)getBodyShapeCurrentLevel:(QNScaleItemData *)scaleData user:(QNUser *)user {
    int bodyShape = (int)scaleData.value;
    NSString *currentLevel = @"";
    switch (bodyShape) {
        case 1: currentLevel = @"隐形肥胖型";  break;
        case 2: currentLevel = @"运动不足型";  break;
        case 3: currentLevel = @"偏瘦型";  break;
        case 4: currentLevel = @"标准型";  break;
        case 5: currentLevel = @"偏瘦肌肉型";  break;
        case 6: currentLevel = @"肥胖型";  break;
        case 7: currentLevel = @"偏胖型";  break;
        case 8: currentLevel = @"标准肌肉型";  break;
        case 9: currentLevel = @"非常肌肉型";  break;
        default:
            break;
    }
    return currentLevel;
}

/** 基础代谢 */
+ (NSString *)getBmrCurrentLevel:(QNScaleItemData *)scaleData user:(QNUser *)user {
    NSString *currentLevel = @"";
    return currentLevel;
}

/** 蛋白质 */
+ (NSString *)getProteinCurrentLevel:(QNScaleItemData *)scaleData user:(QNUser *)user {
    NSString *currentLevel = @"标准";
    if ([user.gender isEqualToString:@"male"]) {
        if (scaleData.value < 16) {
            currentLevel = @"偏低";
        }else if (scaleData.value <= 18) {
            currentLevel = @"标准";
        }else {
            currentLevel = @"充足";
        }
    }else {
        if (scaleData.value < 14) {
            currentLevel = @"偏低";
        }else if (scaleData.value <= 16) {
            currentLevel = @"标准";
        }else {
            currentLevel = @"充足";
        }
    }
    return currentLevel;
}

/** 体年龄 */
+ (NSString *)getBodyAgeCurrentLevel:(QNScaleItemData *)scaleData user:(QNUser *)user {
    NSString *currentLevel = @"";
    return currentLevel;
}

/** 肌肉量 */
+ (NSString *)getSinewCurrentLevel:(QNScaleItemData *)scaleData user:(QNUser *)user {
    NSString *currentLevel = @"标准";
    int height = user.height;
    
    if ([user.gender isEqualToString:@"male"]) {
        
        if (height < 160) {
            if (scaleData.value < 38.5) {
                currentLevel = @"偏低";
            }else if (scaleData.value <= 46.5) {
                currentLevel = @"标准";
            }else {
                currentLevel = @"充足";
            }
        }else if (height <= 170) {
            if (scaleData.value < 44) {
                currentLevel = @"偏低";
            }else if (scaleData.value <= 52.4) {
                currentLevel = @"标准";
            }else {
                currentLevel = @"充足";
            }
        }else {
            if (scaleData.value < 49.4) {
                currentLevel = @"偏低";
            }else if (scaleData.value <= 59.4) {
                currentLevel = @"标准";
            }else {
                currentLevel = @"充足";
            }
        }
    }else {
        if (height < 150) {
            if (scaleData.value < 29.1) {
                currentLevel = @"偏低";
            }else if (scaleData.value <= 34.7) {
                currentLevel = @"标准";
            }else {
                currentLevel = @"充足";
            }
        }else if (height <= 160) {
            if (scaleData.value < 32.9) {
                currentLevel = @"偏低";
            }else if (scaleData.value <= 37.5) {
                currentLevel = @"标准";
            }else {
                currentLevel = @"充足";
            }
        }else {
            if (scaleData.value < 36.5) {
                currentLevel = @"偏低";
            }else if (scaleData.value <= 42.5) {
                currentLevel = @"标准";
            }else {
                currentLevel = @"充足";
            }
        }
    }
    return currentLevel;
}
@end
