//
//  QNWspEnum.h
//  QNDeviceModule
//
//  Created by donyau on 2019/7/27.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#ifndef QNWspEnum_h
#define QNWspEnum_h

#pragma mark 秤端交互过程状态

typedef NS_ENUM(NSUInteger, QNWspScaleState) {
    QNWspStateUnknow = 0,              //未连接
    QNWspStateConnecting,              //正在连接
    QNWspStatConnectFail,             //连接失败
    QNWspStateConnected,               //连接成功
    QNWspStateDiscoverServices,        //发现服务
    QNWspStateDiscoverCharacteristics, //发现特征
    QNWspStateDisconected,             //设备断开
    
    QNWspStateWiFiStartNetwork,        //正在开启联网通道
    QNWspStateWiFiConfigSuccess,  //配网信息写入成功
    QNWspStateWiFiNetworkSuccess,      //联网成功
    QNWspStateWiFiNetworkFail,         //联网失败
    
    QNWspStateWiFiStatusChcekStart,         //开始检测WiFi状态
    QNWspStateWiFiConnectNormal,         //WiFi连接正常
    QNWspStateWiFiConnectException,        //WiFi连接异常

    QNWspStateVisitUserStart, //开始访问用户
    QNWspStateVisitUserFail, //访问失败
    QNWspStateVisitUserSuccess, //访问成功
    
    QNWspStateSynUserInfoStart, //开始同步用户信息
    QNWspStateSynUserInfoFail, //同步用户信息失败
    QNWspStateSynUserInfoSuccess, //同步用户信息成功
    
    QNWspStateRegistUserStart, //开始注册用户
    QNWspStateRegistUserFail, //注册失败
    QNWspStateRegistUserSuccess, //注册成功
    
    QNWspStateDeleteUserStart, //开始删除用户 wsp  目前采用不采用该方式删除
    QNWspStateDeleteUserFail, //删除失败 wsp
    QNWspStateDeleteUserSuccess, //删除成功 wsp
    QNWspStateDeleteAllUserSuccess, //删除用户数组完成 wsp
    
    QNWspStateDeleteUsersStart, //开始批量删除用户
    QNWspStateDeleteUsersFail, //批量删除用户失败
    QNWspStateDeleteUsersSuccess, //批量删除用户成功

    QNWspStateReadHumanComponentRule, //读取人体成分
    QNWspStateObserverMeasureData, //监听测量数据
    QNWspStateRealTimeWeight, //实时数据
    QNWspStateMeasureBodyFat, //正在测量体脂
    QNWspStateMeasureHeartReat, //正在测量心率
    QNWspStateMeasureComplete, //测量完成
    
    QNWspStateSyncLocationStart, //开始同步地理位置
    QNWspStateSyncLocationSuccess, //地理位置同步成功
    QNWspStateSyncLocationFail, //地理位置同步失败

    QNWspStateProtocolErr, //协议异常
};

typedef NS_ENUM(NSUInteger, QNWspDeviceUnit) {
    QNWspDeviceUnitKG = 0,
    QNWspDeviceUnitJin,
    QNWspDeviceUnitLB,
    QNWspDeviceUnitST,
};

typedef NS_ENUM(NSUInteger, QNWspDeviceCode) {
    QNWspDeviceParamsError = 16001,
    QNWspDeviceHasDeviceConnectError,
    QNWspDeviceUnconnectedError,
    QNWspDeviceServiceError,
    QNWspDeviceCharacteristicsError,
    QNWspDeviceUserSecretIsNull,
    QNWspDeviceResponseOverTime,
    QNWspDeviceRegistUserFail,
    QNWspDeviceRegistUserNumOver,
    QNWspDeviceVisitFail,
    QNWspDeviceVisitKeyErr,
    QNWspDeviceVisitIndexErr,
    QNWspDeviceWriteSystemErr,
    QNWspDeviceNotifiySystemErr,
    QNWspDeviceWiFiPairFail,
    QNWspDeviceWifiConfigParamsError,
    QNWspDeviceDeleteUserFail,
    QNWspDeviceUpdateUserInfoFail,
};

#endif /* QNWspEnum_h */
