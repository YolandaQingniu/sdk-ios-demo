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

- (NSString *)getLastDataHmac:(QNBleDevice *)device user:(QNUser *)user;

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
