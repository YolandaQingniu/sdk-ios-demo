//
//  QNDataCypher.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/2/26.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNDataCypher.h"
#import "algorithm.h"
#import "QNAESCrypt.h"
#import "QNDataTool.h"

@implementation QNDataCypher

#pragma mark -
+ (QNDataCypher *)buildCypherWithWeight:(double)weight res:(NSInteger)res secRes:(NSInteger)secRes resAdjust:(NSInteger)resAdjust secResAdjust:(NSInteger)secResAdjust timeTemp:(long)timeTemp device:(nonnull QNAuthDevice *)device heartRate:(NSInteger)heartRate {
    QNDataCypher *dataCypher = [[QNDataCypher alloc] init];
    dataCypher.weight = weight;
    [dataCypher setValue:[NSNumber numberWithInteger:res] forKeyPath:@"resistance"];
    [dataCypher setValue:[NSNumber numberWithInteger:secRes] forKeyPath:@"secResistance"];
    [dataCypher setValue:[NSNumber numberWithInteger:resAdjust] forKeyPath:@"resistanceAdjust"];
    [dataCypher setValue:[NSNumber numberWithInteger:secResAdjust] forKeyPath:@"secResistanceAdjust"];
    [dataCypher setValue:[NSNumber numberWithLong:timeTemp] forKeyPath:@"timeTemp"];
    [dataCypher setValue:device forKeyPath:@"authDevice"];
    dataCypher.heartRate = (int)heartRate;
    return dataCypher;
}

+ (QNDataCypher *)buildCypherWithWeight:(double)weight res:(NSInteger)res secRes:(NSInteger)secRes timeTemp:(long)timeTemp device:(nonnull QNAuthDevice *)device heartRate:(NSInteger)heartRate {
    return [self buildCypherWithWeight:weight res:res secRes:secRes resAdjust:0 secResAdjust:0 timeTemp:timeTemp device:device heartRate:heartRate];
}

+ (QNDataCypher *)buildHeihgtWeightCypherWithWeight:(double)weight res:(NSInteger)res secRes:(NSInteger)secRes timeTemp:(long)timeTemp device:(QNAuthDevice *)device height:(double)height mode:(QNHeightWeightMode)heightWeightMode {
    QNDataCypher *dataCypher = [self buildCypherWithWeight:weight res:res secRes:secRes resAdjust:0 secResAdjust:0 timeTemp:timeTemp device:device heartRate:0];
    dataCypher.height = height;
    dataCypher.heigtWeightMode = heightWeightMode;
    return dataCypher;
}


#pragma mark -
+ (double)calculateCurWeightWithUser:(QNUser *)user weight:(double)weight {
    //减去衣服重量
    if (user.clothesWeight > weight / 2.0) {
        weight = weight / 2.0;
    }else {
        weight = weight - user.clothesWeight;
    }
    return weight;
}

+ (int)calculateMethodWithUser:(QNUser *)user device:(QNAuthDevice *)device {
    int method = (int)device.method;
    //自主选择算法
    if (user.shapeType == YLUserShapeSlim) {
        if (user.goalType == YLUserGoalLoseFat || user.goalType == YLUserGoalStayHealth || user.goalType == YLUserGoalGainMuscle ) {
            method = 2;
        }
    }else if (user.shapeType == YLUserShapeNormal){
        if (user.goalType == YLUserGoalLoseFat || user.goalType == YLUserGoalStayHealth || user.goalType == YLUserGoalGainMuscle) {
            method = 2;
        }
    }else if (user.shapeType == YLUserShapeStrong){
         if(user.goalType == YLUserGoalPowerLittleExercise || user.goalType == YLUserGoalPowerOftenRun ){
            method = 4;
        }
    }else if (user.shapeType == YLUserShapePlim){
        if (user.goalType == YLUserGoalLoseFat || user.goalType == YLUserGoalStayHealth || user.goalType == YLUserGoalGainMuscle ) {
            method = 2;
        }
    }
    return method;
}

+ (BOOL)calculateSportModeWithUser:(QNUser *)user {
    BOOL sportFlag = NO;
    if ([QNUser getAgeWithBirthday:user.birthday] >= 18) {
        sportFlag = (user.athleteType == YLAthleteSport) || (user.shapeType == YLUserShapeStrong && user.goalType == YLUserGoalPowerOftenExercise);
    }
    return sportFlag;
}


/// 必须调用该方法获取身高
- (double)getHeight {
    if (self.height > 0) {
        return self.height;
    }
    return self.user.height;
}

