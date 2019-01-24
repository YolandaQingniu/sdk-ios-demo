//
//  QNCleanInfo.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/1/3.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNCleanInfo : NSObject
/** 是否清除闹钟设置 */
@property (nonatomic, assign) BOOL alarm;
/** 是否清除目标设置 */
@property (nonatomic, assign) BOOL goal;
/** 是否清除度量设置 */
@property (nonatomic, assign) BOOL metrics;
/** 是否清除久坐提醒设置 */
@property (nonatomic, assign) BOOL sitRemind;
/** 是否清除防丢提醒设置 */
@property (nonatomic, assign) BOOL lossRemind;
/** 是否清除心率监控设置 */
@property (nonatomic, assign) BOOL heartRateObserver;
/** 是否清除抬腕识别设置 */
@property (nonatomic, assign) BOOL handRecoginze;
/** 是否清除绑定设置 */
@property (nonatomic, assign) BOOL bindState;
/** 是否清除第三方提醒设置 */
@property (nonatomic, assign) BOOL thirdRemind;
@end

NS_ASSUME_NONNULL_END
