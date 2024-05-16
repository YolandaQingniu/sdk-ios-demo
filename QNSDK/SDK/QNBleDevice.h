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

typedef NS_ENUM(NSUInteger, QNDisplayModuleType) {
    QNDisplayModuleTypeDefault = 0, //秤端显示数据模块类型：88888
    QNDisplayModuleTypeSimple,  //秤端显示数据模块类型：18888
};

typedef NS_ENUM(NSUInteger, QNScreenState) {
    QNScreenStateOpen = 0,     //开机亮屏
    QNScreenStateClose,        //待机息屏
    QNScreenStateNewModeOpen,  //开机亮屏 (新模式)
    QNScreenStateNewModeClose, //待机息屏 (新模式)
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
/** 秤端屏幕状态*/
@property (nonatomic, readonly, assign) QNScreenState screenState;
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

/** (用户秤设备专属)更新识别体重 */
@property(nonatomic, readonly, assign) BOOL isSupportUpdateIdentifyWeight;
/** (设备开始交互生效)设置是否支持控制测脂功能 */
@property(nonatomic, readonly, assign) BOOL isSupportControlFatMeasurement;
/** 显示模块类型*/
@property(nonatomic, readonly, assign) QNDisplayModuleType displayModuleType;
/** (用户秤设备专属)是否支持调整体年龄显示标识（部分秤支持，NO：不支持；Yes：支持）如果支持，可以设置用户秤在显示体年龄时会-2*/
@property (nonatomic, readonly, assign) BOOL isSupportAdjustBodyAge;

/** (用户秤设备专属)是否支持抱婴模式标识（部分秤支持，NO：不支持；Yes：支持）如果支持，可以设置用户秤单次称量进入抱婴模式，秤面只会显示体重数据*/
@property (nonatomic, readonly, assign) BOOL isSupportBabyCarryingModel;

/// (用户秤设备专属)是否支持蜂鸣器功能（部分秤支持，NO：不支持；Yes：支持  如果支持，可以设置用户秤是否开启蜂鸣器开关）
@property (nonatomic, readonly, assign) BOOL isSupportBuzzer;

@end
