//
//  BandMessage.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandMessage.h"
#import <MMKV/MMKV.h>

#define BandMMKVID @"BandMessageMMKVID"
#define BandMMKVBlueToothKey @"bandMmkvBlueToothKey"
#define BandMMKVMacKey @"bandMmkvMacKey"
#define BandMMKVModeIdMKey @"bandMmkvModeIdMKey"
#define BandMMKVUUIDStringKey @"bandMmkvUUUIDStringKey"
#define BandMMKVHardwareVerKey @"bandMmkvHardwareVerKey"
#define BandMMKVFirmwareVerKey @"bandMmkvFirmwareVerKey"
#define BandMMKVBatteryKey @"bandMmkvBatteryKey"
#define BandMMKVAlarmsKey @"bandMmkvAlarmsKey"
#define BandMMKVSportGoalKey @"bandMmkvSportGoalKey"
#define BandMMKVLengthUnitKey @"bandMmkvLengthUnitKey"
#define BandMMKVLanguageKey @"bandMmkvLanguageKey"
#define BandMMKVHourFormatKey @"bandMmkvHourFormatKey"
#define BandMMKVLossRemindKey @"bandMmkvLossRemindKey"
#define BandMMKVMHeartRateObserverKey @"bandMmkvHeartRateObserverKey"
#define BandMMKVFindPhoneOpenKey @"bandMmkvFindPhoneOpenKey"
#define BandMMKVHandRecognizeKey @"bandMmkvHandRecognizeKey"
#define BandMMKVSitRemindKey @"bandMmkvSitRemindKey"
#define BandMMKVThirdRemindKey @"bandMmkvThirdRemindKey"

#define BandMMKVAlarmIDKey @"alarmId"
#define BandMMKVAlarmHourKey @"hourKey"
#define BandMMKVAlarmMintureKey @"mintureKey"
#define BandMMKVAlarmOpenKey @"openKey"
#define BandMMKVAlarmWeekRepeatKey @"weekRepeatKey"

#define BandMMKVSitRemindOpenKey @"openKey"
#define BandMMKVSitRemindStartHourKey @"startHourKey"
#define BandMMKVSitRemindStartMinture @"startMintureKey"
#define BandMMKVSitRemindEndHourKey @"endHourKey"
#define BandMMKVSitRemindEndMintureKey @"endMintureKey"
#define BandMMKVSitRemindTimeIntervalKey @"timeIntervalKey"
#define BandMMKVSitRemindWeekRepeatKey @"weekRepeatKey"

#define BandMMKVThirdRemindCallDelayKey @"callDelayKey"
#define BandMMKVThirdRemindOpenStateKey @"openStateKey"


#define BandMessageGetBit(num,index) (((num & 0xFF) >> index) & 0x01)


@interface BandMessage ()
@property (nonatomic, strong) MMKV *mmkv;
@end

@implementation BandMessage
static BandMessage *bandMessage = nil;

+ (BandMessage *)sharedBandMessage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bandMessage = [BandMessage alloc];
    });
    return bandMessage;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bandMessage = [[super allocWithZone:zone] init];
    });
    return bandMessage;
}

- (instancetype)init {
    if (self = [super init]) {
        if (self.mmkv == nil) {
            self.mmkv = [MMKV mmkvWithID:BandMMKVID];
        }
    }
    return self;
}

#pragma mark -
- (NSString *)blueToothName {
    return [self.mmkv getObjectOfClass:[NSString class] forKey:BandMMKVBlueToothKey];
}

- (void)setBlueToothName:(NSString *)blueToothName {
    if (blueToothName) [self.mmkv setString:blueToothName forKey:BandMMKVBlueToothKey];
}

- (NSString *)mac {
    return [self.mmkv getObjectOfClass:[NSString class] forKey:BandMMKVMacKey];
}

- (void)setMac:(NSString *)mac {
    if (mac) [self.mmkv setString:mac forKey:BandMMKVMacKey];
}

