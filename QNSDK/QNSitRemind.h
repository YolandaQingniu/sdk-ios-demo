//
//  QNSitRemind.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/1/3.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNWeek.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNSitRemind : NSObject

/** 开关 */
@property (nonatomic, assign) BOOL openFlag;
/** 提醒功能生效时间小时，设置范围为 0 - 23 */
@property (nonatomic, assign) int startHour;
/** 提醒功能生效时间分钟，设置范围为 0 - 59 */
@property (nonatomic, assign) int startMinture;
/** 提醒功能失效时间小时，设置范围为 0 - 23 */
@property (nonatomic, assign) int endHour;
/** 提醒功能失效时间分钟，设置范围为 0 - 59 */
@property (nonatomic, assign) int endMinture;
/** 时间间隔，隔多久提醒一次 15 - 180 */
@property (nonatomic, assign) int timeInterval;
/** 提醒的周期时间 */
@property (nonatomic, strong) QNWeek *week;

@end

NS_ASSUME_NONNULL_END
