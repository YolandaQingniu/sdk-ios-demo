//
//  QNAdvertScaleManager.h
//  Pods
//
//  Created by donyau on 2018/12/24.
//  4.7.0

#import <Foundation/Foundation.h>
#import "QNAdvertScaleDevice.h"
#import "QNAdvertScaleData.h"
#import "QNAdvertScaleEnum.h"
#import <CoreBluetooth/CoreBluetooth.h>

@class QNCentralManager;

NS_ASSUME_NONNULL_BEGIN

typedef void (^QNAdvertScaleResponseBlock)(BOOL success, NSError *__nullable error);

@protocol QNAdvertScaleDelegate <NSObject>
@optional
/**
 发现设备
 
 @param device device
 */
- (void)discoverAdvertScaleDevice:(QNAdvertScaleDevice *)device;

/**
 发现厨房秤设备
 
 @param device device
 */
- (void)discoverKitchenScaleDevice:(QNAdvertScaleDevice *)device;

/**
 一对一厨房秤设备测量回调
 
 @param device device
 */
- (void)kitchenScaleRealTimeData:(QNAdvertScaleDevice *)device;

/**
 实时体重
 
 @param weight 实时体重
 @param device 当前连接的秤
 */
- (void)advertScaleReceiveRealTimeWeight:(double)weight connectedDevice:(QNAdvertScaleDevice *)device;

/**
 测量数据(当次测量的结果)
 
 @param scaleData QNPScaleData
 @param device 当前连接的秤
 */
- (void)advertScaleReceiveResultData:(QNAdvertScaleData *)scaleData connectedDevice:(QNAdvertScaleDevice *)device;

/**
体重测量完成

@param weight 体重
@param device 当前连接的秤
*/
- (void)advertScaleReceiveWeightCompleteData:(double)weight connectedDevice:(QNAdvertScaleDevice *)device;

/**
 测量数据(存储数据)
 
 @param storageScaleDatas [QNAdvertScaleData]
 @param device 当前连接的秤
 */
- (void)advertScaleReceiveStorageDatas:(NSArray<QNAdvertScaleData *> *)storageScaleDatas connectedDevice:(QNAdvertScaleDevice *)device;


/**
 秤端软件版本
 
 @param scaleVersion 秤体端软件版本
 @param bleVersion 蓝牙端软件版本
 @param device 当前连接的秤
 */
- (void)advertScaleVersion:(NSUInteger)scaleVersion bleVersion:(NSUInteger)bleVersion connectedDevice:(QNAdvertScaleDevice *)device;

/**
 秤端的交互状态
 
 @param scaleState 状态
 @param device 当前连接的秤
 */
- (void)advertScaleChangeToScaleState:(QNAdvertScaleState)scaleState connectedDevice:(QNAdvertScaleDevice *)device error:(nullable NSError *)error;

@end


@interface QNAdvertScaleManager : NSObject

@property (nonatomic, weak) id<QNAdvertScaleDelegate> delegate;
/** 当前状态(QNAdvertScaleStateUnknow、QNAdvertScaleStateConnected) */
@property (nonatomic, assign) QNAdvertScaleState scaleState;


/**
 初始化广播秤管理类
 
 @return QNAdvertScaleManager
 */
+ (QNAdvertScaleManager *)sharedAdvertScaleManager;


/**
 初始化方法
 
 @return QNAdvertScaleManager
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 初始化
 
 @param centralManager QNCentralManager
 @return QNAdvertScaleManager
 */
- (instancetype)initWithCentralManager:(QNCentralManager *)centralManager;

/**
 连接广播秤(厨房秤除外)
 
 @param device 设备
 @param block 回调
 */
- (void)connectScaleDevice:(QNAdvertScaleDevice *)device config:(void (^)(QNAdvertScaleUnitMode *unitMode))config response:(nullable QNAdvertScaleResponseBlock)block;

/**
 断开设备的连接
 */
- (void)cancelConnectScaleDevice;

/**
 开始发送增强广播
 */
- (void)beginEnhanceBroadcast;

/**
 结束发送增强广播
 */
- (void)endEnhanceBroadcaset;

/**
 设置秤的单位
 
 @param unitMode 单位
 @param device 需要改变的设备对象
 @param block 成功或者失败的回调
 */
- (void)setScaleUnit:(QNAdvertScaleUnitMode)unitMode device:(QNAdvertScaleDevice *)device response:(nullable QNAdvertScaleResponseBlock)block;

/**
 设置秤的单位(已经连接的设备，该方法需要配合【connectScaleDevice:config:response:】方法使用)
 
 @param unitMode 单位
 @param block 成功或者失败的回调
 */
- (void)setScaleUnit:(QNAdvertScaleUnitMode)unitMode response:(nullable QNAdvertScaleResponseBlock)block;

/**
 解析广播秤数据
 
 @param advertisementData 广播信号
 @param peripheral 外设信息
 @param RSSI 信号强度
 */
- (nullable QNAdvertScaleDevice *)analysisBroadcastDeviceAdvertisementData:(NSDictionary<NSString *,id> *)advertisementData peripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI;

@end

NS_ASSUME_NONNULL_END
