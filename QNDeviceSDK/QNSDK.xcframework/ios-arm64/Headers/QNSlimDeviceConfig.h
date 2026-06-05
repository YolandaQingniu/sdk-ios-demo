//
//  SlimDeviceConfig.h
//  QNDeviceSDK
//
//  Created by yolanda on 2025/10/24.
//  Copyright © 2025 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNConfig.h"
#import "QNSlimVoiceConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QNSlimAlarmOperation) {
    QNSlimAlarmOperationNoModify = 0,   // 不修改闹钟设置
    QNSlimAlarmOperationCloseAll = 1,   // 关闭所有闹钟
    QNSlimAlarmOperationSetDays = 2     // 打开并设置具体生效日期
};

typedef NS_OPTIONS(NSInteger, QNSlimAlarmWeekDays) {
    QNSlimAlarmWeekDayMonday    = 1 << 0,   // 周一
    QNSlimAlarmWeekDayTuesday   = 1 << 1,   // 周二
    QNSlimAlarmWeekDayWednesday = 1 << 2,   // 周三
    QNSlimAlarmWeekDayThursday  = 1 << 3,   // 周四
    QNSlimAlarmWeekDayFriday    = 1 << 4,   // 周五
    QNSlimAlarmWeekDaySaturday  = 1 << 5,   // 周六
    QNSlimAlarmWeekDaySunday    = 1 << 6,   // 周日
};

typedef NS_ENUM(NSUInteger, QNSlimVoiceVolume) {
    QNSlimVoiceVolumeNoModify = 0,   // 不修改当前音量设置
    QNSlimVoiceVolumeLevel1   = 1,   // 音量1档
    QNSlimVoiceVolumeLevel2   = 2,   // 音量2档
    QNSlimVoiceVolumeLevel3   = 3,   // 音量3档
    QNSlimVoiceVolumeLevel4   = 4    // 音量4档
};

@interface QNSlimDeviceConfig : NSObject
// 闹钟提醒操作类型，支持不修改、关闭和打开（设置提醒日）
@property (nonatomic, assign) QNSlimAlarmOperation  alarmOperation;
// 闹钟提醒生效日集合，所有提醒生效日的提醒时间（`alarmHour`和`alarmMinute`）都是一样的；`alarmOperation`为`SlimAlarmOperationSetDays`时必传且有效；
@property (nonatomic, assign) QNSlimAlarmWeekDays  alarmWeekDays;
// 闹钟提醒时间-小时；`alarmOperation`为`SlimAlarmOperationSetDays`时必传且生效；值范围[0, 23]
@property (nonatomic, assign) int  alarmHour;
// 闹钟提醒时间-分钟；`alarmOperation`为`SlimAlarmOperationSetDays`时必传且生效；值范围[0, 59]
@property (nonatomic, assign) int  alarmMinute;
// 提示音音量，支持不修改和1-4级的音量调节。
@property (nonatomic, assign) QNSlimVoiceVolume  voiceVolume;
// 闹钟提醒提示音配置
@property (nonatomic, strong) QNSlimVoiceConfig  *alarmVoice;
// 上秤测量提示音配置
@property (nonatomic, strong) QNSlimVoiceConfig  *measureStartVoice;
// 测量完成提示音配置
@property (nonatomic, strong) QNSlimVoiceConfig  *measureFinishVoice;
// 完成目标提示音配置
@property (nonatomic, strong) QNSlimVoiceConfig  *completeGoalVoice;


@end

NS_ASSUME_NONNULL_END
