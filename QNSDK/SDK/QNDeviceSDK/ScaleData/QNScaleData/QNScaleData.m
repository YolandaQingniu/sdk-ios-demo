//
//  QNScaleData.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNScaleData.h"
#import "QNScaleData+QNAddition.h"
#import "QNDebug.h"
#import "QNAESCrypt.h"
#import "QNDataTool.h"
#import "NSError+QNAPI.h"

#define QNScaleTypeResistance_50 33
#define QNScaleTypeResistance_500 34

@implementation QNScaleData

- (NSString *)hmac {
    return self.dataCypher.hmac;
}

- (double)weight {
    return self.dataCypher.weight;
}

- (NSInteger)resistance50 {
    return (NSInteger)self.dataCypher.encryRes50;
}

- (NSInteger)resistance500 {
    return (NSInteger)self.dataCypher.encryRes500;
}

- (QNScaleItemData *)getItem:(QNScaleType)type {
    if ([self showScaleType:type] == NO) {
        return nil;
    }
    double value = 0;
    QNValueType valueType = QNValueTypeDouble;
    NSString *name = nil;
    switch (type) {
        case QNScaleTypeWeight:
            value = self.dataCypher.weight;
            name = @"weight";
            break;
            
        case QNScaleTypeBMI:
            value = self.dataCypher.BMI;
            name = @"BMI";
            break;
            
        case QNScaleTypeBodyFatRate:
            value = self.dataCypher.bodyfatRate;
            name = @"body fat rate";
            break;
            
        case QNScaleTypeSubcutaneousFat:
            value = self.dataCypher.subcutaneousFat;
            name = @"subcutaneous fat";
            break;
            
        case QNScaleTypeVisceralFat:
            value = self.dataCypher.visceralFat;
            valueType = QNValueTypeInt;
            name = @"visceral fat";
            break;
            
        case QNScaleTypeBodyWaterRate:
            value = self.dataCypher.bodyWaterRate;
            name = @"body water rate";
            break;
            
        case QNScaleTypeMuscleRate:
            value = self.dataCypher.muscleRate;
            name = @"muscle rate";
            break;
            
        case QNScaleTypeBoneMass:
            value = self.dataCypher.boneMass;
            name = @"bone mass";
            break;
            
        case QNScaleTypeBMR:
            value = self.dataCypher.BMR;
            valueType = QNValueTypeInt;
            name = @"BMR";
            break;
            
        case QNScaleTypeBodyType:
            value = self.dataCypher.bodyType;
            valueType = QNValueTypeInt;
            name = @"body type";
            break;
            
        case QNScaleTypeProtein:
            value = self.dataCypher.protein;
            name = @"protein";
            break;
            
        case QNScaleTypeLeanBodyWeight:
            value = self.dataCypher.leanBodyWeight;
            name = @"lean body weight";
            break;
            
        case QNScaleTypeMuscleMass:
            value = self.dataCypher.muscleMass;
            name = @"muscle mass";
            break;
            
        case QNScaleTypeMetabolicAge:
            value = self.dataCypher.metabolicAge;
            valueType = QNValueTypeInt;
            name = @"metabolic age";
            break;
            
        case QNScaleTypeHealthScore:
            value = self.dataCypher.healthScore;
            name = @"health score";
            break;
            
        case QNScaleTypeHeartRate:
            value = self.dataCypher.heartRate;
            valueType = QNValueTypeInt;
            name = @"heart rate";
            break;
            
        case QNScaleTypeHeartIndex:
            value = self.dataCypher.heartIndex;
            name = @"heart index";
            break;

        case QNScaleTypeFatMassIndex:
            value = self.dataCypher.bodyFatWeight;
            name = @"fat mass";
            break;
            
        case QNScaleTypeObesityDegreeIndex:
            value = self.dataCypher.obesity;
            name = @"obesity degree";
            break;
            
        case QNScaleTypeWaterContentIndex:
            value = self.dataCypher.waterWeight;
            name = @"water content";
            break;
            
        case QNScaleTypeProteinMassIndex:
            value = self.dataCypher.proteinWeight;
            name = @"protein mass";
            break;
            
        case QNScaleTypeMineralSaltIndex:
            value = self.dataCypher.mineralLevel;
            valueType = QNValueTypeInt;
            name = @"mineral salt";
            break;
            
        case QNScaleTypeBestVisualWeightIndex:
            value = self.dataCypher.dreamWeight;
            name = @"best visual weight";
            break;
            
        case QNScaleTypeStandWeightIndex:
            value = self.dataCypher.standWeight;
            name = @"stand weight";
            break;
            
        case QNScaleTypeWeightControlIndex:
            value = self.dataCypher.weightControl;
            name = @"weight control";
            break;
            
        case QNScaleTypeFatControlIndex:
            value = self.dataCypher.bodyFatControl;
            name = @"fat control";
            break;
          
        case QNScaleTypeMuscleControlIndex:
            value = self.dataCypher.muscleMassControl;
            name = @"muscle control";
            break;
            
        case QNScaleTypeMuscleMassRate:
            value = self.dataCypher.muscleMassRate;
            name = @"muscle mass rate";
            break;
            
        case QNScaleTypeFattyLiverRisk:
            value = self.dataCypher.fattyRisk;
            valueType = QNValueTypeInt;
            name = @"fatty liver risk";
            break;
        
        case QNScaleTypeResistance_50:
        {
            NSInteger res = self.dataCypher.resistanceAdjust;
            NSInteger secRes = self.dataCypher.secResistanceAdjust;
            if (secRes == 0) secRes = res;
            value = floor(res / 3.0 + secRes);
            valueType = QNValueTypeInt;
            name = @"resistance 50khz";
        }
            break;
            
        case QNScaleTypeResistance_500:
        {
            NSInteger res = self.dataCypher.resistanceAdjust;
            NSInteger secRes = self.dataCypher.secResistanceAdjust;
            if (secRes == 0) secRes = res;
            value = floor((res + secRes) / 2.0);
            valueType = QNValueTypeInt;
            name = @"resistance 500khz";
        }
            break;
            
    }
    QNScaleItemData *itemData = [self createScaleItemDataForQNScaleType:type scaleValue:value valueType:valueType name:name];
    return itemData;
}

