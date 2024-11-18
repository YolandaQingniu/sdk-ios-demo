//
//  QNBleProtocolDelegate.h
//  QNDeviceSDK
//
//  Created by com.qn.device on 2019/8/26.
//  Copyright © 2019 com.qn.device. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QNBleProtocolDelegate <NSObject>

/**
 写入特征值
 
 @param serviceUUID 蓝牙服务的UUID
 @param characteristicUUID 特征值的UUID
 @param data 需要写入的数据
 @param device 需要写入数据的设备
 */
- (void)writeCharacteristicValue:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID data:(NSData *)data device:(QNBleDevice *)device;

/**
 读取特征值
 
 @param serviceUUID 蓝牙服务的UUID
 @param characteristicUUID 特征值的UUID
 @param device 需要写入数据的设备
 */
- (void)readCharacteristicValue:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID  device:(QNBleDevice *)device;
@end

NS_ASSUME_NONNULL_END
