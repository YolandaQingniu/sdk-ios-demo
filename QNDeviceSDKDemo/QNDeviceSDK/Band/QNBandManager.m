//
//  QNBandManager.m
//  QNDeviceSDK
//
//  Created by donyau on 2018/12/29.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#import "QNBandManager.h"
#import "QNBandManager+QNAddition.h"
#import "NSError+QNAPI.h"
#import "QNUser+QNAddition.h"

@implementation QNBandManager

- (void)cancelBindCallback:(QNResultCallback)callblock {
    [self.wristManager cancelBindBandResponse:^(BOOL success, NSError * _Nullable error) {
        if (callblock) callblock([NSError transformModuleError:error]);
    }];
}

- (void)checkSameBindPhone:(QNObjCallback)callblock {
    [self.wristManager checkoutSamePhoneBindResponse:^(BOOL same, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock(nil,[NSError transformModuleError:error]);
        }else {
            if (callblock) callblock([NSNumber numberWithBool:same],nil);
        }
    }];
}

- (void)fetchBandInfo:(QNObjCallback)callblock {
    [self.wristManager deviceInfoResponse:^(NSUInteger hardwareVer, NSUInteger firmwareVer, NSUInteger battery, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock(nil,[NSError transformModuleError:error]);
        }else {
            QNBandInfo *info = [[QNBandInfo alloc] init];
            info.hardwareVer = (int)hardwareVer;
            info.firmwareVer = (int)firmwareVer;
            info.electric = (int)battery;
            if (callblock) callblock(info,nil);
        }
    }];
}


- (void)syncBandTimeWithDate:(NSDate *)date callback:(QNResultCallback)callblock {
    if (date == nil || [date isKindOfClass:[NSDate class]] == NO) {
        NSError *error = [NSError errorCode:QNBleErrorCodeIllegalArgument];
        [[QNDebug sharedDebug] log:error.description];
        if (callblock) callblock(error);
        return;
    }
    
    [self.wristManager updateTimeToBandWithTimeStamp:[date timeIntervalSince1970] response:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock([NSError transformModuleError:error]);
        }else {
            if (callblock) callblock(nil);
        }
    }];
}

- (void)syncAlarm:(QNAlarm *)alarm callback:(QNResultCallback)callblock {
    BOOL illegalFlag = alarm == nil || [alarm isKindOfClass:[QNAlarm class]] == NO || alarm.alarmId < 1 || alarm.alarmId > 10 || alarm.hour < 0 || alarm.hour > 23 || alarm.minture < 0 || alarm.minture > 59 || alarm.week == nil || [alarm.week isKindOfClass:[QNWeek class]] == NO;
    
    if (illegalFlag) {
        NSError *error = [NSError errorCode:QNBleErrorCodeIllegalArgument];
        [[QNDebug sharedDebug] log:error.description];
        if (callblock) callblock(error);
        return;
    }
    
    QNBandAlarm *bandAlarm = [[QNBandAlarm alloc] init];
    bandAlarm.alarmID = alarm.alarmId;
    bandAlarm.openFlag = alarm.openFlag;
    bandAlarm.hour = (NSUInteger)alarm.hour;
    bandAlarm.minture = (NSUInteger)alarm.minture;
    QNAlarmWeek week = {alarm.week.mon,alarm.week.tues,alarm.week.wed,alarm.week.thur,alarm.week.fri,alarm.week.sat,alarm.week.sun};
    bandAlarm.weekRepeat = week;

    [self.wristManager updateAlarm:bandAlarm response:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock([NSError transformModuleError:error]);
        }else {
            if (callblock) callblock(nil);
        }
    }];
}

- (void)syncGoal:(int)stepGoal callback:(QNResultCallback)callblock {
    [self.wristManager updateSportGoal:stepGoal sleepGoal:0 response:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock([NSError transformModuleError:error]);
        }else {
            if (callblock) callblock(nil);
        }
    }];
}

- (void)syncUser:(QNUser *)user callback:(QNResultCallback)callblock {
    NSError *error = [QNUser checkUser:user deviceType:QNDeviceBand];
    if (error) {
        NSError *error = [NSError errorCode:QNBleErrorCodeIllegalArgument];
        [[QNDebug sharedDebug] log:error.description];
        if (callblock) callblock(error);
        return;
    }
    
    QNBandUser *bandUser = [[QNBandUser alloc] init];
    bandUser.weight = user.weight;
    bandUser.height = user.height;
    bandUser.birthdayTimeStamp = [user.birthday timeIntervalSince1970];
    bandUser.gender = [user.gender isEqualToString:@"male"] ? QNBandGenderMale : QNBandGenderFemale;
    
    [self.wristManager updateUser:bandUser response:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock([NSError transformModuleError:error]);
        }else {
            if (callblock) callblock(nil);
        }
    }];
}