- (void)adjustResistance {
    if (self.resistanceAdjust == 0) [self setValue:[NSNumber numberWithInteger:self.resistance] forKeyPath:@"resistanceAdjust"];
    if (self.secResistanceAdjust == 0) [self setValue:[NSNumber numberWithInteger:self.secResistance] forKeyPath:@"secResistanceAdjust"];
    
    char *encrypt = encryptResistance(self.weight, (int)self.resistance, (int)self.secResistance);
    NSArray *resList = [[NSString stringWithFormat:@"%s",encrypt] componentsSeparatedByString:@","];
    
    if (resList.count == 2) {
        int encryptSec50 = 0;
        int encryptSec500 = 0;
        [[NSScanner scannerWithString:resList.firstObject] scanInt:&encryptSec50];
        [[NSScanner scannerWithString:resList.lastObject] scanInt:&encryptSec500];
        self.encryRes50 = encryptSec50;
        self.encryRes500 = encryptSec500;
    }
    
    NSMutableDictionary *hmacJson = [NSMutableDictionary dictionary];
    hmacJson[@"resistance_50_adjust"] = [NSNumber numberWithInteger:self.resistanceAdjust];
    hmacJson[@"resistance_500_adjust"] = [NSNumber numberWithInteger:self.secResistanceAdjust];
    hmacJson[@"resistance_50"] = [NSNumber numberWithInteger:self.resistance];
    hmacJson[@"resistance_500"] = [NSNumber numberWithInteger:self.secResistance];
    hmacJson[@"last_resistance_50_adjust"] = [NSNumber numberWithInteger:self.lastResistanceAdjust];
    hmacJson[@"last_resistance_500_adjust"] = [NSNumber numberWithInteger:self.lastSecResistanceAdjust];
    self.hmac = [QNAESCrypt AES128Encrypt:[[QNDataTool sharedDataTool] dictionaryToJson:hmacJson]];
}

//计算额外指标，该方法必须在计算标准指标之后调用
- (void)calculateExtraTarget {
    int fattyRiskLevel = 0;
    if (self.visceralFat >= 15) {
        fattyRiskLevel = 4;
    } else if (self.visceralFat >= 13) {
        fattyRiskLevel = 3;
    } else if (self.visceralFat >= 10) {
        fattyRiskLevel = 2;
    } else if (self.visceralFat >= 8) {
        fattyRiskLevel = 1;
    } else {
        fattyRiskLevel = 0;
    }
    self.fattyRisk = fattyRiskLevel;
    
    if (self.bodyfatRate != 0) {
        self.bodyFatWeight = self.weight * self.bodyfatRate / 100.0;
        self.obesity = [self obesityLevelWithHeight:[self getHeight] gender:self.user.gender weight:self.weight];
        
        self.waterWeight = self.weight * self.bodyWaterRate / 100.0;
        self.proteinWeight = self.weight * self.protein / 100.0;
        self.mineralLevel = [self mineralLevelWithBone:self.boneMass height:[self getHeight] gender:self.user.gender weight:self.weight];
        self.dreamWeight = [self dreamWeightWithHeight:[self getHeight] gender:self.user.gender];
        self.standWeight = [self standWeightWithHeight:[self getHeight] gender:self.user.gender];
                
        [self weightAndBodyfatAndMuscleMassControlWithGender:self.user.gender bodyfat:self.bodyfatRate weight:self.weight muscleMass:self.muscleMass height:[self getHeight]];
        
        self.muscleMassRate = self.muscleMass / self.weight * 100;
    }
}

- (void)calculateMeasureDataWithUser:(QNUser *)user {
    if (self.authDevice == nil) return;
    [self setValue:user forKeyPath:@"user"];
    
    int gender = [user.gender isEqualToString:@"male"] ? 1 : 0;
    int height = [self getHeight];
    int age = [QNUser getAgeWithBirthday:self.user.birthday];
    
    self.weight = [QNDataCypher calculateCurWeightWithUser:user weight:self.weight];
    int method = [QNDataCypher calculateMethodWithUser:user device:self.authDevice];
    
    //运动员模式
    BOOL sportFlag = [QNDataCypher calculateSportModeWithUser:user];
    
    //设置阻抗调整
    [self adjustResistance];
    
    QNData *data = algorithmWithAthlete(method, height, age, gender, self.weight, (int)self.resistanceAdjust, (int)self.secResistanceAdjust, sportFlag);

    double bmi = calcBmi(height, data -> weight);
    
    if (self.height > 0) {
        bmi = self.weight / ([self getHeight] / 100 * [self getHeight] / 100);
    }
    
    self.weight = data -> weight;
    self.BMI = bmi;
    self.bodyfatRate = data -> bodyfat;
    self.subcutaneousFat = data -> subfat;
    self.visceralFat = data -> visfat;
    self.bodyWaterRate = data -> water;
    self.muscleRate = data -> muscle;
    self.boneMass = data -> bone;
    self.BMR = data -> bmr;
    self.bodyType = data -> bodyShape;
    self.protein = data -> protein;
    self.leanBodyWeight = data -> lbm;
    self.muscleMass = data -> muscleMass;
    self.metabolicAge = data -> bodyAge;
    self.healthScore = data -> score;
    
    qdouble heartIndex = calcHeartIndex(height, age, gender, self.weight, self.heartRate);
    self.heartIndex = heartIndex;
    
    [self calculateExtraTarget];
}

