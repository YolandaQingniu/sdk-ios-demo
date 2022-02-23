//
//  QNBleDevice.h
//  QNDeviceSDK
//
//  Created by com.qn.device on 2018/1/9.
//  Copyright © 2018年 com.qn.device. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QNDeviceType) {
    QNDeviceTypeScaleBleDefault = 100, //普通蓝牙秤
    QNDeviceTypeScaleBroadcast = 120,  //广播秤
    QNDeviceTypeScaleKitchen = 130,  //厨房秤
    QNDeviceTypeUserScale = 140,  //用户蓝牙秤
    QNDeviceTypeScaleWsp API_DEPRECATED_WITH_REPLACEMENT("QNDeviceTypeUserScale", ios(4.0, 8.0)) = QNDeviceTypeUserScale,
    QNDeviceTypeHeightScale = 160,  //身高体重秤
};

@interface QNBleDevice : NSObject
/** mac地址 */
@property (nonatomic, readonly, strong) NSString *mac;
/** 设备名称 */
@property (nonatomic, readonly, strong) NSString *name;
/** 型号标识 */
@property (nonatomic, readonly, strong) NSString *modeId;
/** 蓝牙名称 */
@property (nonatomic, readonly, strong) NSString *bluetoothName;
/** 信号强度 */
@property (nonatomic, readonly, strong) NSNumber *RSSI;
/** 是否已开机 */
@property (nonatomic, readonly, getter=isScreenOn, assign) BOOL screenOn;
/** 是否支持WIFI */
@property (nonatomic, readonly, getter=isSupportWifi, assign) BOOL supportWifi;
/** 设备类型 */
@property (nonatomic, readonly, assign) QNDeviceType deviceType;
/** 秤最大支持注册用户数 */
@property(nonatomic, readonly, assign) int maxUserNum;
/** 秤已注册用户数 */
@property(nonatomic, readonly, assign) int registeredUserNum;
/** 是否支持八电极 */
@property(nonatomic, readonly, assign) BOOL isSupportEightElectrodes;
/** (WSP设备专属)是否支持OTA */
@property(nonatomic, readonly, assign) BOOL isSupportBleOTA;
/** (WSP设备专属)固件版本 */
@property(nonatomic, readonly, assign) int firmwareVer;
/** (WSP设备专属)硬件版本 */
@property(nonatomic, readonly, assign) int hardwareVer;
/** (WSP设备专属)软件版本 */
@property(nonatomic, readonly, assign) int softwareVer;

@end
