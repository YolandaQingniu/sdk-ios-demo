//
//  QNScaleDataProtocol.h
//  QNDeviceSDKDemo
//
//  Created by com.qn.device on 2018/3/31.
//  Copyright © 2018年 com.qn.device. All rights reserved.
//

#import "QNBleDevice.h"
#import "QNScaleData.h"
#import "QNScaleStoreData.h"
#import "QNHeightDeviceConfig.h"
#import "QNHeightDeviceFunction.h"

typedef NS_ENUM(NSInteger, QNScaleEvent) {
    QNScaleEventWiFiBleStartNetwork = 1, //WiFi蓝牙双模设备开始配网
    QNScaleEventWiFiBleNetworkSuccess = 2, //WiFi蓝牙双模设备联网成功
    QNScaleEventWiFiBleNetworkFail = 3, //WiFi蓝牙双模设备联网失败
    QNScaleEventRegistUserSuccess = 4, //用户秤专属，注册用户成功
    QNScaleEventRegistUserFail = 5, //用户秤专属，注册用户失败
    QNScaleEventVisitUserSuccess = 6, //用户秤专属，访问用户成功
    QNScaleEventVisitUserFail = 7, //用户秤专属，访问用户失败
    QNScaleEventDeleteUserSuccess = 8, //用户秤专属，删除用户成功
    QNScaleEventDeleteUserFail = 9, //用户秤专属，删除用户失败
    QNScaleEventSyncUserInfoSuccess = 10, //用户秤专属，同步用户信息成功
    QNScaleEventSyncUserInfoFail = 11, //用户秤专属，同步用户信息失败
    QNScaleEventUpdateIdentifyWeightSuccess = 12, //用户秤专属，更新用户识别体重成功
    QNScaleEventUpdateIdentifyWeightFail = 13, //用户秤专属，更新用户识别体重失败
    QNScaleEventUpdateScaleConfigSuccess = 14, //用户秤专属，更新秤端设置成功
    QNScaleEventUpdateScaleConfigFail = 15, //用户秤专属，更新秤端设置失败
    QNScaleEventUpdateUserCurveWeightDataSuccess = 16, // 用户秤专属，更新用户曲线体重数据成功
    QNScaleEventUpdateUserCurveWeightDataFail = 17, // 用户秤专属，更新用户曲线体重数据失败
    QNScaleEventUpdateUserSlimConfigSuccess = 18, // 用户秤专属，更新用户减重配置成功
    QNScaleEventUpdateUserSlimConfigFail = 19, // 用户秤专属，更新用户减重配置失败
    QNScaleEventRestoreFactorySettingsSuccess = 20, // 设备恢复出厂设置成功
    QNScaleEventRestoreFactorySettingsFail = 21, // 设备恢复出厂设置失败
};

@protocol QNScaleDataListener <NSObject>

/**
 实时数据的监听
 
 @param device QNBleDevice
 @param weight 实时体重
 */
- (void)onGetUnsteadyWeight:(QNBleDevice *)device weight:(double)weight;

/**
 稳定数据的监听
 
 @param device QNBleDevice
 @param scaleData 数据结果
 */
- (void)onGetScaleData:(QNBleDevice *)device data:(QNScaleData *)scaleData;


/**
 存储数据的监听
 
 @param device QNBleDevice
 @param storedDataList 结果数组
 */
- (void)onGetStoredScale:(QNBleDevice *)device data:(NSArray <QNScaleStoreData *> *)storedDataList;

/**
 充电款电量的监听

 @param electric electric
 @param device QNBleDevice
 */
- (void)onGetElectric:(NSUInteger)electric device:(QNBleDevice *)device;;

/**
 秤连接或测量状态变化
 
 @param device QNBleDevice
 @param state 状态
 */
- (void)onScaleStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state;

/**
 秤事件的回调
 
 @param device QNBleDevice
 @param scaleEvent 秤事件
 */
- (void)onScaleEventChange:(QNBleDevice *)device scaleEvent:(QNScaleEvent)scaleEvent;

@optional
/**
 普通蓝牙称读取设备SN码
 
 @param device QNBleDevice
 @param sn sn
 */
- (void)readSnComplete:(QNBleDevice *)device sn:(NSString *)sn;

/// 收到秤端固件版本号
/// @param device QNBleDevice
/// @param bleVer 固件版本号
- (void)onGetBleVer:(QNBleDevice *)device bleVer:(int)bleVer;

/// 收到秤端电量百分比（部分设备支持）
/// @param batteryLevel 0-100
/// @param isLowLevel 设备是否处于低电状态
/// @param device QNBleDevice
- (void)onGetBatteryLevel:(NSUInteger)batteryLevel isLowLevel:(BOOL)isLowLevel device:(QNBleDevice *)device;

/// 条形码数据回调(CP30专属)
/// @param barCode 条形码数据
/// @param mac mac
- (void)onGetBarCode:(NSString *)barCode mac:(NSString *)mac;

/// 条形码数据回调(CP30专属)
/// @param mac mac
- (void)onGetBarCodeFail:(NSString *)mac;

/// 扫码枪连接状态(CP30专属)
/// @param isConnect 条形码数据
/// @param mac mac
- (void)onGetBarCodeGunState:(BOOL)isConnect mac:(NSString *)mac;

/// 设置秤端功能结果的回调
/// @param isLanguageSuccess 语音播放语言是否设置功能
/// @param isWeightUnitSuccess 语音播放语言是否设置功能
/// @param isHeightUnitSuccess 语音播放语言是否设置功能
/// @param isVolumeSuccess 语音播放语言是否设置功能
- (void)onSetHeightScaleConfigState:(BOOL)isLanguageSuccess isWeightUnitSuccess:(BOOL)isWeightUnitSuccess isHeightUnitSuccess:(BOOL)isHeightUnitSuccess  isVolumeSuccess:(BOOL)isVolumeSuccess device:(QNBleDevice *)device;

/// 获取秤端功能结果的回调
/// @param function 秤端功能详情
- (void)onGetHeightScaleConfig:(QNHeightDeviceFunction *)function device:(QNBleDevice *)device;

/// 身高秤复位设置成功告知的回调
/// @param state true: 设置成功, false: 设置失败
- (void)onResetHeightScaleState:(BOOL)state device:(QNBleDevice *)device;

/// 获取身高秤wifi配置信息（只返回ssid信息）
/// @param state true: 获取成功, false: 获取失败
/// @param ssid WiFi的ssid(如果获取失败，ssid为nil)
- (void)onGetHeightScaleWifiConfig:(BOOL)state ssid:(NSString * _Nullable)ssid device:(QNBleDevice *)device;

/// 身高秤清除wifi配置成功告知的回调
/// @param state true: 设置成功, false: 设置失败
- (void)onClearHeightScaleWifiConfigState:(BOOL)state device:(QNBleDevice *)device;

/// 扫描身高秤可用的WiFi名称的回调（扫描到一个可用wifi回调调用一次）
/// @param ssid 可用的WiFi名称
/// @param rssi wifi的信号强度
- (void)onScanHeightScaleWifiSsidResult:(NSString *)ssid rssi:(int)rssi device:(QNBleDevice *)device;

/// 扫描身高秤可用wifi结束的回调
/// @param state 0: 扫描失败（不管是否有扫描到WiFi还是其他原因）, 1: 表示体重秤完成
- (void)onScanHeightScaleWifiSsidFinish:(int)state device:(QNBleDevice *)device;

@end
