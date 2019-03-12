//
//  QNBandBaseConfig.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/1/3.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNUser.h"
#import "QNBandMetrics.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBandBaseConfig : NSObject
/** 自动检测心率开关 */
@property (nonatomic, assign) BOOL heartRateObserver;
/** 抬腕亮屏的开关 */
@property (nonatomic, assign) BOOL handRecog;
/** 查找手机的开关 */
@property (nonatomic, assign) BOOL findPhone;
/** 防丢提醒的开关 */
@property (nonatomic, assign) BOOL lostRemind;
/** 用户信息 */
@property (nonatomic, strong) QNUser *user;
/** 目标步数 */
@property (nonatomic, assign) int stepGoal;
/** 度量 */
@property (nonatomic, strong) QNBandMetrics *metrics;
@end

NS_ASSUME_NONNULL_END
