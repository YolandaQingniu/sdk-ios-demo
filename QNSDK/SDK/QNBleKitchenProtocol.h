//
//  QNBleKitchenProtocol.h
//  QNDeviceSDK
//
//  Created by sumeng on 2021/9/8.
//  Copyright © 2021 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNBleKitchenDevice.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QNBleKitchenListener <NSObject>

@required
/**
 蓝牙厨房秤测量数据监听
 
 @param device QNBleKitchenDevice
 @param weight 实时重量
 */
- (void)onGetBleKitchenWeight:(QNBleKitchenDevice *)device weight:(double)weight;

/**
 蓝牙厨房秤秤连接或测量状态变化
 
 @param device QNBleKitchenDevice
 @param state 状态
 */
- (void)onBleKitchenStateChange:(QNBleKitchenDevice *)device scaleState:(QNScaleState)state;

@optional
/**
 正在连接的回调
 
 @param device QNBleKitchenDevice
 */
- (void)onBleKitchenConnecting:(QNBleKitchenDevice *)device;

/**
 连接成功的回调
 
 @param device QNBleKitchenDevice
 */
- (void)onBleKitchenConnected:(QNBleKitchenDevice *)device;

/**
 断开连接
 
 @param device QNBleKitchenDevice
 */
- (void)onBleKitchenDisconnected:(QNBleKitchenDevice *)device;

/**
 连接错误
 
 @param device QNBleDevice
 @param error 错误代码
 */
- (void)onBleKitchenConnectError:(QNBleKitchenDevice *)device error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