- (NSString *)modeId {
    return [self.mmkv getObjectOfClass:[NSString class] forKey:BandMMKVModeIdMKey];
}

- (void)setModeId:(NSString *)modeId {
    if (modeId) [self.mmkv setString:modeId forKey:BandMMKVModeIdMKey];
}

- (NSString *)uuidString {
    return [self.mmkv getObjectOfClass:[NSString class] forKey:BandMMKVUUIDStringKey];
}

- (void)setUuidString:(NSString *)uuidString {
    if (uuidString) [self.mmkv setString:uuidString forKey:BandMMKVUUIDStringKey];
}

- (int)hardwareVer {
    return [self.mmkv getInt32ForKey:BandMMKVHardwareVerKey defaultValue:0];
}

- (void)setHardwareVer:(int)hardwareVer {
    [self.mmkv setInt32:hardwareVer forKey:BandMMKVHardwareVerKey];
}

- (int)firmwareVer {
    return [self.mmkv getInt32ForKey:BandMMKVFirmwareVerKey defaultValue:0];
}

- (void)setFirmwareVer:(int)firmwareVer {
    [self.mmkv setInt32:firmwareVer forKey:BandMMKVFirmwareVerKey];
}

- (int)battery {
    return [self.mmkv getInt32ForKey:BandMMKVBatteryKey defaultValue:0];
}

- (void)setBattery:(int)battery {
    [self.mmkv setInt32:battery forKey:BandMMKVBatteryKey];
}

- (NSMutableArray<QNAlarm *> *)alarms {
    NSData *data = [self.mmkv getDataForKey:BandMMKVAlarmsKey];
    NSMutableArray<QNAlarm *> *alarms = nil;
    if (data == nil) {
        QNAlarm *alarm = [[QNAlarm alloc] init];
        alarm.alarmId = 1;
        alarm.hour = 8;
        alarm.minture = 0;
        alarm.openFlag = NO;
        QNWeek *week = [[QNWeek alloc] init];
        week.mon = YES;
        week.tues = YES;
        week.wed = YES;
        week.thur = YES;
        week.fri = YES;
        alarm.week = week;
        NSMutableArray<QNAlarm *> *alarms = [NSMutableArray<QNAlarm *> array];
        [alarms addObject:alarm];
        return alarms;
    }
    
    alarms = [NSMutableArray<QNAlarm *> array];

    NSMutableArray<NSMutableDictionary<NSString *,id> *> *alarmDisArray= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    for (NSMutableDictionary<NSString *,id> *item in alarmDisArray) {
        QNAlarm *alarm = [[QNAlarm alloc] init];
        alarm.alarmId = [[item valueForKey:BandMMKVAlarmIDKey] intValue];
        alarm.hour = [[item valueForKey:BandMMKVAlarmHourKey] intValue];
        alarm.minture = [[item valueForKey:BandMMKVAlarmMintureKey] intValue];
        alarm.openFlag = [[item valueForKey:BandMMKVAlarmOpenKey] boolValue];
        alarm.week = [[QNWeek alloc] init];
        
        int repeatWeek = [[item valueForKey:BandMMKVAlarmWeekRepeatKey] intValue];
        alarm.week.mon = BandMessageGetBit(repeatWeek, 0);
        alarm.week.tues = BandMessageGetBit(repeatWeek, 1);
        alarm.week.wed = BandMessageGetBit(repeatWeek, 2);
        alarm.week.thur = BandMessageGetBit(repeatWeek, 3);
        alarm.week.fri = BandMessageGetBit(repeatWeek, 4);
        alarm.week.sat = BandMessageGetBit(repeatWeek, 5);
        alarm.week.sun = BandMessageGetBit(repeatWeek, 6);

        [alarms addObject:alarm];
    }
    
    return alarms;
}