- (void)syncMetrics:(QNBandMetrics *)metrics callback:(QNResultCallback)callblock {
    if (metrics == nil || [metrics isKindOfClass:[QNBandMetrics class]] == NO) {
        NSError *error = [NSError errorCode:QNBleErrorCodeIllegalArgument];
        [[QNDebug sharedDebug] log:error.description];
        if (callblock) callblock(error);
        return;
    }
    
    [self.wristManager updateUnit:metrics.length == QNBandLengthModeBritish ? QNBandUnitBritish : QNBandUnitMetric language:metrics.language == QNBandLanguageModeEnglish ? QNBandLanguageEnglish : QNBandLanguageChina hourFormat:metrics.formatHour == QNBandFormatHourMode12 ? QNBandHourFormat12 : QNBandHourFormat24 response:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock([NSError transformModuleError:error]);
        }else {
            if (callblock) callblock(nil);
        }
    }];
}

- (void)syncSitRemind:(QNSitRemind *)sitRemind callback:(QNResultCallback)callblock {
    BOOL illegalFlag = sitRemind == nil || [sitRemind isKindOfClass:[QNSitRemind class]] == NO || sitRemind.startHour < 0 || sitRemind.startHour > 23 || sitRemind.startMinture < 0 || sitRemind.startMinture > 59 || sitRemind.endHour < 0 || sitRemind.endHour > 23 || sitRemind.endMinture < 0 || sitRemind.endMinture > 59 || sitRemind.timeInterval < 0 || sitRemind.week == nil || [sitRemind.week isKindOfClass:[QNWeek class]] == NO;
    
    if (illegalFlag) {
        NSError *error = [NSError errorCode:QNBleErrorCodeIllegalArgument];
        [[QNDebug sharedDebug] log:error.description];
        if (callblock) callblock(error);
        return;
    }
    
    QNBandSitRemind *bandSitRemind = [[QNBandSitRemind alloc] init];
    bandSitRemind.openFlag = sitRemind.openFlag;
    bandSitRemind.startHour = sitRemind.startHour;
    bandSitRemind.startMinture = sitRemind.startMinture;
    bandSitRemind.endHour = sitRemind.endHour;
    bandSitRemind.endMinture = sitRemind.endMinture;
    bandSitRemind.timeInterval = sitRemind.timeInterval;
    
    QNLongSitWeek week = {sitRemind.week.mon,sitRemind.week.tues,sitRemind.week.wed,sitRemind.week.thur,sitRemind.week.fri,sitRemind.week.sat,sitRemind.week.sun};
    bandSitRemind.weekRepeat = week;

    [self.wristManager updateSitRemind:bandSitRemind response:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock([NSError transformModuleError:error]);
        }else {
            if (callblock) callblock(nil);
        }
    }];
}

- (void)syncHeartRateObserverModeWithAutoFlag:(BOOL)autoFlag callback:(QNResultCallback)callblock {
    [self.wristManager updateAutoHeartRateObserverState:autoFlag response:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock([NSError transformModuleError:error]);
        }else {
            if (callblock) callblock(nil);
        }
    }];
}

- (void)syncFindPhoneWithOpenFlag:(BOOL)openFlag callback:(QNResultCallback)callblock {
    [self.wristManager updateFindPhoneState:openFlag response:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock([NSError transformModuleError:error]);
        }else {
            if (callblock) callblock(nil);
        }
    }];
}

- (void)syncCameraModeWithEnterFlag:(BOOL)openFlag callback:(QNResultCallback)callblock {
    [self.wristManager updateTakePhotoState:openFlag response:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock([NSError transformModuleError:error]);
        }else {
            if (callblock) callblock(nil);
        }
    }];
}

- (void)syncHandRecognizeModeWithOpenFlag:(BOOL)openFlag callback:(QNResultCallback)callblock {
    [self.wristManager updateHandRecognizeState:openFlag response:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock([NSError transformModuleError:error]);
        }else {
            if (callblock) callblock(nil);
        }
    }];
}

