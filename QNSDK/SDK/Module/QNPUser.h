//
//  QNPUser.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/15.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QNPUserGender) {
    QNPUserGenderMale = 0,
    QNPUserGenderFemale = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface QNPUser : NSObject

/** 用户身高(必填) */
@property (nonatomic, assign, readonly) NSUInteger height;
/** 用户性别(必填) */
@property (nonatomic, assign, readonly) QNPUserGender gender;
/** 年龄 */
@property (nonatomic, assign, readonly) NSUInteger age;

+ (nonnull QNPUser *)userHeight:(NSUInteger)height gender:(QNPUserGender)gender age:(NSUInteger)age;

@end

/************************************** 用户秤数据 **************************************/
@interface QNPUser (QNPScaleData)

@property (nonatomic, strong, readonly) NSString *userId;

@property (nonatomic, assign, readonly) float bodyFat;

@property (nonatomic, assign, readonly) float BMI;

@end

NS_ASSUME_NONNULL_END
