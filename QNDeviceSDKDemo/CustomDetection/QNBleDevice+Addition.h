//
//  QNBleDevice+Addition.h
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2020/10/21.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNDeviceSDK.h"
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNBleDevice (Addition)

@property(nonatomic, strong) CBPeripheral *peripheral;

@property(nonatomic, strong) CBCharacteristic *ffe3Write;
@property(nonatomic, strong) CBCharacteristic *ffe4Write;
@property(nonatomic, strong) CBCharacteristic *fff2Write;

@property(nonatomic, strong) QNBleProtocolHandler *handler;

@end

NS_ASSUME_NONNULL_END
