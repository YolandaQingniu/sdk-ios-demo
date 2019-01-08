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
static char QNUserAge;

- (instancetype)initWithUser:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday athleteType:(YLAthleteType)athleteType shapeType:(YLUserShapeType)shapeType goalType:(YLUserGoalType)goalType weight:(double)weight callback:(QNResultCallback)callback {
    if (self = [super init]) {
        [self setValue:userId forKeyPath:@"userId"];
        [self setValue:[NSNumber numberWithInt:height] forKeyPath:@"height"];
        [self setValue:gender forKeyPath:@"gender"];
        [self setValue:birthday forKeyPath:@"birthday"];
        [self setValue:[NSNumber numberWithUnsignedInteger:athleteType] forKeyPath:@"athleteType"];
        [self setValue:[NSNumber numberWithUnsignedInteger:shapeType] forKeyPath:@"shapeType"];
        [self setValue:[NSNumber numberWithUnsignedInteger:goalType] forKeyPath:@"goalType"];
        [self setValue:[NSNumber numberWithDouble:weight] forKeyPath:@"weight"];
    }
    return self;
}


- (void)setAge:(int)age {
    objc_setAssociatedObject(self, &QNUserAge, [NSNumber numberWithInt:age], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (int)age {
    NSNumber *ageNum = objc_getAssociatedObject(self, &QNUserAge);
    if (ageNum == nil) {
        ageNum = [NSNumber numberWithInt:0];
    }
    return [ageNum intValue];
}


+ (NSError *)checkUser:(QNUser *)user deviceType:(QNDeviceType)deviceType {
    QNBleErrorCode errorCode = 0;
    if (user.userId == nil || ![user.userId isKindOfClass:[NSString class]]) {
        errorCode = QNBleErrorCodeUserIdEmpty;
    }else if (user.height < 40 || user.height > 240) {
        errorCode = QNBleErrorCodeUserHeight;
    }else if (![user.gender isKindOfClass:[NSString class]] || (![user.gender isEqualToString:@"male"] && ![user.gender isEqualToString:@"female"])) {
        errorCode = QNBleErrorCodeUserGender;
    }else if (![user.birthday isKindOfClass:[NSDate class]]) {
        errorCode = QNBleErrorCodeUserBirthday;
    }
    if (errorCode) return [NSError errorCode:errorCode];
    
    int age = [self userAgeForBirthday:user.birthday];
    
    if (age < 3 || age > 80) return [NSError errorCode:QNBleErrorCodeUserBirthday];
    
    if (deviceType == QNDeviceBand) {
        if (user.weight <= 0.0001) {
            errorCode = QNBleErrorCodeUserWeight;
        }
    }else {
        if (user.athleteType != 0 && user.athleteType != 1) {
            errorCode = QNBleErrorCodeUserAthleteType;
        }else if (user.shapeType != YLUserShapeNone || user.goalType != YLUserGoalNone) {
            if (user.shapeType == YLUserShapeNone || user.goalType == YLUserGoalNone) {
                errorCode = QNBleErrorCodeUserShapeGoalType;
            }else if (user.shapeType == YLUserShapeStrong) {
                if (user.goalType != YLUserGoalPowerOftenExercise && user.goalType != YLUserGoalPowerLittleExercise && user.goalType != YLUserGoalPowerOftenRun) {
                    errorCode = QNBleErrorCodeUserShapeGoalType;
                }
            }else {
                if (user.goalType != YLUserGoalLoseFat && user.goalType != YLUserGoalStayHealth && user.goalType != YLUserGoalGainMuscle) {
                    errorCode = QNBleErrorCodeUserShapeGoalType;
                }
            }
        }
    }
    if (errorCode == 0) return nil;
    return [NSError errorCode:errorCode];
}

+ (int)userAgeForBirthday:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear fromDate:date];
    int birthdayYear = (int)dateComponents.year;
    dateComponents = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    int age = (int)(dateComponents.year - birthdayYear);
    return age;
}

@end
