//
//  QNBleStateProtocol.h
//  QNDeviceSDKDemo
//
//  Created by com.qn.device on 2018/3/31.
//  Copyright © 2018年 com.qn.device. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSUInteger, QNBLEState) {
    QNBLEStateUnknown = 0,
    QNBLEStateResetting = 1,
    QNBLEStateUnsupported = 2,
    QNBLEStateUnauthorized = 3,
    QNBLEStatePoweredOff = 4,
    QNBLEStatePoweredOn = 5,
};

NS_ASSUME_NONNULL_BEGIN

/**
 蓝牙状态恢复数据模型
 App 在后台被系统唤醒后，SDK 通过该模型回传 CoreBluetooth 恢复出来的信息。
 拿到 peripherals 后，可结合上次连接缓存的广播数据，调用 QNBleApi 的 buildReconnectDevice: 系列方法快速重建设备对象并重连。
 */
@interface QNBleRestoreState : NSObject

/// 系统恢复出来的外设
@property (nonatomic, copy, readonly, nullable) NSArray<CBPeripheral *> *peripherals;

/// 恢复时正在扫描的 serviceUUIDs
@property (nonatomic, copy, readonly, nullable) NSArray<CBUUID *> *scanServices;

/// 恢复时的扫描参数
@property (nonatomic, copy, readonly, nullable) NSDictionary<NSString *, id> *scanOptions;

/// 原始字典，便于外部读取系统后续新增字段
@property (nonatomic, copy, readonly, nullable) NSDictionary<NSString *, id> *rawState;

@end

@protocol QNBleStateListener <NSObject>

/**
 系统蓝牙状态的回调

 @param state QNBLEState
 */
- (void)onBleSystemState:(QNBLEState)state;

@optional

/**
 蓝牙状态恢复回调（iOS 后台蓝牙状态恢复）
 仅当通过 QNConfig.restoreIdentifier 配置了状态恢复标识，且 App 由系统在后台唤醒时才会触发。

 @param restoreState 恢复内容
 */
- (void)onBleWillRestoreState:(QNBleRestoreState *)restoreState;

@end

NS_ASSUME_NONNULL_END
