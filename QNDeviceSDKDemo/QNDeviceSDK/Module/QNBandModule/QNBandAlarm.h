//
//  QNBandAlarm.h
//  QNBandModule_iOS
//
//  Created by donyau on 2018/10/9.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    BOOL monFlag;
    BOOL tusFlag;
    BOOL wedFlag;
    BOOL thuFlag;
    BOOL firFlag;
    BOOL satFlag;
    BOOL sunFlag;
} QNAlarmWeek;

typedef NS_ENUM(NSUInteger, QNAlarmMode) {
    QNAlarmModeChange = 0,
    QNAlarmModeAdd,
    QNAlarmModeDelete,
};

@interface QNBandAlarm : NSObject
/* 闹钟ID(1 ~ 10) */
@property (nonatomic, assign) NSUInteger alarmID;
/* 闹钟名称 */
@property (nonatomic, strong) NSString *name;
/* 开关 */
@property (nonatomic, assign) BOOL openFlag;
/* 提醒小时 */
@property (nonatomic, assign) NSUInteger hour;
/* 提醒分钟 */
@property (nonatomic, assign) NSUInteger minture;
/** 闹钟类型 */
@property (nonatomic, assign) QNAlarmMode alarmMode;
/* 重复周期*/
@property (nonatomic, assign) QNAlarmWeek weekRepeat;
@end

NS_ASSUME_NONNULL_END
