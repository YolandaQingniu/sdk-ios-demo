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
    QNPeripheralStateUnknow      = 0, //未连接
    QNPeripheralStateConnecting  = 1, //正在连接
    QNPeripheralStateConnectFail = 2, //连接失败
    QNPeripheralStateConnected   = 3, //连接成功
    QNPeripheralStateDisconected = 4, //设备断开
};

typedef NS_ENUM(NSUInteger, QNCentralCode) {
    QNCentralStateUnknownError = 11001,
    QNCentralStateResettingError,
    QNCentralStateUnsupportedError,
    QNCentralStateUnauthorizedError,
    QNCentralStatePoweredOffError,
    QNCentralStateConnectFailError, //连接失败
    QNCentralStatePeripheralHasConnectError, //已有设备连接
    QNCentralResponseTimeover, //已有设备连接
};

typedef NS_ENUM(NSUInteger, QNCentralScanState) {
    QNCentralScanEnd = 0,
    QNCentralScanStart,
};

typedef NS_ENUM(NSInteger, QNBleErrCode) {
    QNBleErrCodeUnException = 0,
    QNBleErrCodeStateClose = 1100,
    QNBleErrCodeStateException = 1101,
    QNBleErrCodeStateUnauthorized = 1102,
    
    QNBleErrCodeNotBroadcast = 1110,
    QNBleErrCodeNotOwnCompany = 1111,
    QNBleErrCodeBroadcastRule = 1112,
    QNBleErrCodeNotBindDevice = 1113,
    
    QNBleErrCodeConnectOvertime = 1120,
    QNBleErrCodeConnectSystem = 1121,
    QNBleErrCodeDiscoverServer = 1122,
    QNBleErrCodeDiscoverCharacteristic = 1123,
    QNBleErrCodeNotify = 1124,
    QNBleErrCodeMeasureBreak = 1125,
    
    QNBleErrCodeNotReceiveData = 1130,
    QNBleErrCodeReceiveData = 1131,
    QNBleErrCodeNotBodyFatProgress = 1132,
    QNBleErrCodeNotResistance = 1133,

    QNBleErrCodeConnectWiFi = 1140,
    QNBleErrCodeStartPair = 1142,
    QNBleErrCodePairWiFiInfoWrite = 1143,
};