- (void)setAlarms:(NSMutableArray<QNAlarm *> *)alarms {
    NSMutableArray<NSMutableDictionary<NSString *,id> *> *alarmDisArray = [NSMutableArray<NSMutableDictionary<NSString *,id> *> array];
    for (QNAlarm *alarm in alarms) {
        NSMutableDictionary<NSString *,id> *dic = [NSMutableDictionary<NSString *,id> dictionary];
        [dic setObject:[NSNumber numberWithInt:alarm.alarmId] forKey:BandMMKVAlarmIDKey];
        [dic setObject:[NSNumber numberWithInt:alarm.hour] forKey:BandMMKVAlarmHourKey];
        [dic setObject:[NSNumber numberWithInt:alarm.minture] forKey:BandMMKVAlarmMintureKey];
        [dic setObject:[NSNumber numberWithBool:alarm.openFlag] forKey:BandMMKVAlarmOpenKey];

        int repeatWeek = 0;
        if (alarm.week.mon) repeatWeek += (1 << 0);
        if (alarm.week.tues) repeatWeek += (1 << 1);
        if (alarm.week.wed) repeatWeek += (1 << 2);
        if (alarm.week.thur) repeatWeek += (1 << 3);
        if (alarm.week.fri) repeatWeek += (1 << 4);
        if (alarm.week.sat) repeatWeek += (1 << 5);
        if (alarm.week.sun) repeatWeek += (1 << 6);
        [dic setObject:[NSNumber numberWithInt:repeatWeek] forKey:BandMMKVAlarmWeekRepeatKey];

        [alarmDisArray addObject:dic];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:alarmDisArray options:NSJSONWritingPrettyPrinted error:nil];
    if (data) [self.mmkv setData:data forKey:BandMMKVAlarmsKey];
}

- (int)sportGoal {
    return [self.mmkv getInt32ForKey:BandMMKVSportGoalKey defaultValue:5000];
}

- (void)setSportGoal:(int)sportGoal {
    [self.mmkv setInt32:sportGoal forKey:BandMMKVSportGoalKey];
}

- (QNBandLengthMode)length {
    return [self.mmkv getInt32ForKey:BandMMKVLengthUnitKey defaultValue:0];
}

- (void)setLength:(QNBandLengthMode)length {
    [self.mmkv setInt32:(int)length forKey:BandMMKVLengthUnitKey];
}

- (QNBandLanguageMode)language {
    return [self.mmkv getInt32ForKey:BandMMKVLanguageKey defaultValue:0];
}

- (void)setLanguage:(QNBandLanguageMode)language {
    [self.mmkv setInt32:(int)language forKey:BandMMKVLanguageKey];
}

- (QNBandFormatHourMode)hourFormat {
    return [self.mmkv getInt32ForKey:BandMMKVHourFormatKey defaultValue:0];
}

- (void)setHourFormat:(QNBandFormatHourMode)hourFormat {
    [self.mmkv setInt32:(int)hourFormat forKey:BandMMKVHourFormatKey];
}

- (BOOL)lossRemind {
    return [self.mmkv getBoolForKey:BandMMKVLossRemindKey];
}

- (void)setLossRemind:(BOOL)lossRemind {
    [self.mmkv setBool:lossRemind forKey:BandMMKVLossRemindKey];
}

- (BOOL)heartRateObserver {
    return [self.mmkv getBoolForKey:BandMMKVMHeartRateObserverKey];
}

- (void)setHeartRateObserver:(BOOL)heartRateObserver {
    [self.mmkv setBool:heartRateObserver forKey:BandMMKVMHeartRateObserverKey];
}

- (BOOL)findPhone {
    return [self.mmkv getBoolForKey:BandMMKVFindPhoneOpenKey];
}

- (void)setFindPhone:(BOOL)findPhone {
    [self.mmkv setBool:findPhone forKey:BandMMKVFindPhoneOpenKey];
}

- (BOOL)handRecognize {
    return [self.mmkv getBoolForKey:BandMMKVHandRecognizeKey];
}

- (void)setHandRecognize:(BOOL)handRecognize {
    [self.mmkv setBool:handRecognize forKey:BandMMKVHandRecognizeKey];
}