- (BOOL)showScaleType:(QNScaleType)scaleType {
        switch (scaleType) {
            case QNScaleTypeWeight: return (self.dataCypher.authDevice.bodyIndexFlag >> 1) & 0x01;
            case QNScaleTypeBMI: return (self.dataCypher.authDevice.bodyIndexFlag >> 2) & 0x01;
            case QNScaleTypeBodyFatRate: return (self.dataCypher.authDevice.bodyIndexFlag >> 3) & 0x01;
            case QNScaleTypeSubcutaneousFat: return (self.dataCypher.authDevice.bodyIndexFlag >> 4) & 0x01;
            case QNScaleTypeVisceralFat: return (self.dataCypher.authDevice.bodyIndexFlag >> 5) & 0x01;
            case QNScaleTypeBodyWaterRate: return (self.dataCypher.authDevice.bodyIndexFlag >> 6) & 0x01;
            case QNScaleTypeMuscleRate: return (self.dataCypher.authDevice.bodyIndexFlag >> 7) & 0x01;
            case QNScaleTypeBoneMass: return (self.dataCypher.authDevice.bodyIndexFlag >> 8) & 0x01;
            case QNScaleTypeBMR: return (self.dataCypher.authDevice.bodyIndexFlag >> 9) & 0x01;
            case QNScaleTypeBodyType: return (self.dataCypher.authDevice.bodyIndexFlag >> 10) & 0x01;
            case QNScaleTypeProtein: return (self.dataCypher.authDevice.bodyIndexFlag >> 11) & 0x01;
            case QNScaleTypeLeanBodyWeight: return (self.dataCypher.authDevice.bodyIndexFlag >> 12) & 0x01;
            case QNScaleTypeMuscleMass: return (self.dataCypher.authDevice.bodyIndexFlag >> 13) & 0x01;
            case QNScaleTypeMetabolicAge: return (self.dataCypher.authDevice.bodyIndexFlag >> 14) & 0x01;
            case QNScaleTypeHealthScore: return (self.dataCypher.authDevice.bodyIndexFlag >> 15) & 0x01;
            case QNScaleTypeHeartRate: return ((self.dataCypher.authDevice.bodyIndexFlag >> 16) & 0x01) || self.dataCypher.heartRate > 0;
            case QNScaleTypeHeartIndex: return (self.dataCypher.authDevice.bodyIndexFlag >> 17) & 0x01;
            case QNScaleTypeFatMassIndex:
            case QNScaleTypeObesityDegreeIndex:
            case QNScaleTypeWaterContentIndex:
            case QNScaleTypeProteinMassIndex:
            case QNScaleTypeMineralSaltIndex:
            case QNScaleTypeBestVisualWeightIndex:
            case QNScaleTypeStandWeightIndex:
            case QNScaleTypeWeightControlIndex:
            case QNScaleTypeFatControlIndex:
            case QNScaleTypeMuscleControlIndex:
            case QNScaleTypeMuscleMassRate:
                return self.dataCypher.authDevice.otherTargetFlag;
            case QNScaleTypeFattyLiverRisk:
                return (self.dataCypher.authDevice.bodyIndexFlag >> 18) & 0x01;
            case QNScaleTypeResistance_50:
            case QNScaleTypeResistance_500:
               return (self.dataCypher.authDevice.bodyIndexFlag >> 19) & 0x01;
            default:
                return NO;
                break;
        }
}


- (QNScaleItemData *)createScaleItemDataForQNScaleType:(QNScaleType)type scaleValue:(double)value valueType:(QNValueType)valueType name:(NSString *)name{
    QNScaleItemData *itemData = [[QNScaleItemData alloc] init];
    [itemData setValue:[NSNumber numberWithUnsignedInteger:type] forKeyPath:@"type"];
    [itemData setValue:[NSNumber numberWithDouble:value] forKeyPath:@"value"];
    [itemData setValue:[NSNumber numberWithUnsignedInteger:valueType] forKeyPath:@"valueType"];
    [itemData setValue:name forKeyPath:@"name"];
    return itemData;
}


