//
//  QNErrorCode.h
//  QNDeviceSDKDemo
//
//  Created by com.qn.device on 2018/3/31.
//  Copyright © 2018年 com.qn.device. All rights reserved.
//

typedef NS_ENUM(NSInteger, QNBleErrorCode) {
    QNBleErrorCodeInvalidateAppId = 1001,
    QNBleErrorCodeNotInitSDK = 1002,
    QNBleErrorCodeFirstDataFileURL = 1003,
    QNBleErrorCodePackageName = 1004,
    QNBleErrorCodeBundleID = 1005,
    QNBleErrorCodeInitFile = 1006,
    
    QNBleErrorCodeBluetoothClosed = 1101,
    QNBleErrorCodeLocationPermission = 1102,
    QNBleErrorCodeBLEError = 1103,
    QNBleErrorCodeConnectWhenConnecting = 1104,
    QNBleErrorCodeConnectWhenConnected = 1105,
    QNBleErrorCodeBluetoothUnknow = 1106,
    QNBleErrorCodeBluetoothResetting = 1107,
    QNBleErrorCodeBluetoothUnsupported = 1108,
    QNBleErrorCodeBluetoothUnauthorized = 1109,
    QNBleErrorCodeConnectFail = 1110,
    QNBleErrorCodePeripheralDisconnecting = 1111,
    QNBleErrorCodeBleNoneScan = 1112,
    QNBleErrorCodeBleConnectOvertime = 1113,

    QNBleErrorCodeIllegalArgument = 1201,
    QNBleErrorCodeMissDiscoveryListener = 1202,
    QNBleErrorCodeMissDataListener = 1203,
    QNBleErrorCodeUserIdEmpty = 1204,
    QNBleErrorCodeUserGender = 1205,
    QNBleErrorCodeUserHeight = 1206,
    QNBleErrorCodeUserBirthday = 1207,
    QNBleErrorCodeUserAthleteType = 1209,
    QNBleErrorCodeUserShapeGoalType = 1210,
    QNBleErrorCodeDeviceType = 1211,
    QNBleErrorCodeWiFiParams = 1212,
    QNBleErrorCodeRegisterDevice = 1213,
    QNBleErrorCodeNoComoleteMeasure = 1214,
    QNBleErrorCodeNoSupportModify = 1215,
    QNBleErrorCodeUserIndex = 1216,
    QNBleErrorCodeUserSecret = 1217,
    QNBleErrorCodeWSPOTAFirmwareFail = 1218,
    QNBleErrorCodeWSPOtaLowPower = 1219,

    QNBleErrorCoder = 1301,
    QNBleErrorCoderInvalid = 1302,
    
    QNBleErrorCodeShouldEnableResEncrypt = 1400,
    QNBleErrorCodeInvalidateHmac = 1401,
    QNBleErrorCodeDataValidationFailed = 1402,
    
    QNBleErrorWSPUserIndex API_DEPRECATED_WITH_REPLACEMENT("QNBleErrorUserIndex", ios(4.0, 8.0)) = QNBleErrorCodeUserIndex,
    QNBleErrorWSPUserSecret API_DEPRECATED_WITH_REPLACEMENT("QNBleErrorUserSecret", ios(4.0, 8.0)) = QNBleErrorCodeUserSecret,
};
