//
//  QNBleBroadcastDevice+QNAddition.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/7/11.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "QNBleBroadcastDevice.h"
#import "QNBleDevice.h"
#import "QNAdvertScaleDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBleBroadcastDevice (QNAddition)

@property(nonatomic, assign) int res;

@property(nonatomic, assign) NSTimeInterval timeTemp;

@property(nonatomic, strong) QNAdvertScaleDevice *advertDevice;


- (void)tranform:(QNBleDevice *)device;

@end

NS_ASSUME_NONNULL_END
