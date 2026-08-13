//
//  QNWspScaleDataProtocol.h
//  QNDeviceSDK
//
//  Created by com.qn.device on 2020/3/6.
//  Copyright © 2020 com.qn.device. All rights reserved.
//

#import "QNScaleDataProtocol.h"
#import "QNBleDevice.h"
#import "QNUser.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QNWspScaleDataListener <QNScaleDataListener>

@optional
- (void)wspRegisterUserComplete:(QNBleDevice *)device user:(QNUser *)user;

- (void)wspLocationSyncStatus:(QNBleDevice *)device suceess:(BOOL)suceess;

- (void)wspReadSnComplete:(QNBleDevice *)device sn:(NSString *)sn;

- (void)wspRestoreFactorySettings:(QNBleDevice *)device suceess:(BOOL)suceess;

/// 自 QNDeviceSDK 2.37.0 起废弃，iOS 不可用。
/// 请在发起蓝牙连接前，将上一笔有效测量 HMAC 写入 `QNWspConfig.curUser.hmac`；
/// 没有历史 HMAC 时请显式传入空字符串 `@""`。
- (NSString *)wspGetLastDataHmac:(QNBleDevice *)device user:(QNUser *)user API_UNAVAILABLE(ios);
@end

NS_ASSUME_NONNULL_END
