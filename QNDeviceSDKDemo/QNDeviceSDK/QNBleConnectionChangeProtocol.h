//
//  QNBleConnectionChangeProtocol.h
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/31.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNBleDevice.h"

typedef NS_ENUM(NSInteger, QNDeviceState) {
    QNDeviceStateDisconnected     = 0,  //未连接
    QNDeviceStateLinkLoss         = -1, //失去连接
    QNDeviceStateConnected        = 1,  //已连接
    QNDeviceStateConnecting       = 2,  //正在连接
    QNDeviceStateDisconnecting    = 3,  //正在断开
    QNDeviceStateDeviceReady      = 4,  //设备已经准备好了，可以开始交互
    QNDeviceStateStartMeasure     = 5,  //正在测量
    QNDeviceStateRealTime         = 6,  //正在测量体重
    QNDeviceStateBodyFat          = 7,  //正在测试生物阻抗
    QNDeviceStateHeartRate        = 8,  //正在测试心率
    QNDeviceStateMeasureCompleted = 9,  //测量完成
};

@protocol QNBleConnectionChangeListener <NSObject>
/**
 正在连接的回调

 @param device QNBleDevice
 */
- (void)onConnecting:(QNBleDevice *)device;

/**
 连接成功的回调

 @param device QNBleDevice
 */
- (void)onConnected:(QNBleDevice *)device;

/**
 设备的服务搜索完成

 @param device QNBleDevice
 */
- (void)onServiceSearchComplete:(QNBleDevice *)device;

/**
 正在断开连接

 @param device QNBleDevice
 */
- (void)onDisconnecting:(QNBleDevice *)device;

/**
 断开设备连接

 @param device QNBleDevice
 */
- (void)onDisconnected:(QNBleDevice *)device;

/**
 连接错误

 @param device QNBleDevice
 @param error 错误代码
 */
- (void)onConnectError:(QNBleDevice *)device error:(NSError *)error;

/**
 秤连接或测量状态变化

 @param device QNBleDevice
 @param state 状态
 */
- (void)onDeviceStateChange:(QNBleDevice *)device scaleState:(QNDeviceState)state;

@end
