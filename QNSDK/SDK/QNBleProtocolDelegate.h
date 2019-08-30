//
//  QNBleProtocolDelegate.h
//  QNDeviceSDK
//
//  Created by JuneLee on 2019/8/26.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QNBleProtocolDelegate <NSObject>

/**
 写入特征值
 
 @param serviceUUID 蓝牙服务的UUID
 @param characteristicUUID 特征值的UUID
 @param data 需要写入的数据
 */
- (void)writeCharacteristicValue:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID data:(NSData *)data;

/**
 读取特征值
 
 @param serviceUUID 蓝牙服务的UUID
 @param characteristicUUID 特征值的UUID
 */
- (void)readCharacteristicValue:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID;
@end

NS_ASSUME_NONNULL_END