- (double)getItemValue:(QNScaleType)type {
    return [self getItem:type].value;
}

- (NSArray<QNScaleItemData *> *)getAllItem {
    NSMutableArray *resultAll = [NSMutableArray array];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeWeight] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeBMI] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeBodyFatRate] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeSubcutaneousFat] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeVisceralFat] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeBodyWaterRate] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeMuscleRate] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeBoneMass] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeBMR] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeBodyType] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeProtein] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeLeanBodyWeight] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeMuscleMass] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeMetabolicAge] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeHealthScore] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeHeartRate] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeHeartIndex] array:resultAll];
    
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeFatMassIndex] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeObesityDegreeIndex] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeWaterContentIndex] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeProteinMassIndex] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeMineralSaltIndex] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeBestVisualWeightIndex] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeStandWeightIndex] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeWeightControlIndex] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeFatControlIndex] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeMuscleControlIndex] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeMuscleMassRate] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeFattyLiverRisk] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeResistance_50] array:resultAll];
    [self allItemAddScaleItemData:[self getItem:QNScaleTypeResistance_500] array:resultAll];

    if (QNDebugLogIsVail) {
        NSString *userDetail = [NSString stringWithFormat:@"用户信息: userId:%@ height:%d gender: %@ birthday:%@ clothesWeight: %f athleteType: %lu shapeType:%lu goalType:%lu ",self.user.userId,self.user.height,self.user.gender,self.user.birthday,self.user.clothesWeight,(unsigned long)self.user.athleteType,(unsigned long)self.user.shapeType,(unsigned long)self.user.goalType];
        
        NSString *detail = [NSString stringWithFormat:@"指标个数: %lu",(unsigned long)resultAll.count];
        for (QNScaleItemData *itemData in resultAll) {
            detail = [NSString stringWithFormat:@"%@ %@:  %.2f",detail,itemData.name,itemData.value];
        }
        [[QNDebug sharedDebug] log:[NSString stringWithFormat:@"%@  %@  %@\n",userDetail,detail,self.hmac]];
    }
    return [resultAll mutableCopy];
}

- (void)allItemAddScaleItemData:(QNScaleItemData *)item array:(NSMutableArray *)ary {
    if (item) {
        [ary addObject:item];
    }
}


- (void)setFatThreshold:(double)threshold hmac:(NSString *)hmac callBlock:(QNResultCallback)callback{
    NSString *decrypt = [QNAESCrypt AES128Decrypt:hmac];
    NSDictionary *resultDic = [[QNDataTool sharedDataTool] jsonTodictionary:decrypt];
    if (resultDic == nil || ![resultDic.allKeys containsObject:@"resistance_50_adjust"] || ![resultDic.allKeys containsObject:@"resistance_500_adjust"]) {
        [NSError errorCode:QNBleErrorCodeIllegalArgument callBack:callback];
        return;
    }
    
    NSInteger lastRes = [[QNDataTool sharedDataTool] toInteger:resultDic[@"resistance_50_adjust"]];
    NSInteger lastSecRes = [[QNDataTool sharedDataTool] toInteger:resultDic[@"resistance_500_adjust"]];
    
    if (lastRes <= 0) {
        [NSError errorCode:QNBleErrorCodeIllegalArgument callBack:callback];
        return;
    }
    
    if (self.dataCypher.resistance == 0) {
        if (callback) {
            callback(nil);
        }
        return;
    }

    double maxDiff = threshold * 20;

    double resDiff = self.dataCypher.resistance - lastRes;
    double secResDiff = self.dataCypher.secResistance - lastSecRes;

    if (fabs(resDiff) > maxDiff) {
        if (resDiff > 0) {
            [self.dataCypher setValue:[NSNumber numberWithInt:lastRes + maxDiff] forKeyPath:@"resistanceAdjust"];
        }else {
            [self.dataCypher setValue:[NSNumber numberWithInt:lastRes - maxDiff] forKeyPath:@"resistanceAdjust"];
        }
    }
    
    if (fabs(secResDiff) > maxDiff) {
        if (secResDiff > 0) {
            [self.dataCypher setValue:[NSNumber numberWithInt:lastSecRes + maxDiff] forKeyPath:@"secResistanceAdjust"];
        }else {
            [self.dataCypher setValue:[NSNumber numberWithInt:lastSecRes - maxDiff] forKeyPath:@"secResistanceAdjust"];
        }
    }
    [self.dataCypher setValue:[NSNumber numberWithInteger:lastRes] forKeyPath:@"lastResistanceAdjust"];
    [self.dataCypher setValue:[NSNumber numberWithInteger:lastSecRes] forKeyPath:@"lastSecResistanceAdjust"];
    [self.dataCypher calculateMeasureDataWithUser:self.user];
    if (callback) {
        callback(nil);
    }
}


@end
