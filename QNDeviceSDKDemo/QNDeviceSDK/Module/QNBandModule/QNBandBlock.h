
//
//  QNBandBlock.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/30.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#import "QNBandSport.h"
#import "QNBandSleep.h"
#import "QNBandHeartRate.h"
#import "QNBandEnum.h"
#import "QNBandDevice.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^QNBandStartInteractionBlock)(void);

typedef void (^QNBandResponseBlock)(BOOL success, NSError *__nullable error);

typedef void (^QNBandVersionAndBatteryBlock)(NSUInteger hardwareVer, NSUInteger firmwareVer, NSUInteger battery, NSError *__nullable error);

typedef void (^QNBandSupportAlarmNumBlock)(NSUInteger maxNum, NSError *__nullable error);

typedef void (^QNBandMacBlock)(NSString *__nullable mac, NSError *__nullable error);

typedef void (^QNBandSamePhoneBindBlock)(BOOL same, NSError *__nullable error);

typedef void (^QNBandRealTimeDataBlock)(NSUInteger stepSum, NSUInteger caloriesSum, NSUInteger distanceSum, NSUInteger activeTimeSum, NSUInteger heartRate, NSError *__nullable error);

typedef void (^QNBandTodayDataBlock)(QNBandSport *__nullable sport, QNBandSleep *__nullable sleep, QNBandHeartRate *__nullable heartRate,NSError *__nullable error);
typedef void (^QNBandHistoryDataBlock)(NSArray<QNBandSport *> *__nullable sports, NSArray<QNBandSleep *> *__nullable sleeps, NSArray<QNBandHeartRate *> *__nullable heartRates, NSError *__nullable error);
NS_ASSUME_NONNULL_END
