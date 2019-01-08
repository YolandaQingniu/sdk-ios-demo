//
//  QNUser+QNAddition.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/31.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNUser.h"
#import "QNBleDevice.h"

@interface QNUser (QNAddition)

@property (nonatomic, assign) int age;

+ (int)userAgeForBirthday:(NSDate *)date;

+ (NSError *)checkUser:(QNUser *)user deviceType:(QNDeviceType)deviceType;

- (instancetype)initWithUser:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday athleteType:(YLAthleteType)athleteType shapeType:(YLUserShapeType)shapeType goalType:(YLUserGoalType)goalType weight:(double)weight callback:(QNResultCallback)callback;

@end
