//
//  QNAlarm.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/1/3.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNWeek.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNAlarm : NSObject

/** 闹钟id，闹钟的唯一标识，设置范围为 1 - 10 */
@property (nonatomic, assign) int alarmId;
/** 闹钟开关 */
@property (nonatomic, assign) BOOL openFlag;
/** 提醒小时，设置范围为 0 - 23 */
@property (nonatomic, assign) int hour;
/** 提醒分钟，设置范围为 0 - 59 */
@property (nonatomic, assign) int minture;
/** 提醒的周期 */
@property (nonatomic, strong) QNWeek *week;
@end

NS_ASSUME_NONNULL_END
