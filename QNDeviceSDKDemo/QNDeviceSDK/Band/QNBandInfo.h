//
//  QNBandInfo.h
//  QNDeviceSDK
//
//  Created by donyau on 2019/1/3.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNBandInfo : NSObject
/** 固件版本 */
@property (nonatomic, assign) int hardwareVer;
/** 软件版本 */
@property (nonatomic, assign) int firmwareVer;
/** 电量 */
@property (nonatomic, assign) int electric;
@end

NS_ASSUME_NONNULL_END
