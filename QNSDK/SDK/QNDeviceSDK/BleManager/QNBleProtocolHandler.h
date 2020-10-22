//
//  QNBleProtocolHandler.h
//  QNDeviceSDKDemo
//
//  Created by JuneLee on 2019/8/26.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNBleProtocolHandler : NSObject

/** 外设设备 */
@property (nonatomic, strong) CBPeripheral *peripheral;

/**
 通知协议处理器初始化
 
 @param serviceUUID 主服务的UUID
 */
- (void)prepare:(NSString *)serviceUUID;

/**
 获取蓝牙数据
 
 @param serviceUUID 蓝牙服务的UUID
 @param characteristicUUID 特征值的UUID
 @param data 蓝牙回传的数据
 */
- (void)onGetBleData:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID data:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
