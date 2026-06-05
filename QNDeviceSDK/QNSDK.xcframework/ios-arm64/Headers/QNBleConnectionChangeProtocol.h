//
//  QNBleConnectionChangeProtocol.h
//  QNDeviceSDKDemo
//
//  Created by com.qn.device on 2018/3/31.
//  Copyright © 2018年 com.qn.device. All rights reserved.
//

#import "QNBleDevice.h"

typedef NS_ENUM(NSInteger, QNScaleState) {
    QNScaleStateDisconnected = 0, //未连接
    QNScaleStateLinkLoss = -1, //失去连接
    QNScaleStateConnected = 1, //已连接
    QNScaleStateConnecting = 2, //正在连接
    QNScaleStateDisconnecting = 3, //正在断开
    QNScaleStateStartMeasure = 4, //正在测量
    QNScaleStateRealTime = 5, //正在测量体重
    QNScaleStateBodyFat = 7, //正在测试生物阻抗
    QNScaleStateHeartRate = 8, //正在测试心率
    QNScaleStateMeasureCompleted = 9, //测量完成
    QNScaleStateWiFiBleStartNetwork = 10, //WiFi蓝牙双模设备开始配网
    QNScaleStateWiFiBleNetworkSuccess = 11, //WiFi蓝牙双模设备联网成功
    QNScaleStateWiFiBleNetworkFail = 12, //WiFi蓝牙双模设备联网失败
    QNScaleStateBleKitchenPeeled = 13, //蓝牙厨房秤称端去皮
    QNScaleStateHeightScaleMeasureFail = 14, //身高体重秤测量失败
    QNScaleStateNeedOta = 15, //设备需要OTA
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
 设备断开连接
 
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
 设备开始交互
 
 @param device QNBleDevice
 */
@optional
- (void)onStartInteracting:(QNBleDevice *)device;

@end

