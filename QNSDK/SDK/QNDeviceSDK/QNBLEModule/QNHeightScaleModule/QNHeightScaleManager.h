//
//  QNHeightScaleManager.h
//  Pods
//
//  Created by qiudongquan on 2020/6/10.
//  4.7.0


#import <Foundation/Foundation.h>
#import "QNHeightScaleData.h"
#import "QNHeightScaleDevice.h"
#import "QNHeightScaleEnum.h"
#import "QNHeightScaleData.h"
#import "QNHeightStorageScaleData.h"
#import "QNWeightScaleConfig.h"

@class QNCentralManager;
NS_ASSUME_NONNULL_BEGIN

typedef void (^QNHeightScaleCallback)(BOOL success, NSError *__nullable error);

@protocol QNHeightScaleDelegate <NSObject>
@optional
/**
 发现设备

 @param device device
 */
- (void)discoverHeightScaleDevice:(QNHeightScaleDevice *)device;

/**
 实时体重
 
 @param weight 实时体重
 @param device 当前连接的秤
 */
- (void)heightScaleReceiveRealTimeWeight:(double)weight connectedDevice:(QNHeightScaleDevice *)device;

/**
 实时身高
 
 @param height 实时身高
 @param device 当前连接的秤
 */
- (void)heightScaleReceiveRealTimeHeight:(double)height connectedDevice:(QNHeightScaleDevice *)device;

/**
 测量数据(当次测量的结果)
 
 @param scaleData QNHeightScaleData
 @param device 当前连接的秤
 */
- (void)heightScaleReceiveResultData:(QNHeightScaleData *)scaleData connectedDevice:(QNHeightScaleDevice *)device;

/**
 测量数据(存储数据)
 
 @param storageScaleData QNHeightStorageScaleData
 @param device 当前连接的秤
 */
- (void)heightScaleReceiveStorageData:(QNHeightStorageScaleData *)storageScaleData connectedDevice:(QNHeightScaleDevice *)device;

/**
 秤端的交互状态
 
 @param scaleState 状态
 @param device 当前连接的秤
 */
- (void)heightScaleChangeToScaleState:(QNHeightScaleState)scaleState connectedDevice:(QNHeightScaleDevice *)device error:(nullable NSError *)error;

/**
 秤端软件版本
 
 @param scaleVersion 秤体端软件版本
 @param bleVersion 蓝牙端软件版本
 @param device 当前连接的秤
 */
- (void)heightScaleVersion:(NSUInteger)scaleVersion bleVersion:(NSUInteger)bleVersion connectedDevice:(QNHeightScaleDevice *)device;

@end

@interface QNHeightScaleManager : NSObject

@property (nonatomic, weak) id<QNHeightScaleDelegate> delegate;

/**
 公版协议管理类

 @return QNHeightScaleManager
 */
+ (QNHeightScaleManager *)sharedHeightScaleManager;

/**
 初始化方法

 @return QNHeightScaleManager
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 初始化QNHeightScaleManager

 @param centralManager QNCentralManager
 @return QNHeightScaleManager
 */
- (instancetype)initWithCentralManager:(QNCentralManager *)centralManager;

/**
 连接公版协议秤

 @param device 设备
 @param config 双模秤的wifi配置
 @param block 回调
 */
- (void)connectScaleDevice:(QNHeightScaleDevice *)device config:(QNWeightScaleConfig *)config response:(nullable QNHeightScaleCallback)block;

/**
 断开设备的连接
 */
- (void)cancelConnectScaleDevice;

@end

NS_ASSUME_NONNULL_END
