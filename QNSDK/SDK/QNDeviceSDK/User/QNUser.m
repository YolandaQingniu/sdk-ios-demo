//
//  QNUser.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNUser.h"
#import "NSError+QNAPI.h"
#import "QNUser+QNAddition.h"
#import "QNDebug.h"

@implementation QNUser

- (instancetype)initWithUser:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday athleteType:(YLAthleteType)athleteType shapeType:(YLUserShapeType)shapeType goalType:(YLUserGoalType)goalType callback:(QNResultCallback)callback {
    if (self = [super init]) {
        self.userId = userId;
        self.height = height;
        self.gender = gender;
        self.birthday = birthday;
        self.athleteType = athleteType;
        self.shapeType = shapeType;
        self.goalType = goalType;
        NSError *err = [self checkUserInfo];
        if (err && callback) {
            callback(err);
            return nil;
        } else {
            !callback ?: callback(nil);
        }
    }
    return self;
}

#pragma mark 建立用户模型
+ (QNUser *)buildUserId:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday athleteType:(YLAthleteType)athleteType shapeType:(YLUserShapeType)shapeType goalType:(YLUserGoalType)goalType callback:(QNResultCallback)callback {
    return [[QNUser alloc] initWithUser:userId height:height gender:gender birthday:birthday athleteType:athleteType shapeType:shapeType goalType:goalType callback:callback];
}

+ (QNUser *)buildUserId:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday callback:(QNResultCallback)callback {
    return [[QNUser alloc] initWithUser:userId height:height gender:gender birthday:birthday athleteType:YLAthleteDefault shapeType:YLUserShapeNone goalType:YLUserGoalNone callback:callback];
}

+ (QNUser *)buildUserId:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday athleteType:(YLAthleteType)athleteType callback:(QNResultCallback)callback {
    return [[QNUser alloc] initWithUser:userId height:height gender:gender birthday:birthday athleteType:athleteType shapeType:YLUserShapeNone goalType:YLUserGoalNone callback:callback];
}

@end
