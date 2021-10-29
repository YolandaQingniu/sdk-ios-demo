//
//  QNBleOTAProtocol.h
//  QNDeviceSDK
//
//  Created by sumeng on 2021/10/29.
//  Copyright © 2021 Yolanda. All rights reserved.
//

#import "QNBleDevice.h"
#import "QNErrorCode.h"

@protocol QNBleOTAListener <NSObject>

/**
 开始升级固件
 
 @param device QNBleDevice
 */
- (void)onOTAStart:(QNBleDevice *)device;

/**
 固件升级中
 
 @param device QNBleDevice
 */
- (void)onOTAUpgrading:(QNBleDevice *)device;


/**
 固件升级成功
 
 @param device QNBleDevice
 */
- (void)onOTACompleted:(QNBleDevice *)device;

/**
 固件升级失败

 @param device QNBleDevice
 */
- (void)onOTAFailed:(QNBleDevice *)device errorCode:(QNBleErrorCode)errorCode;

/**
 固件升级进度
 
  @param device QNBleDevice
  @param progress 升级进度（0 ~ 1）
 */

- (void)onOTAProgress:(QNBleDevice *)device progress:(double)progress;
@end
