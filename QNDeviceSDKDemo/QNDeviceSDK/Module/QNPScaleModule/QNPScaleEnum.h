//
//  QNPScaleEnum.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/15.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#pragma mark 屏幕状态
typedef NS_ENUM(NSUInteger, QNDeviceScreenState) {
    QNDeviceScreenStateOpen = 0,
    QNDeviceScreenStateClose = 1,
};

#pragma mark 秤单位设置
typedef NS_ENUM(NSUInteger, QNPScaleUnitMode) {
    QNPScaleUnitKG = 0,
    QNPScaleUnitLB = 1,
    QNPScaleUnitJin = 2,//若秤不支持斤的显示，则显示KG
    QNPScaleUnitST = 3,//若秤不支持ST的显示，则显示ST
};


#pragma mark 秤端交互过程状态
typedef NS_ENUM(NSUInteger, QNPScaleState) {
    QNPScaleStateUnknow = 0, //未连接
    QNPScaleStateConnecting, //正在连接
    QNPScaleStateConnectFail, //连接失败
    QNPScaleStateConnected, //连接成功
    QNPScaleStateDiscoverServices, //发现服务
    QNPScaleStateDiscoverCharacteristics, //发现特征
    QNPScaleStateStartInteraction, //开始交互
    QNPScaleStateWifiStartNetwork, //正在开启联网通道
    QNPScaleStateWifiNetworkSuccess, //联网成功
    QNPScaleStateWifiNetworkFail, //联网失败
    QNPScaleStateConnectServiceSuccess, //与服务器通讯成功
    QNPScaleStateConnectServiceFail, //与服务器通讯失败
    QNPScaleStateRealTime ,//实时体重
    QNPScaleStateBodyFat, //测量阻抗
    QNPScaleStateHeartRate, //测量心率
    QNPScaleStateMeasureComplete, //测量完成
    QNPScaleStateDisconected, //设备断开
};

typedef NS_ENUM(NSUInteger, QNScaleDeviceCode) {
    QNScaleDeviceDiscoverServiceError = 12001,
    QNScaleDeviceDiscoverCharacteristicsError,
    QNScaleDeviceUnconnectedDeviceError,//未连接设备
    QNScaleDeviceHasDeviceConnectError,//已有设备连接
    QNScaleDeviceScaleDeviceParamsError,//连接对象参数有误
    QNScaleDeviceUserParamsError,//用户参数有误
    QNScaleDeviceWifiConfigParamsError,//wifi参数有误
};