- (void)setThirdRemind:(QNThirdRemind *)thirdRemind callback:(QNResultCallback)callblock {
    BOOL illegalFlag = thirdRemind == nil || [thirdRemind isKindOfClass:[QNThirdRemind class]] == NO || thirdRemind.callDelay < 3;
    if (illegalFlag) {
        NSError *error = [NSError errorCode:QNBleErrorCodeIllegalArgument];
        [[QNDebug sharedDebug] log:error.description];
        if (callblock) callblock(error);
        return;
    }
    
    QNBandThirdRemind *bandThirdRemind = [[QNBandThirdRemind alloc] init];
    bandThirdRemind.callRemind = thirdRemind.call;
    bandThirdRemind.callDelay = thirdRemind.callDelay;
    bandThirdRemind.sms = thirdRemind.sms;
    bandThirdRemind.faceBook = thirdRemind.faceBook;
    bandThirdRemind.WeChat = thirdRemind.WeChat;
    bandThirdRemind.QQ = thirdRemind.QQ;
    bandThirdRemind.twitter = thirdRemind.twitter;
    bandThirdRemind.whatesapp = thirdRemind.whatesapp;
    bandThirdRemind.linkedIn = thirdRemind.linkedIn;
    bandThirdRemind.instagram = thirdRemind.instagram;
    bandThirdRemind.faceBookMessenger = thirdRemind.faceBookMessenger;
    bandThirdRemind.calendar = thirdRemind.calendar;
    bandThirdRemind.email = thirdRemind.email;
    bandThirdRemind.skype = thirdRemind.skype;
    bandThirdRemind.pokeman = thirdRemind.pokeman;
    
    [self.wristManager updateThirdRemind:bandThirdRemind response:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock([NSError transformModuleError:error]);
        }else {
            if (callblock) callblock(nil);
        }
    }];
}

- (void)resetWithCleanInfo:(QNCleanInfo *)cleanInfo callback:(QNResultCallback)callblock {
    BOOL illegalFlag = cleanInfo == nil || [cleanInfo isKindOfClass:[QNCleanInfo class]] == NO;
    if (illegalFlag) {
        NSError *error = [NSError errorCode:QNBleErrorCodeIllegalArgument];
        [[QNDebug sharedDebug] log:error.description];
        if (callblock) callblock(error);
        return;
    }
    QNBandClear *clean = [[QNBandClear alloc] init];
    clean.alarm = cleanInfo.alarm;
    clean.goal  = cleanInfo.goal;
    clean.unit = cleanInfo.metrics;
    clean.sitRemind = cleanInfo.sitRemind;
    clean.lossRemind = cleanInfo.lossRemind;
    clean.heartRateOpen = cleanInfo.heartRateObserver;
    clean.handRecoginzeOpen = cleanInfo.handRecoginze;
    clean.bindState = cleanInfo.bindState;
    clean.thirdRemindState = cleanInfo.thirdRemind;

    [self.wristManager clearBandConfig:clean response:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock([NSError transformModuleError:error]);
        }else {
            if (callblock) callblock(nil);
        }
    }];
}

- (void)rebootCallback:(QNResultCallback)callblock {
    [self.wristManager restartBandResponse:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock([NSError transformModuleError:error]);
        }else {
            if (callblock) callblock(nil);
        }
    }];
}

- (void)syncFastSetting:(QNBandBaseConfig *)baseConifg callback:(QNResultCallback)callblock {
    BOOL illegalFlag = baseConifg == nil || [baseConifg isKindOfClass:[QNBandBaseConfig class]] == NO || baseConifg.user == nil || [baseConifg.user isKindOfClass:[QNUser class]] == NO || baseConifg.metrics == nil || [baseConifg.metrics isKindOfClass:[QNBandMetrics class]] == NO;
    if (illegalFlag == NO) {
        illegalFlag = [QNUser checkUser:baseConifg.user deviceType:QNDeviceBand] != nil;
    }
    
    if (illegalFlag) {
        NSError *error = [NSError errorCode:QNBleErrorCodeIllegalArgument];
        [[QNDebug sharedDebug] log:error.description];
        if (callblock) callblock(error);
        return;
    }
    
    QNBandShortcutInfo *shortcutInfo = [[QNBandShortcutInfo alloc] init];
    shortcutInfo.autoHeartRateFlag = baseConifg.heartRateObserver;
    shortcutInfo.handRecognizeFlag = baseConifg.handRecog;
    shortcutInfo.findPhoneFlag = baseConifg.findPhone;
    shortcutInfo.lossRemindFlag = baseConifg.lostRemind;
    shortcutInfo.age = [QNUser userAgeForBirthday:baseConifg.user.birthday];
    shortcutInfo.gender = [baseConifg.user.gender isEqualToString:@"female"] ? QNBandGenderFemale : QNBandGenderMale;
    shortcutInfo.weight = baseConifg.user.weight;
    shortcutInfo.height = baseConifg.user.height;
    shortcutInfo.sportGoal = baseConifg.stepGoal;
    shortcutInfo.unit = baseConifg.metrics.length == QNBandLengthModeBritish ? QNBandUnitBritish : QNBandUnitMetric;
    shortcutInfo.language = baseConifg.metrics.language == QNBandLanguageModeEnglish ? QNBandLanguageEnglish : QNBandLanguageChina;
    shortcutInfo.hourFormat = baseConifg.metrics.formatHour == QNBandFormatHourMode12 ? QNBandHourFormat12 : QNBandHourFormat24;
    
    [self.wristManager convenienceBandConfig:shortcutInfo response:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (callblock) callblock([NSError transformModuleError:error]);
        }else {
            if (callblock) callblock(nil);
        }
    }];
}


