//
//  QNUser+QNAddition.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/31.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNUser+QNAddition.h"
#import "NSError+QNAPI.h"
#import "QNDebug.h"
#import <objc/runtime.h>

@implementation QNUser (QNAddition)

- (int)getHeight {
    int height = self.height;
    if (height < 40) height = 40;
    if (height > 240) height = 240;
    return height;
}

- (NSError *)checkUserInfo {
    QNBleErrorCode errCode = 0;
    //基本信息
    if (self.userId == nil || ![self.userId isKindOfClass:[NSString class]]) {
        errCode = QNBleErrorCodeUserIdEmpty;
    }else if (![self.gender isKindOfClass:[NSString class]] || (![self.gender isEqualToString:@"male"] && ![self.gender isEqualToString:@"female"])) {
        errCode = QNBleErrorCodeUserGender;
    }else if (![self.birthday isKindOfClass:[NSDate class]]) {
        errCode = QNBleErrorCodeUserBirthday;
    }else if (self.clothesWeight < 0) {
        errCode = QNBleErrorCodeIllegalArgument;
    }else if (self.athleteType != 0 && self.athleteType != 1) {
        errCode = QNBleErrorCodeUserAthleteType;
    }
    
    
    if (self.shapeType != YLUserShapeNone || self.goalType != YLUserGoalNone) {
        NSError *error = nil;
        if (self.shapeType == YLUserShapeNone || self.goalType == YLUserGoalNone) {
            errCode = QNBleErrorCodeUserShapeGoalType;
        }else if (self.shapeType == YLUserShapeStrong) {
            if (self.goalType != YLUserGoalPowerOftenExercise && self.goalType != YLUserGoalPowerLittleExercise && self.goalType != YLUserGoalPowerOftenRun) {
                errCode = QNBleErrorCodeUserShapeGoalType;
            }
        }else {
            if (self.goalType != YLUserGoalLoseFat && self.goalType != YLUserGoalStayHealth && self.goalType != YLUserGoalGainMuscle) {
                errCode = QNBleErrorCodeUserShapeGoalType;
            }
        }
        if (error) return error;
    }
    
    if (errCode == 0) {
        return nil;
    } else {
        return [NSError errorCode:errCode];
    }
}


+ (int)getAgeWithBirthday:(NSDate *)date {
    if ([date isKindOfClass:[NSDate class]] == NO) {
        return 0;
    }
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear fromDate:date];
    int birthdayYear = (int)dateComponents.year;
    dateComponents = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    int age = (int)(dateComponents.year - birthdayYear);
    if (age < 3) age = 3;
    if (age > 80) age = 80;
    return age;
}

@end
