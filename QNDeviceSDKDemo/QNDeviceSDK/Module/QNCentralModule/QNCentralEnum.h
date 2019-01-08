//
//  QNCentralEnum.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/12.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#pragma mark 系统蓝牙状态
typedef NS_ENUM(NSUInteger, QNBlueToothState) {
    QNBlueToothStateUnknown = 0,
    QNBlueToothStateResetting,
    QNBlueToothStateUnsupported,
    QNBlueToothStateUnauthorized,
    QNBlueToothStatePoweredOff,
    QNBlueToothStatePoweredOn,
};

#pragma mark 设备连接状态
typedef NS_ENUM(NSUInteger, QNPeripheralState) {
    QNPeripheralStateUnknow = 0,//未连接
    QNPeripheralStateConnecting = 1,//正在连接
    QNPeripheralStateConnectFail = 2,//连接失败
    QNPeripheralStateConnected = 3,//连接成功
    QNPeripheralStateDisconected = 4,//设备断开
};

typedef NS_ENUM(NSUInteger, QNCentralCode) {
    QNCentralStateUnknownError = 11001,
    QNCentralStateResettingError,
    QNCentralStateUnsupportedError,
    QNCentralStateUnauthorizedError,
    QNCentralStatePoweredOffError,
    QNCentralStateConnectFailError,
    QNCentralStatePeripheralHasConnectError,
};

typedef NS_ENUM(NSUInteger, QNCentralScanState) {
    QNCentralScanEnd = 0,
    QNCentralScanStart,
};
