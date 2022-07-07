//
//  QNBleRulerProtocol.h
//  QNDeviceSDK
//
//  Created by sumeng on 2022/7/5.
//  Copyright © 2022 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNBleRulerDevice.h"
#import "QNBleRulerData.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QNBleRulerListener <NSObject>

/// 发现围度尺
/// @param device 设备信息
- (void)onRulerDeviceDiscover:(QNBleRulerDevice *)device;

/// 正在链接
/// @param device 设备信息
- (void)onRulerConnecting:(QNBleRulerDevice *)device;

/// 链接失败
/// @param device 设备信息
- (void)onRulerConnectFail:(QNBleRulerDevice *)device;

/// 链接成功
/// @param device 设备信息
- (void)onRulerConnected:(QNBleRulerDevice *)device;

/// 断开链接
/// @param device 设备信息
- (void)onRulerDisconnected:(QNBleRulerDevice *)device;

/// 实时测量数据
/// @param data 测量数据信息
/// @param device 设备信息
- (void)onGetReceiveRealTimeData:(QNBleRulerData *)data device:(QNBleRulerDevice *)device;

/// 稳定测量数据
/// @param data 测量数据信息
/// @param device 设备信息
- (void)onGetReceiveResultData:(QNBleRulerData *)data device:(QNBleRulerDevice *)device;

@end

NS_ASSUME_NONNULL_END
