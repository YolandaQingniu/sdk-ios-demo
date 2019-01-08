//
//  QNScaleData.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNScaleData.h"
#import "QNScaleData+QNResultData.h"
#import "QNDebug.h"

@implementation QNScaleData

- (QNScaleItemData *)getItem:(QNScaleType)type {
    if ([self hiddenScaleType:type] == NO) {
        return nil;
    }
    double value = 0;
    QNValueType valueType = QNValueTypeDouble;
    NSString *name = nil;
    switch (type) {
        case QNScaleTypeWeight:
            value = self.resultData.weight;
            name = @"weight";
            break;
            
        case QNScaleTypeBMI:
            value = self.resultData.BMI;
            name = @"BMI";
            break;
            
        case QNScaleTypeBodyFatRate:
            value = self.resultData.bodyfatRate;
            name = @"BodyFatRate";
            break;
            
        case QNScaleTypeSubcutaneousFat:
            value = self.resultData.subcutaneousFat;
            name = @"SubcutaneousFat";
            break;
            
        case QNScaleTypeVisceralFat:
            value = self.resultData.visceralFat;
            valueType = QNValueTypeInt;
            name = @"VisceralFat";
            break;
            
        case QNScaleTypeBodyWaterRate:
            value = self.resultData.bodyWaterRate;
            name = @"BodyWaterRate";
            break;
            
        case QNScaleTypeMuscleRate:
            value = self.resultData.muscleRate;
            name = @"MuscleRate";
            break;
            
        case QNScaleTypeBoneMass:
            value = self.resultData.boneMass;
            name = @"BoneMass";
            break;
            
        case QNScaleTypeBMR:
            value = self.resultData.BMR;
            valueType = QNValueTypeInt;
            name = @"BMR";
            break;
            
        case QNScaleTypeBodyType:
            value = self.resultData.bodyType;
            valueType = QNValueTypeInt;
            name = @"BodyType";
            break;
            
        case QNScaleTypeProtein:
            value = self.resultData.protein;
            name = @"Protein";
            break;
            
        case QNScaleTypeLeanBodyWeight:
            value = self.resultData.leanBodyWeight;
            name = @"LeanBodyWeight";
            break;
            
        case QNScaleTypeMuscleMass:
            value = self.resultData.muscleMass;
            name = @"MuscleMass";
            break;
            
        case QNScaleTypeMetabolicAge:
            value = self.resultData.metabolicAge;
            valueType = QNValueTypeInt;
            name = @"MetabolicAge";
            break;
            
        case QNScaleTypeHealthScore:
            value = self.resultData.healthScore;
            name = @"HealthScore";
            break;
            
        case QNScaleTypeHeartRate:
            value = self.resultData.heartRate;
            valueType = QNValueTypeInt;
            name = @"HeartRate";
            break;
            
        case QNScaleTypeHeartIndex:
            value = self.resultData.heartIndex;
            name = @"HeartIndex";
            break;
    }
    QNScaleItemData *itemData = [self createScaleItemDataForQNScaleType:type scaleValue:value valueType:valueType name:name];
    return itemData;
}

- (BOOL)hiddenScaleType:(QNScaleType)scaleType {
        switch (scaleType) {
            case QNScaleTypeWeight:
                return (self.resultData.bodyIndexFlag >> 1) & 0x01;
                break;
                
            case QNScaleTypeBMI:
                return (self.resultData.bodyIndexFlag >> 2) & 0x01;
                break;
                
            case QNScaleTypeBodyFatRate:
                return (self.resultData.bodyIndexFlag >> 3) & 0x01;
                break;
                
            case QNScaleTypeSubcutaneousFat:
                return (self.resultData.bodyIndexFlag >> 4) & 0x01;
                break;
                
            case QNScaleTypeVisceralFat:
                return (self.resultData.bodyIndexFlag >> 5) & 0x01;
                break;
                
            case QNScaleTypeBodyWaterRate:
                return (self.resultData.bodyIndexFlag >> 6) & 0x01;
                break;
                
            case QNScaleTypeMuscleRate:
                return (self.resultData.bodyIndexFlag >> 7) & 0x01;
                break;
                
            case QNScaleTypeBoneMass:
                return (self.resultData.bodyIndexFlag >> 8) & 0x01;
                break;
                
            case QNScaleTypeBMR:
                return (self.resultData.bodyIndexFlag >> 9) & 0x01;
                break;
                
            case QNScaleTypeBodyType:
                return (self.resultData.bodyIndexFlag >> 10) & 0x01;
                break;
                
            case QNScaleTypeProtein:
                return (self.resultData.bodyIndexFlag >> 11) & 0x01;
                break;
                
            case QNScaleTypeLeanBodyWeight:
                return (self.resultData.bodyIndexFlag >> 12) & 0x01;
                break;
                
            case QNScaleTypeMuscleMass:
                return (self.resultData.bodyIndexFlag >> 13) & 0x01;
                break;
                
            case QNScaleTypeMetabolicAge:
                return (self.resultData.bodyIndexFlag >> 14) & 0x01;
                break;
                
            case QNScaleTypeHealthScore:
                return (self.resultData.bodyIndexFlag >> 15) & 0x01;
                break;
                
            case QNScaleTypeHeartRate:
                return ((self.resultData.bodyIndexFlag >> 16) & 0x01) || self.resultData.supportHeartRate;
                break;
                
            case QNScaleTypeHeartIndex:
                return (self.resultData.bodyIndexFlag >> 17) & 0x01;
                break;
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
    if (QNDebugLogIsVail) {
        
        NSString *userDetail = [NSString stringWithFormat:@"用户信息:\nuserId： %@\nheight: %d\ngender: %@\nbirthday: %@\nathleteType: %lu",self.user.userId,self.user.height,self.user.gender,self.user.birthday,(unsigned long)self.user.athleteType];
        
        NSString *detail = [NSString stringWithFormat:@"指标个数: %lu",(unsigned long)resultAll.count];
        for (QNScaleItemData *itemData in resultAll) {
            detail = [NSString stringWithFormat:@"%@\n%@:  %.2f",detail,itemData.name,itemData.value];
        }
        [[QNDebug sharedDebug] log:[NSString stringWithFormat:@"\n%@\n\n%@",userDetail,detail]];
    }
    return [resultAll mutableCopy];
}

- (void)allItemAddScaleItemData:(QNScaleItemData *)item array:(NSMutableArray *)ary {
    if (item) {
        [ary addObject:item];
    }
}


@end