- (QNSitRemind *)sitRemind {
    NSData *data = [self.mmkv getDataForKey:BandMMKVSitRemindKey];
    QNSitRemind *sitRemind = [[QNSitRemind alloc] init];
    if (data == nil) {
        sitRemind.openFlag = NO;
        sitRemind.startHour = 9;
        sitRemind.startMinture = 0;
        sitRemind.endHour = 18;
        sitRemind.endMinture = 0;
        sitRemind.timeInterval = 45;
        QNWeek *week = [[QNWeek alloc] init];
        week.mon = YES;
        week.tues = YES;
        week.wed = YES;
        week.thur = YES;
        week.fri = YES;
        sitRemind.week = week;
    }else {
        NSMutableDictionary<NSString *,id> *sitRemindDis = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (sitRemindDis) {
            sitRemind.openFlag = [[sitRemindDis valueForKey:BandMMKVSitRemindOpenKey] boolValue];
            sitRemind.startHour = [[sitRemindDis valueForKey:BandMMKVSitRemindStartHourKey] intValue];
            sitRemind.startMinture = [[sitRemindDis valueForKey:BandMMKVSitRemindStartMinture] intValue];
            sitRemind.endHour = [[sitRemindDis valueForKey:BandMMKVSitRemindEndHourKey] intValue];
            sitRemind.endMinture = [[sitRemindDis valueForKey:BandMMKVSitRemindEndMintureKey] intValue];
            sitRemind.timeInterval = [[sitRemindDis valueForKey:BandMMKVSitRemindTimeIntervalKey] intValue];
            sitRemind.week = [[QNWeek alloc] init];
            int repeatWeek = [[sitRemindDis valueForKey:BandMMKVSitRemindWeekRepeatKey] intValue];
            sitRemind.week.mon = BandMessageGetBit(repeatWeek, 0);
            sitRemind.week.tues = BandMessageGetBit(repeatWeek, 1);
            sitRemind.week.wed = BandMessageGetBit(repeatWeek, 2);
            sitRemind.week.thur = BandMessageGetBit(repeatWeek, 3);
            sitRemind.week.fri = BandMessageGetBit(repeatWeek, 4);
            sitRemind.week.sat = BandMessageGetBit(repeatWeek, 5);
            sitRemind.week.sun = BandMessageGetBit(repeatWeek, 6);
        }
    }
    return sitRemind;
}

- (void)setSitRemind:(QNSitRemind *)sitRemind {
    NSMutableDictionary<NSString *,id> *sitRemindDis = [NSMutableDictionary<NSString *,id> dictionary];
    [sitRemindDis setObject:[NSNumber numberWithBool:sitRemind.openFlag] forKey:BandMMKVSitRemindOpenKey];
    [sitRemindDis setObject:[NSNumber numberWithInt:sitRemind.startHour] forKey:BandMMKVSitRemindStartHourKey];
    [sitRemindDis setObject:[NSNumber numberWithInt:sitRemind.startMinture] forKey:BandMMKVSitRemindStartMinture];
    [sitRemindDis setObject:[NSNumber numberWithInt:sitRemind.endHour] forKey:BandMMKVSitRemindEndHourKey];
    [sitRemindDis setObject:[NSNumber numberWithInt:sitRemind.endMinture] forKey:BandMMKVSitRemindEndMintureKey];
    [sitRemindDis setObject:[NSNumber numberWithInt:sitRemind.timeInterval] forKey:BandMMKVSitRemindStartHourKey];
    int repeatWeek = 0;
    if (sitRemind.week.mon) repeatWeek = repeatWeek | (1 << 0);
    if (sitRemind.week.tues) repeatWeek = repeatWeek |  (1 << 1);
    if (sitRemind.week.wed) repeatWeek = repeatWeek |  (1 << 2);
    if (sitRemind.week.thur) repeatWeek = repeatWeek |  (1 << 3);
    if (sitRemind.week.fri) repeatWeek = repeatWeek |  (1 << 4);
    if (sitRemind.week.sat) repeatWeek = repeatWeek | (1 << 5);
    if (sitRemind.week.sun) repeatWeek = repeatWeek |  (1 << 6);
    [sitRemindDis setObject:[NSNumber numberWithInt:repeatWeek] forKey:BandMMKVSitRemindWeekRepeatKey];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:sitRemindDis options:NSJSONWritingPrettyPrinted error:nil];
    if (data) [self.mmkv setData:data forKey:BandMMKVSitRemindKey];
}


