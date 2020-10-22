//
//  QNPScaleManager.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/15.
//  Copyright © 2018年 Yolanda. All rights reserved.
//  4.7.0


#import <Foundation/Foundation.h>
#import "QNPScaleDevice.h"
#import "QNPScaleData.h"
#import "QNPScaleReplayData.h"
#import "QNPScaleStorageData.h"
#import "QNPProduct.h"
#import "QNPWifiConfig.h"
#import "QNPScaleConfig.h"
#import "QNPProtocolData.h"

@class QNCentralManager;
@class QNConnectConfig;

NS_ASSUME_NONNULL_BEGIN

typedef void (^QNScaleDeviceResponseBlock)(BOOL success, NSError *__nullable error);

@protocol QNPScaleDelegate <NSObject>
@optional
/**
 发现设备

 @param device device
 */
- (void)discoverPublicScaleDevice:(QNPScaleDevice *)device;


/**
 设备信息更新（主要更新设备是否支持某些功能）

 @param device 设备信息
 */
- (void)publicScaleUpdateConnectDeviceMessage:(QNPScaleDevice *)device;

/**
 实时体重
 
 @param weight 实时体重
 @param device 当前连接的秤
 */
- (void)publicScaleReceiveRealTimeWeight:(double)weight connectedDevice:(QNPScaleDevice *)device;

/**
 测量数据(当次测量的结果)
 
 @param scaleData QNPScaleData
 @param device 当前连接的秤
 */
- (void)publicScaleReceiveResultData:(QNPScaleData *)scaleData connectedDevice:(QNPScaleDevice *)device;

/**
 测量数据(存储数据)
 
 @param storageScaleData QNBTScaleStorageData
 @param device 当前连接的秤
 */
- (void)publicScaleReceiveStorageData:(QNPScaleStorageData *)storageScaleData connectedDevice:(QNPScaleDevice *)device;

/**
体重测量完成回调

@param weight 体重
@param device 当前连接的秤
*/
- (void)publicScaleReceiveWeightCompleteData:(double)weight connectedDevice:(QNPScaleDevice *)device;

/**
 回传数据在心率秤上显示脂肪率、脂肪等级、BMI、BMI等级
 
 @param scaleData 测试数据
 @param device 当前连接的秤
 @return QNBReplayData
 */
- (QNPScaleReplayData *)publicScaleRequestRelayDataForMeasureData:(QNPScaleData *)scaleData connectedDevice:(QNPScaleDevice *)device;

/**
 秤端软件版本
 
 @param scaleVersion 秤体端软件版本
 @param bleVersion 蓝牙端软件版本
 @param device 当前连接的秤
 */
- (void)publicScaleVersion:(NSUInteger)scaleVersion bleVersion:(NSUInteger)bleVersion connectedDevice:(QNPScaleDevice *)device;

/**
 秤端的电量
 
 @param electric 电量(百分比)
 @param device 当前连接的秤
 */
- (void)publicScaleReceiveElectric:(NSUInteger)electric connectedDevice:(QNPScaleDevice *)device;


/**
 低电压提示

 @param device 当前连接的秤
 */
- (void)publicScaleLowElectricConnectedDevice:(QNPScaleDevice *)device;

/**
 秤端的交互状态
 
 @param scaleState 状态
 @param errCode 错误码(根据蓝牙排查错误码规则返回)
 @param device 当前连接的秤
 */
- (void)publicScaleChangeToScaleState:(QNPScaleState)scaleState connectedDevice:(QNPScaleDevice *)device errCode:(NSInteger)errCode error:(nullable NSError *)error;

/**
 写入数据
 
 @param protocolData 需要写入的数据
 */
- (void)publicScaleWriteData:(QNPProtocolData *)protocolData connectedDevice:(QNPScaleDevice *)device;

/**
 OTA升级状态回调
 @param otaState OTA升级状态
 @param progress 更新进度（0.0 ~ 1.0）
 @param device 当前链接设备
 */
- (void)publicScaleChangeOTAState:(QNPScaleOTAState)otaState progress:(double)progress connectedDevice:(QNPScaleDevice *)device;
@end


@interface QNPScaleManager : NSObject

@property (nonatomic, weak) id<QNPScaleDelegate> delegate;

/** 是否回传写入数据回调 */
@property (nonatomic, assign) BOOL isCallBackWriteData;

/**
 公版协议管理类

 @return QNPScaleManager
 */
+ (QNPScaleManager *)sharedScaleManager;

/**
 初始化方法

 @return QNPScaleManager
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 初始化QNPScaleManager

 @param centralManager QNCentralManager
 @return QNPScaleManager
 */
- (instancetype)initWithCentralManager:(QNCentralManager *)centralManager;

/**
 连接公版协议秤

 @param device 设备
 @param user 用户信息
 @param wifiConfig 双模秤的wifi配置
 @param configBlock 连接配置项
 @param block 回调
 */
- (void)connectScaleDevice:(QNPScaleDevice *)device user:(QNPUser *)user wifiConifg:(nullable QNPWifiConfig *)wifiConfig configBlock:(void (^)(QNConnectConfig *config, QNPScaleConfig *scaleConifg))configBlock response:(nullable QNScaleDeviceResponseBlock)block;

/**
 断开设备的连接
 */
- (void)cancelConnectScaleDevice:(QNPScaleDevice *)device;

/**
 启动配网

 @param wifiConfig QNPWifiConfig
 @param block 回调
 */
- (void)setUpNetworkToDevice:(QNPScaleDevice *)device conifg:(nullable QNPWifiConfig *)wifiConfig response:(nullable QNScaleDeviceResponseBlock)block;

/**
 更新设备信息
 
 @param product 设备信息
 */
- (void)updateInternalModelWithDevice:(QNPScaleDevice *)device product:(QNPProduct *)product;

/**
 解析协议数据
 
 @param serviceUUID 服务UUID
 @param characteristicUUID 特征值UUID
 @param receiveData 需要解析的蓝牙数据
 @param scaleDevice 设备
 @param error 错误
 */
- (void)analysisProtocolData:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID receiveData:(NSData *)receiveData scaleDevice:(QNPScaleDevice *)scaleDevice error:(nullable NSError *)error;

/**
 初始化蓝牙协议服务
 
 @param device 设备
 @param serviceUUID 服务UUID
 */

- (void)prepareBleWithDevice:(QNPScaleDevice *)device protocol:(NSString *)serviceUUID;

/**
  发送OTA数据包
 */
- (void)sendOTADataToDevice:(QNPScaleDevice *)device data:(NSData *)data;
@end

/******************************************** 秤端单位的更变 ********************************************/
@interface QNPScaleManager (Unit)
/**
 设置秤的单位
 
 @param unitMode 单位
 */
- (void)setScaleUnit:(QNPScaleUnitMode)unitMode device:(QNPScaleDevice *)device response:(nullable QNScaleDeviceResponseBlock)block;

@end

NS_ASSUME_NONNULL_END
