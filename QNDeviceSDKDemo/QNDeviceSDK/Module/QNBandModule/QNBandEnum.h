
//
//  QNBandEnum.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/30.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#pragma mark 手环端交互过程状态
typedef NS_ENUM(NSUInteger, QNBandState) {
    QNBandStateUnknow = 0, //未连接
    QNBandStateConnecting, //正在连接
    QNBandStateConnectFail, //连接失败
    QNBandStateConnected, //连接成功
    QNBandStateDiscoverServices, //发现服务
    QNBandStateDiscoverCharacteristics, //发现特征
    QNBandStateStartInteraction, //开始交互
    QNBandStateDisconnected, //设备断开
};

typedef NS_ENUM(NSUInteger, QNBandUnitStype) {
    QNBandUnitMetric = 0,
    QNBandUnitBritish,
};

typedef NS_ENUM(NSUInteger, QNBandLanguageStype) {
    QNBandLanguageChina = 0,
    QNBandLanguageEnglish,
};

typedef NS_ENUM(NSUInteger, QNBandHourFormat) {
    QNBandHourFormat24 = 0,
    QNBandHourFormat12,
};


typedef NS_ENUM(NSUInteger, QNBandDeviceCode) {
    QNBandDeviceBandConnectDeviceParamsError = 13001,
    QNBandDeviceUnconnectedDeviceError,
    QNBandDeviceFindWriteCharacteristicsError,
    QNBandDeviceHasDeviceConnectError,
    QNBandDeviceDiscoverServiceError,
    QNBandDeviceDiscoverCharacteristicsError,
    QNBandDeviceWaitOverTimeError,
    QNBandDeviceReceiveDatatError,
};
