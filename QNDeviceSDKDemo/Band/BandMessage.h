//
//  BandMessage.h
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNDeviceSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface BandMessage : NSObject

+ (BandMessage *)sharedBandMessage;

@property (nullable, nonatomic, strong) NSString *blueToothName;
@property (nullable, nonatomic, strong) NSString *mac;
@property (nullable, nonatomic, strong) NSString *modeId;
@property (nullable, nonatomic, strong) NSString *uuidString;
@property (nonatomic, assign) int hardwareVer;
@property (nonatomic, assign) int firmwareVer;
@property (nonatomic, assign) int battery;
@property (nullable, nonatomic, strong) NSMutableArray<QNAlarm*> *alarms;
@property (nonatomic, assign) int sportGoal;
@property (nonatomic, assign) QNBandLengthMode length;
@property (nonatomic, assign) QNBandLanguageMode language;
@property (nonatomic, assign) QNBandFormatHourMode hourFormat;
@property (nonatomic, assign) BOOL lossRemind;
@property (nonatomic, assign) BOOL heartRateObserver;
@property (nonatomic, assign) BOOL findPhone;
@property (nonatomic, assign) BOOL handRecognize;
@property (nullable, nonatomic, strong) QNSitRemind *sitRemind;
@property (nullable, nonatomic, strong) QNThirdRemind *thirdRemind;

- (void)cleanBandMessage;

@end

NS_ASSUME_NONNULL_END
