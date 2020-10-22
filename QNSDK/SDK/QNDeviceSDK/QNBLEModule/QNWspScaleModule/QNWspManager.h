//
//  QNWspManager.h
//  Pods
//
//  Created by donyau on 2019/7/26.
//  4.7.0

#import <Foundation/Foundation.h>
#import "QNWspDevice.h"
#import "QNWspUser.h"
#import "QNWspScaleData.h"
#import "QNWspEnum.h"
#import "QNWspDeploy.h"
#import "QNWspWiFi.h"

@class QNCentralManager;
@class QNConnectConfig;

NS_ASSUME_NONNULL_BEGIN

typedef void(^QNWspResponseCallback)(BOOL success, NSError *__nullable err);

@protocol QNWspScaleDelegate <NSObject>
/**
 发现设备
 
 @param device device
 */
- (void)discoverWSPScaleDevice:(QNWspDevice *)device;


/**
收到sn码

@param sn sn码
@param device 当前连接的秤
*/
- (void)receiveWspSn:(NSString *)sn connectedDevice:(QNWspDevice *)device;

/**
 实时体重
 
 @param weight 实时体重
 @param device 当前连接的秤
 */
- (void)wspScaleReceiveRealTimeWeight:(double)weight connectedDevice:(QNWspDevice *)device;

/**
体重测量完成

@param weight 体重
@param device 当前连接的秤
*/
- (void)wspScaleReceiveWeightCompleteData:(double)weight connectedDevice:(QNWspDevice *)device;

/**
 测量数据(当次测量的结果)
 
 @param scaleData QNWspScaleData
 @param device 当前连接的秤
 */
- (void)wspScaleReceiveResultData:(QNWspScaleData *)scaleData connectedDevice:(QNWspDevice *)device;

/**
 测量数据(存储数据)
 
 @param storageData QNWspScaleData
 @param device 当前连接的秤
 */
- (void)wspScaleReceiveStorageData:(QNWspScaleData *)storageData connectedDevice:(QNWspDevice *)device;

/**
 秤端的交互状态
 
 @param scaleState 状态
 @param user 用户信息（注册访问删除等操作有回调）
 @param device 当前连接的设备
 @param errCode 错误码(根据蓝牙排查错误码规则返回)
 @param error 错误信息
 */

- (void)wspScaleChangeToScaleState:(QNWspScaleState)scaleState user:(nullable QNWspUser *)user connectedDevice:(QNWspDevice *)device errCode:(NSInteger)errCode error:(nullable NSError *)error;


@end

@interface QNWspManager : NSObject

@property (nullable, nonatomic, weak) id<QNWspScaleDelegate> delegate;


/**
 wsp协议管理类
 
 @return QNWspManager
 */
+ (QNWspManager *)sharedWspManager;

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
 @param configCallback 相关设置
 @param responseCallback 方法调用结果
 */
- (void)connectWspDevice:(QNWspDevice *)device config:(void (^)(QNWspDeploy *config))configCallback response:(nullable QNWspResponseCallback)responseCallback;

/**
 断开设备的连接
 */
- (void)cancelConnectScaleDevice;

/**
 设置秤的单位
 
 @param unitMode 单位
 */
- (void)setScaleUnit:(QNWspDeviceUnit)unitMode response:(nullable QNWspResponseCallback)block;

/**
 启动配网
 
 @param wifiConfig QNWspWifi
 @param callback 方法调用结果
 */
- (void)setUpNetworkToScaleWithConifg:(nullable QNWspWiFi *)wifiConfig response:(nullable QNWspResponseCallback)callback;

/// 延长设备使用时间
- (void)delayScaleUserTime;

/// 更新当前访问用户的体重信息
/// @param secretIndex 坑位
/// @param weight 体重
- (void)updateWeightInfoWithUserSecretIndex:(NSInteger)secretIndex weight:(double)weight;

@end

NS_ASSUME_NONNULL_END
