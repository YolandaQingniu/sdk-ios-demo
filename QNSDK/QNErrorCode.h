//
//  QNErrorCode.h
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/31.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

typedef NS_ENUM(NSInteger, QNBleErrorCode) {
    QNBleErrorCodeInvalidateAppId         = 1001, // APPID 无效
    QNBleErrorCodeNotInitSDK              = 1002, //未调用initSDK方法
    QNBleErrorCodeFirstDataFileURL        = 1003, //初始数据文件的Url有误
    QNBleErrorCodePackageName             = 1004, //安卓的包名不正确
    QNBleErrorCodeBundleID                = 1005, // iOS的Bundle Id不正确
    QNBleErrorCodeInitFile                = 1006, //初始配置文件有误
    
    QNBleErrorCodeBluetoothClosed         = 1101, //蓝牙已关闭
    QNBleErrorCodeLocationPermission      = 1102, //需求授权定位权限（安卓）
    QNBleErrorCodeBLEError                = 1103, //系统蓝牙错误
    QNBleErrorCodeConnectWhenConnecting   = 1104, //已有设备正在连接
    QNBleErrorCodeConnectWhenConnected    = 1105, //已有设备连接
    QNBleErrorCodeBluetoothUnknow         = 1106, //蓝牙状态未知
    QNBleErrorCodeBluetoothResetting      = 1107, //正在重启蓝牙系统
    QNBleErrorCodeBluetoothUnsupported    = 1108, //手机不支持蓝牙设备的使用
    QNBleErrorCodeBluetoothUnauthorized   = 1109, //未授权使用蓝牙设备
    QNBleErrorCodeConnectFail             = 1110, //蓝牙连接失败
    QNBleErrorCodePeripheralDisconnecting = 1111, //正在断开连接
    QNBleErrorCodeNoneScan                = 1112, //没有扫描到任何设备
    QNBleErrorCodeConnectOverTime         = 1113, //连接超时
    
    QNBleErrorCodeIllegalArgument         = 1201, //参数出错
    QNBleErrorCodeMissDiscoveryListener   = 1202, //没有设置DiscoveryListener
    QNBleErrorCodeMissDataListener        = 1203, //没有设置DataListener
    QNBleErrorCodeUserIdEmpty             = 1204, // userid 不能为空
    QNBleErrorCodeUserGender              = 1205, // gender错误
    QNBleErrorCodeUserHeight              = 1206, // height错误
    QNBleErrorCodeUserBirthday            = 1207, // birthday错误
    QNBleErrorCodeUserAthleteType         = 1209, // athleteType错误
    QNBleErrorCodeUserShapeGoalType       = 1210, // shapeGoalType错误
    QNBleErrorCodeUserWeight              = 1211, // weight错误
    QNBleErrorCodeDeviceUnconnectedDevice = 1212, //未连接设备
    QNBleErrorCodeDeviceSendCmdFail       = 1213, //发送命令失败
    QNBleErrorCodeDeviceResponseOvertiion = 1214, //响应超时

};