- (void)syncTodayHealthDataCallback:(QNObjCallback)callblock {
    __weak typeof(self) weakSelf = self;
    [self.wristManager synTodayHealthData:^(QNBandSport * _Nullable sport, QNBandSleep * _Nullable sleep, QNBandHeartRate * _Nullable heartRate, NSError * _Nullable error) {
        QNHealthData *healthData = [[QNHealthData alloc] init];
        healthData.date = [NSDate date];
        healthData.sport = [weakSelf transformBandSport:sport];
        healthData.sleep = [weakSelf transformBandSleep:sleep];
        healthData.heartRate = [weakSelf transformBandHeartRate:heartRate];
        if (callblock) callblock(healthData,[NSError transformModuleError:error]);
    }];
}


- (void)syncHistoryHealthDataCallback:(QNObjCallback)callblock {
    __weak typeof(self) weakSelf = self;
    [self.wristManager synHistoryHealthData:^(NSArray<QNBandSport *> * _Nullable sports, NSArray<QNBandSleep *> * _Nullable sleeps, NSArray<QNBandHeartRate *> * _Nullable heartRates, NSError * _Nullable error) {
        NSMutableArray<QNHealthData *> *healthDatas = [NSMutableArray<QNHealthData *> array];
        
        for (QNBandSport *item in sports) {
            QNHealthData *healthData = [[QNHealthData alloc] init];
            QNSport *sport = [weakSelf transformBandSport:item];
            healthData.sport = sport;
            healthData.date = sport.date;
            [healthDatas addObject:healthData];
        }
        
        for (QNBandSleep *item in sleeps) {
            QNHealthData *healthData = nil;
            for (QNHealthData *healthDataItem in healthDatas) {
                if ([healthDataItem.date timeIntervalSince1970] / (3600 * 24) == item.recordTimeStamp / (3600 * 24)) {
                    healthData = healthDataItem;
                    break;
                }
            }
            if (healthData == nil) {
                QNHealthData *healthData = [[QNHealthData alloc] init];
                healthData.date = [NSDate dateWithTimeIntervalSince1970:item.recordTimeStamp];
                [healthDatas addObject:healthData];
            }
            healthData.sleep = [weakSelf transformBandSleep:item];
        }
        
        for (QNBandHeartRate *item in healthDatas) {
            QNHealthData *healthData = nil;
            for (QNHealthData *healthDataItem in healthDatas) {
                if ([healthDataItem.date timeIntervalSince1970] / (3600 * 24) == item.recordTimeStamp / (3600 * 24)) {
                    healthData = healthDataItem;
                    break;
                }
            }
            if (healthData == nil) {
                QNHealthData *healthData = [[QNHealthData alloc] init];
                healthData.date = [NSDate dateWithTimeIntervalSince1970:item.recordTimeStamp];
                [healthDatas addObject:healthData];
            }
            healthData.heartRate = [weakSelf transformBandHeartRate:item];
        }
        
        [healthDatas sortUsingComparator:^NSComparisonResult(QNHealthData *obj1, QNHealthData *obj2) {
            return [obj1.date compare:obj2.date];
        }];
        
        if (callblock) callblock(healthDatas,[NSError transformModuleError:error]);
    }];
}


