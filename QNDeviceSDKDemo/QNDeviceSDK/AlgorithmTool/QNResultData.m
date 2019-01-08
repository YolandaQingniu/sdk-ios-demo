//
//  QNResultData.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNResultData.h"
#import "algorithm.h"
#import "QNUser+QNAddition.h"

@implementation QNResultData

- (QNResultData *)reckonMeasureResult {
    if (self.user == nil) {
        return self;
    }
    int mehtodTemp = 4;
    if (self.method == QNAlgorithmMethodTwoElectrodeV1) {
        mehtodTemp = 2;
    }else if (self.method == QNAlgorithmMethodTwoElectrodeV2) {
        mehtodTemp = 5;
    }else if (self.method == QNAlgorithmMethodFourElectrodeV1) {
        mehtodTemp = 3;
    }else if (self.method == QNAlgorithmMethodFourElectrodeV2) {
        mehtodTemp = 4;
    }
    int gender = [self.user.gender isEqualToString:@"male"] ? 1 : 0;
    int height = self.user.height;
    int age = self.user.age;
    
    YLAthleteType athleteType = YLAthleteDefault;
    
    //自主选择算法
    if (self.user.shapeType != YLUserShapeNone && self.user.goalType != YLUserGoalNone) {
        if (self.user.shapeType == YLUserShapeSlim) {
            if (self.user.goalType == YLUserGoalLoseFat || self.user.goalType == YLUserGoalStayHealth || self.user.goalType == YLUserGoalGainMuscle ) {
                mehtodTemp = 2;
            }
        }else if (self.user.shapeType == YLUserShapeNormal){
            if (self.user.goalType == YLUserGoalLoseFat || self.user.goalType == YLUserGoalStayHealth || self.user.goalType == YLUserGoalGainMuscle ) {
                mehtodTemp = 2;
            }
        }else if (self.user.shapeType == YLUserShapeStrong){
            if (self.user.goalType == YLUserGoalPowerOftenExercise) {
                athleteType = YLAthleteSport;
            }else if(self.user.goalType == YLUserGoalPowerLittleExercise ||self.user.goalType == YLUserGoalPowerOftenRun ){
                mehtodTemp = 4;
            }
        }else if (self.user.shapeType == YLUserShapePlim){
            if (self.user.goalType == YLUserGoalLoseFat || self.user.goalType == YLUserGoalStayHealth || self.user.goalType == YLUserGoalGainMuscle ) {
                mehtodTemp = 2;
            }
        }
    }
    
    if (self.user.athleteType == YLAthleteSport) {
        athleteType = YLAthleteSport;
    }
    if (age < 18) {
        athleteType = YLAthleteDefault;
    }
    
    QNData *data = algorithmWithAthlete(mehtodTemp, height, age, gender, self.weight, self.resistance, self.secResistance, athleteType == YLAthleteSport ? 1 : 0);

    double bmi = calcBmi(height, data -> weight);
    int heartIndexTemp = calcHeartIndex(height, age, gender, data -> weight, self.heartRate);
    
    [self setValue:[NSNumber numberWithDouble:data -> weight] forKeyPath:@"weight"];
    [self setValue:[NSNumber numberWithDouble:bmi] forKeyPath:@"BMI"];
    [self setValue:[NSNumber numberWithDouble:data -> bodyfat] forKeyPath:@"bodyfatRate"];
    [self setValue:[NSNumber numberWithDouble:data -> subfat] forKeyPath:@"subcutaneousFat"];
    [self setValue:[NSNumber numberWithInt:data -> visfat] forKeyPath:@"visceralFat"];
    [self setValue:[NSNumber numberWithDouble:data -> water] forKeyPath:@"bodyWaterRate"];
    [self setValue:[NSNumber numberWithDouble:data -> muscle] forKeyPath:@"muscleRate"];
    [self setValue:[NSNumber numberWithDouble:data -> bone] forKeyPath:@"boneMass"];
    [self setValue:[NSNumber numberWithInt:data -> bmr] forKeyPath:@"BMR"];
    [self setValue:[NSNumber numberWithInt:data -> bodyShape] forKeyPath:@"bodyType"];
    [self setValue:[NSNumber numberWithDouble:data -> protein] forKeyPath:@"protein"];
    [self setValue:[NSNumber numberWithDouble:data -> lbm] forKeyPath:@"leanBodyWeight"];
    [self setValue:[NSNumber numberWithDouble:data -> muscleMass] forKeyPath:@"muscleMass"];
    [self setValue:[NSNumber numberWithInt:data -> bodyAge] forKeyPath:@"metabolicAge"];
    [self setValue:[NSNumber numberWithDouble:data -> score] forKeyPath:@"healthScore"];
    [self setValue:[NSNumber numberWithDouble:heartIndexTemp] forKeyPath:@"heartIndex"];
    return self;
}

@end