- (QNThirdRemind *)thirdRemind {
    NSData *data = [self.mmkv getDataForKey:BandMMKVThirdRemindKey];
    NSMutableDictionary<NSString *,id> *sitRemindDis = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    QNThirdRemind *thirdRemind = [[QNThirdRemind alloc] init];
    
    if (sitRemindDis == nil) {
        thirdRemind.callDelay = 3;
    }else {
        thirdRemind.callDelay = [[sitRemindDis valueForKey:BandMMKVThirdRemindCallDelayKey] intValue];
        int open = [[sitRemindDis valueForKey:BandMMKVThirdRemindOpenStateKey] intValue];
        thirdRemind.call = BandMessageGetBit(open, 0);
        thirdRemind.sms = BandMessageGetBit(open, 1);
        thirdRemind.faceBook = BandMessageGetBit(open, 2);
        thirdRemind.WeChat = BandMessageGetBit(open, 3);
        thirdRemind.QQ = BandMessageGetBit(open, 4);
        thirdRemind.twitter = BandMessageGetBit(open, 5);
        thirdRemind.whatesapp = BandMessageGetBit(open, 6);
        thirdRemind.linkedIn = BandMessageGetBit(open, 7);
        thirdRemind.instagram = BandMessageGetBit(open, 8);
        thirdRemind.faceBookMessenger = BandMessageGetBit(open, 9);
        thirdRemind.calendar = BandMessageGetBit(open, 10);
        thirdRemind.email = BandMessageGetBit(open, 11);
        thirdRemind.skype = BandMessageGetBit(open, 12);
        thirdRemind.pokeman = BandMessageGetBit(open, 13);
    }
    return thirdRemind;
}

- (void)setThirdRemind:(QNThirdRemind *)thirdRemind {
    NSMutableDictionary<NSString *,id> *thirdRemindDis = [NSMutableDictionary<NSString *,id> dictionary];
    [thirdRemindDis setObject:[NSNumber numberWithInt:thirdRemind.callDelay] forKey:BandMMKVThirdRemindCallDelayKey];
    int remind  = 0;
    if (thirdRemind.call) remind = (1 << 0) | remind;
    if (thirdRemind.sms) remind = (1 << 1) | remind;
    if (thirdRemind.faceBook) remind = (1 << 2) | remind;
    if (thirdRemind.WeChat)  remind = (1 << 3) | remind;
    if (thirdRemind.QQ) remind = (1 << 4) | remind;
    if (thirdRemind.twitter) remind = (1 << 5) | remind;
    if (thirdRemind.whatesapp) remind = (1 << 6) | remind;
    if (thirdRemind.linkedIn) remind = (1 << 7) | remind;
    if (thirdRemind.instagram) remind = (1 << 8) | remind;
    if (thirdRemind.faceBookMessenger) remind = (1 << 9) | remind;
    if (thirdRemind.calendar) remind = (1 << 10) | remind;
    if (thirdRemind.email) remind = (1 << 11) | remind;
    if (thirdRemind.skype) remind = (1 << 12) | remind;
    if (thirdRemind.pokeman) remind = (1 << 13) | remind;
    
    [thirdRemindDis setObject:[NSNumber numberWithInt:remind] forKey:BandMMKVThirdRemindOpenStateKey];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:thirdRemindDis options:NSJSONWritingPrettyPrinted error:nil];
    if (data) [self.mmkv setData:data forKey:BandMMKVThirdRemindKey];
}

- (void)cleanBandMessage {
    [self.mmkv clearAll];
}

@end
