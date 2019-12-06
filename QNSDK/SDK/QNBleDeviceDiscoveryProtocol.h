//
//  QNBleDeviceDiscoveryProtocol.h
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/31.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNBleDevice.h"
#import "QNBleBroadcastDevice.h"
#import "QNBleKitchenDevice.h"

@protocol QNBleDeviceDiscoveryListener <NSObject>
@optional
/**
 该方法会在成功启动扫描方法后回调
 */
- (void)onStartScan;


/**
 该方法会在发现设备后回调
 
 @param device QNBleDevice
 */
- (void)onDeviceDiscover:(QNBleDevice *)device;

/**
 收到广播秤后的设备回调
  
 @param device QNBleDevice
 */
- (void)onBroadcastDeviceDiscover:(QNBleBroadcastDevice *)device;


/**
收到厨房秤后的设备回调

@param device QNBleDevice
*/
- (void)onKitchenDeviceDiscover:(QNBleKitchenDevice *)device;

/**
 该方法会用户调用 "- (void)stopBleDeviceDiscorvery:(QNResultCallback)callback" 方法或者设置了扫描时间，扫描结束后回调
 */
- (void)onStopScan;

@end
