//
//  QNUserScaleDataProtocol.h
//  QNDeviceSDK
//
//  Created by sumeng on 2021/11/25.
//  Copyright © 2021 Yolanda. All rights reserved.
//

#import "QNScaleDataProtocol.h"
#import "QNBleDevice.h"
#import "QNUser.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QNUserScaleDataListener <QNScaleDataListener>

@optional
- (void)registerUserComplete:(QNBleDevice *)device user:(QNUser *)user;

/// 自 QNDeviceSDK 2.37.0 起废弃，iOS 不可用。
/// 请在发起蓝牙连接前，将上一笔有效测量 HMAC 写入连接配置的 `config.curUser.hmac`；
/// 没有历史 HMAC 时请显式传入空字符串 `@""`。
- (NSString *)getLastDataHmac:(QNBleDevice *)device user:(QNUser *)user API_UNAVAILABLE(ios);

/// 更新减重秤设备设置的回调
/// @param success 操作是否成功
/// @param device  蓝牙设备对象
- (void)updateSlimDeviceConfigResult:(BOOL)success device:(QNBleDevice *)device;

/// 更新秤端已注册用户的曲线体重数据的回调
/// @param success 操作是否成功
/// @param device  蓝牙设备对象
/// @param userIndex  用户坑位索引
- (void)updateUserCurveDataResult:(BOOL)success device:(QNBleDevice *)device userIndex:(int)userIndex;

/// 更新秤端已注册用户的减重配置信息
/// @param success 操作是否成功
/// @param device  蓝牙设备对象
/// @param userIndex  用户坑位索引
- (void)updateUserSlimConfigResult:(BOOL)success device:(QNBleDevice *)device userIndex:(int)userIndex;

/// 恢复出厂设置的回调
/// @param success 操作是否成功
/// @param device  蓝牙设备对象
- (void)deviceRestoreFactorySettings:(BOOL)success device:(QNBleDevice *)device;

@end

NS_ASSUME_NONNULL_END
