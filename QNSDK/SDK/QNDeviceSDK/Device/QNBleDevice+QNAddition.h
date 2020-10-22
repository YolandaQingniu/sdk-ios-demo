//
//  QNBleDevice+QNAddition.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/10.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNBleDevice.h"
#import "QNPScaleDevice.h"
#import "QNAdvertScaleDevice.h"
#import "QNWspDevice.h"
#import "QNDeviceTool.h"
#import "QNHeightScaleDevice.h"
#import "QNUser.h"

NS_ASSUME_NONNULL_BEGIN
@interface QNBleDevice (QNAddition)

@property (nonatomic, strong) QNPScaleDevice *publicDevice;

@property (nonatomic, strong) QNAdvertScaleDevice *advertDevice;

@property (nonatomic, strong) QNWspDevice *wspDevice;

@property (nonatomic, strong) QNHeightScaleDevice *heightScaleDevice;

@property(nonatomic, strong) QNAuthDevice *authDevice;

@property(nonatomic, strong) QNUser *user;

//checkOtherDeviceFlag 是否需要检验额外设备，当不需要校验时，默认返回默认设备。目前只用在共享秤
+ (nullable QNBleDevice *)buildBleDeviceWithDevice:(nullable id)device;

@end
NS_ASSUME_NONNULL_END