- (QNSport *)transformBandSport:(QNBandSport *)bandSport {
    if (bandSport == nil) return nil;
    
    QNSport *sport = [[QNSport alloc] init];
    sport.date = [NSDate dateWithTimeIntervalSince1970:bandSport.recordTimeStamp];
    sport.sumStep = bandSport.sumStep;
    sport.sumCalories = bandSport.sumCalories;
    sport.sumDistance = bandSport.sumDistance;
    sport.sumActiveTime = bandSport.sumActiveTime;
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:sport.date];
    NSInteger yeart = dateComponents.year;
    NSInteger month = dateComponents.month;
    NSInteger day = dateComponents.day;
    dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = yeart;
    dateComponents.month = month;
    dateComponents.day = day;
    NSDate *date = [dateComponents date];
    
    NSMutableArray<QNSportItem *> *sportItems = [NSMutableArray<QNSportItem *> array];
    for (QNBandSportItem *item in bandSport.sportItemAll) {
        QNSportItem *sportItem = [[QNSportItem alloc] init];
        sportItem.curCNT = sportItems.count;
        sportItem.startDate = [date dateByAddingTimeInterval:15 * 60 * sportItems.count];
        sportItem.endDate = [date dateByAddingTimeInterval:15 * 60 * (sportItems.count + 1)];
        sportItem.step = item.step;
        sportItem.activeTime = item.activeTime;
        sportItem.calories = item.calories;
        sportItem.distance = item.distance;
        [sportItems addObject:sportItem];
    }
    
    sport.sportItems = sportItems;
    return sport;
}

- (QNSleep *)transformBandSleep:(QNBandSleep *)bandSleep {
    if (bandSleep == nil) return nil;
    
    QNSleep *sleep = [[QNSleep alloc] init];
    sleep.date = [NSDate dateWithTimeIntervalSince1970:bandSleep.recordTimeStamp];
    sleep.sumSleep = bandSleep.sumSleepTime;
    sleep.deepSleep = bandSleep.deepSleepTime;
    sleep.lightSleep = bandSleep.lightSleepTime;

    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:sleep.date];
    NSInteger yeart = dateComponents.year;
    NSInteger month = dateComponents.month;
    NSInteger day = dateComponents.day;
    dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = yeart;
    dateComponents.month = month;
    dateComponents.day = day;
    dateComponents.hour = bandSleep.giveUpOffset / 60;
    dateComponents.minute = bandSleep.giveUpOffset % 60;
    
    NSDate *startSleepDate = [[dateComponents date] dateByAddingTimeInterval:- bandSleep.giveUpOffset];
    
    NSMutableArray<QNSleepItem *> *sleepItems = [NSMutableArray<QNSleepItem *> array];
    for (QNBandSleepItem *item in bandSleep.sleepItemAll) {
        QNSleepItem *sleepItem = [[QNSleepItem alloc] init];
        sleepItem.curCNT = sleepItems.count;
        sleepItem.startDate = startSleepDate;
        startSleepDate = [startSleepDate dateByAddingTimeInterval:item.sleepTime];
        sleepItem.endDate = startSleepDate;
        switch (item.sleepType) {
            case QNBandSleepSober: sleepItem.sleepType = QNSleepSober; break;
            case QNBandSleepDeep: sleepItem.sleepType = QNSleepDeep; break;
            case QNBandSleepLight: sleepItem.sleepType = QNSleepLight; break;
        }
        sleepItem.sleepTime = item.sleepTime;
        [sleepItems addObject:sleepItem];
    }
    
    sleep.sleepItems = sleepItems;
    return sleep;
}

- (QNHeartRate *)transformBandHeartRate:(QNBandHeartRate *)bandHeartRate {
    if (bandHeartRate == nil) return nil;

    QNHeartRate *heartRate = [[QNHeartRate alloc] init];
    heartRate.date = [NSDate dateWithTimeIntervalSince1970:bandHeartRate.recordTimeStamp];
    heartRate.slientHeartRate = bandHeartRate.slientHeartRate;
    heartRate.burnFatThreshold = bandHeartRate.burnFatThreshold;
    heartRate.aerobicThreshold = bandHeartRate.aerobicThreshold;
    heartRate.limitThreshold = bandHeartRate.limitThreshold;

    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:heartRate.date];
    NSInteger yeart = dateComponents.year;
    NSInteger month = dateComponents.month;
    NSInteger day = dateComponents.day;
    dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = yeart;
    dateComponents.month = month;
    dateComponents.day = day;
    
    NSDate *startHeartRateDate = [dateComponents date];


    NSMutableArray<QNHeartRateItem *> *heartRateItems = [NSMutableArray<QNHeartRateItem *> array];
    for (QNBandHeartRateItem *item in bandHeartRate.heartRateItemAll) {
        QNHeartRateItem *heartRateItem = [[QNHeartRateItem alloc] init];
        heartRateItem.curCNT = heartRateItems.count;
        startHeartRateDate = [startHeartRateDate dateByAddingTimeInterval:item.offset];
        heartRateItem.date = startHeartRateDate;
        heartRateItem.heartRate = item.heartRate;
        [heartRateItems addObject:heartRateItem];
    }
    heartRate.heartRateItems = heartRateItems;
    return heartRate;
}

@end
