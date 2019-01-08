//
//  QNPScaleManager.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/15.
//  Copyright © 2018年 Yolanda. All rights reserved.
//  3.7.0-beta.2

#import <Foundation/Foundation.h>
#import "QNPScaleDevice.h"
#import "QNPScaleData.h"
#import "QNPScaleReplayData.h"
#import "QNPScaleStorageData.h"
#import "QNPProduct.h"
#import "QNPWifiConfig.h"

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
 @param device 当前连接的秤
 */
- (void)publicScaleChangeToScaleState:(QNPScaleState)scaleState connectedDevice:(QNPScaleDevice *)device error:(nullable NSError *)error;

@end


@interface QNPScaleManager : NSObject
/** log前缀*/
@property (nonatomic, assign, class) BOOL logPrefix;
/** 若需要改变秤的型号，则设置该属性 */
@property (nonatomic, strong, nullable) QNPProduct *product;
/** 当前状态(QNPScaleStateUnknow、QNPScaleStateConnecting、QNPScaleStateConnected) */
@property (nonatomic, readonly, assign) QNPScaleState scaleState;

@property (nonatomic, weak) id<QNPScaleDelegate> delegate;

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
- (void)connectScaleDevice:(QNPScaleDevice *)device user:(QNPUser *)user wifiConifg:(nullable QNPWifiConfig *)wifiConfig configBlock:(void (^)(QNConnectConfig *config, QNPScaleUnitMode *unitMode))configBlock response:(nullable QNScaleDeviceResponseBlock)block;

/**
 断开设备的连接
 */
- (void)cancelConnectScaleDevice;

@end

/******************************************** 秤端单位的更变 ********************************************/
@interface QNPScaleManager (Unit)
/**
 设置秤的单位
 
 @param unitMode 单位
 */
- (void)setScaleUnit:(QNPScaleUnitMode)unitMode response:(nullable QNScaleDeviceResponseBlock)block;
@end

NS_ASSUME_NONNULL_END
