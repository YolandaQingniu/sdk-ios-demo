//
//  QNBleDevice+Addittion.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/10.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNBleDevice.h"
#import "QNResultData.h"
#import "QNPScaleDevice.h"
#import "QNSDKConfig.h"
#import "QNBandDevice.h"

@interface QNBleDevice (Addittion)

@property (nonatomic, strong) QNPScaleDevice *scaleDevice;

@property (nonatomic, strong) QNBandDevice *bandDevice;

@property (nonatomic, strong) QNDeviceMessage *deviceMessage;

+ (QNBleDevice *)createQNBleDeviceForDevice:(id)device;

@end