- (void)calculateWspMeasureDataWithUser:(QNUser *)user {
    if (self.authDevice == nil) return;
    [self setValue:user forKeyPath:@"user"];
    //设置阻抗调整
    [self adjustResistance];
    //计算额外指标
    [self calculateExtraTarget];
}

#pragma mark 指标控制
- (void)weightAndBodyfatAndMuscleMassControlWithGender:(NSString *)gender bodyfat:(double)bodyfat weight:(double)weight muscleMass:(double)muscleMass height:(double)height{
    
    double weightControl = 0;
    double bodyFatControl = 0;
    double muscleMassControl = 0;

    double standBodyFat = [gender isEqualToString:@"male"] ? 15.0 : 22.0;
    double standWeight = [self standWeightWithHeight:height gender:gender];
    if (bodyfat > standBodyFat + 1 && weight > standWeight) {
        bodyFatControl = (standBodyFat - bodyfat) * weight / 100.0;
        muscleMassControl = fabs(bodyFatControl / 3.0);
        weightControl = bodyFatControl + muscleMassControl;
    }else if (bodyfat < standBodyFat && weight < standWeight - 1) {
        weightControl = standWeight - weight;
        muscleMassControl = weightControl * 2 / 3.0;
        bodyFatControl = weightControl / 3.0;
    }
    self.weightControl = weightControl;
    self.bodyFatControl = bodyFatControl;
    self.muscleMassControl = muscleMassControl;
}


#pragma mark 无机盐
- (QNMineralLevel)mineralLevelWithBone:(double)bone height:(double)height gender:(NSString *)gender weight:(double)weight {
    QNMineralLevel level = QNMineralNone;
    if ([gender isEqualToString:@"male"]) {
        if (weight <= 60) {
            if (bone < 2.3) {
                level = QNMineralLow;
            }else if (bone <= 2.7) {
                level = QNMineralStand;
            }else {
                level = QNMineralEnough;
            }
        }else if (weight < 75) {
            if (bone < 2.7) {
                level = QNMineralLow;
            }else if (bone <= 3.1) {
                level = QNMineralStand;
            }else {
                level = QNMineralEnough;
            }
        }else {
            if (bone < 3.0) {
                level = QNMineralLow;
            }else if (bone <= 3.4) {
                level = QNMineralStand;
            }else {
                level = QNMineralEnough;
            }
        }
    }else {
        if (weight <= 45) {
            if (bone < 1.6) {
                level = QNMineralLow;
            }else if (bone <= 2.0) {
                level = QNMineralStand;
            }else {
                level = QNMineralEnough;
            }
        }else if (weight < 60) {
            if (bone < 2.0) {
                level = QNMineralLow;
            }else if (bone <= 2.4) {
                level = QNMineralStand;
            }else {
                level = QNMineralEnough;
            }
        }else {
            if (bone < 2.3) {
                level = QNMineralLow;
            }else if (bone <= 2.7) {
                level = QNMineralStand;
            }else {
                level = QNMineralEnough;
            }
        }
    }
    return level;
}

#pragma mark 肥胖度
- (double)obesityLevelWithHeight:(double)height gender:(NSString *)gender weight:(double)weight {
    double standWeight = [self standWeightWithHeight:height gender:gender];
    double obesityLevel = (weight - standWeight) / standWeight * 100.0;
    if (obesityLevel < 0) return 0.0;
    if (obesityLevel > 100) obesityLevel = 100.0;
    return obesityLevel;
}

#pragma mark 标准体重
- (double)standWeightWithHeight:(double)height gender:(NSString *)gender {
    if ([gender isEqualToString:@"male"]) {
        return (height - 80) * 0.7;
    }else {
        return (height * 1.37 - 110) * 0.45;
    }
}

#pragma mark 理想视觉体重
- (double)dreamWeightWithHeight:(double)height gender:(NSString *)gender {
    if ([gender isEqualToString:@"male"]) {
        return (height - 100) * 0.9;
    }else {
        return (height - 100) * 0.8;
    }
}
@end
