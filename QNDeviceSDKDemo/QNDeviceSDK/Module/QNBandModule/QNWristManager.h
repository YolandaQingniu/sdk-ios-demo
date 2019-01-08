//
//  QNWristManager.h
//  QNBandModule_iOS
//
//  Created by donyau on 2018/9/30.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNBandDevice.h"
#import "QNBandBlock.h"
#import "QNBandAlarm.h"
#import "QNBandUser.h"
#import "QNBandSitRemind.h"
#import "QNBandThirdRemind.h"
#import "QNBandClear.h"
#import "QNBandShortcutInfo.h"

@class QNCentralManager;
@class QNConnectConfig;

NS_ASSUME_NONNULL_BEGIN
@protocol QNBandDelegate <NSObject>
@optional
/**
 发现设备
 
 @param device device
 */
- (void)discoverBandDevice:(QNBandDevice *)device;

/**
 手环端的交互状态
 
 @param bandState 状态
 @param device 当前连接的手环
 */
- (void)bandDevice:(QNBandDevice *)device changeToBandState:(QNBandState)bandState error:(nullable NSError *)error;

/**
 执行拍照操作
 
 @param device device
 */
- (void)triggerCarmen:(QNBandDevice *)device;

/**
 手环触发查找手机

 @param device QNBandDevice
 */
- (void)triggerFindPhone:(QNBandDevice *)device;

/**
 用户配对的弹框的操作
 
 @param device QNBandDevice
 */
- (void)userPairOperationState:(BOOL)pair device:(QNBandDevice *)device;

@end

@interface QNWristManager : NSObject
/** log前缀*/
@property (nonatomic, assign, class) BOOL logPrefix;

@property (nonatomic, weak) id<QNBandDelegate> delegate;

/** 当前状态(QNBandStateUnknow、QNBandStateConnecting、QNBandStateConnected) */
@property (nonatomic, assign, readonly) QNBandState bandState;

/**
 初始化手环协议管理类
 
 @return QNPScaleManager
 */
+ (QNWristManager *)sharedBandManager;


/**
 初始化方法

 @return QNPScaleManager
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 初始化

 @param centralManager QNCentralManager
 @return QNWristManager
 */
- (instancetype)initWithCentralManager:(QNCentralManager *)centralManager;

/**
 连接手环

 @param device QNBandDevice
 @param configBlock 连接设置
 @param block 状态回调
 */
- (void)connectBandDevice:(QNBandDevice *)device configBlock:(void (^)(QNConnectConfig *config))configBlock response:(nullable QNBandResponseBlock)block;

/**
 查找系统已经配对的设备

 @param mac mac地址
 @param internalModel 内部型号
 @param uuidIdentifier UUID
 @param block block
 */
- (void)findSystemPairBandDeviceWithMac:(NSString *)mac internalModel:(NSString *)internalModel uuidIdentifier:(NSString *)uuidIdentifier Response:(nullable QNBandResponseBlock)block;

/**
 断开设备的连接
 */
- (void)cancelConnectBandDevice;

/**
 解绑手环

 @param block QNBandResponseBlock
 */
- (void)cancelBindBandResponse:(QNBandResponseBlock)block;

/**
 检测与上次绑定是否同一台手机

 @param block QNBandSamePhoneBindBlock
 */
- (void)checkoutSamePhoneBindResponse:(QNBandSamePhoneBindBlock)block;

/**
 获取设备信息(固件版本、软件版本、电量)

 @param block QNBandVersionAndBatteryBlock
 */
- (void)deviceInfoResponse:(QNBandVersionAndBatteryBlock)block;

/**
 获取mac地址

 @param block QNBandMacBlock
 */
- (void)macResponse:(QNBandMacBlock)block;

/**
 设置手环的时间

 @param timeStamp 时间戳
 @param block QNBandResponseBlock
 */
- (void)updateTimeToBandWithTimeStamp:(NSTimeInterval)timeStamp response:(QNBandResponseBlock)block;

/**
 设置闹钟

 @param alarm QNBandAlarm
 @param block QNBandResponseBlock
 */
- (void)updateAlarm:(QNBandAlarm *)alarm response:(QNBandResponseBlock)block;

/**
 设置目标

 @param sportGoal 运功目标
 @param sleepGoal 睡眠目标
 @param block QNBandResponseBlock
 */
- (void)updateSportGoal:(NSUInteger)sportGoal sleepGoal:(NSUInteger)sleepGoal response:(QNBandResponseBlock)block;

/**
 更新用户信息

 @param user QNBandUser
 @param block QNBandResponseBlock
 */
- (void)updateUser:(QNBandUser *)user response:(QNBandResponseBlock)block;

/**
 更新单位

 @param unit 长度单位
 @param language 语言类型
 @param hourFormat 小时制
 @param block QNBandResponseBlock
 */
- (void)updateUnit:(QNBandUnitStype)unit language:(QNBandLanguageStype)language hourFormat:(QNBandHourFormat)hourFormat response:(QNBandResponseBlock)block;

/**
 更新久坐提醒

 @param sitRemind QNBandSitRemind
 @param block QNBandResponseBlock
 */
- (void)updateSitRemind:(QNBandSitRemind *)sitRemind response:(QNBandResponseBlock)block;

/**
 更新防丢提醒设置

 @param open 开关
 @param block QNBandResponseBlock
 */
- (void)updateLossRemind:(BOOL)open response:(QNBandResponseBlock)block;

/**
 更新最大心率

 @param maxHeartRate 最大心率
 @param block QNBandResponseBlock
 */
- (void)updateMaxHeartRate:(NSUInteger)maxHeartRate response:(QNBandResponseBlock)block;

/**
 更新自动监听心率开关

 @param autoFlag 开关
 @param block QNBandResponseBlock
 */
- (void)updateAutoHeartRateObserverState:(BOOL)autoFlag response:(QNBandResponseBlock)block;

/**
 更新查找手机的开关

 @param open 开关
 @param block QNBandResponseBlock
 */
- (void)updateFindPhoneState:(BOOL)open response:(QNBandResponseBlock)block;

/**
 更新抬腕亮屏的开关

 @param open 开关
 @param block QNBandResponseBlock
 */
- (void)updateHandRecognizeState:(BOOL)open response:(QNBandResponseBlock)block;

/**
 更新第三方提醒

 @param thirdRemind QNBandThirdRemind
 @param block QNBandResponseBlock
 */
- (void)updateThirdRemind:(QNBandThirdRemind *)thirdRemind response:(QNBandResponseBlock)block;

/**
 快捷设置手环
 
 0001 0002 不支持
 0003 12版本开始支持
 0004 所有版本都支持
 
 @param config QNEasyConfig
 @param block QNBandResponseBlock
 */
- (void)convenienceBandConfig:(QNBandShortcutInfo *)config response:(QNBandResponseBlock)block;

/**
 更新拍照状态

 @param open 开关
 @param block QNBandResponseBlock
 */
- (void)updateTakePhotoState:(BOOL)open response:(QNBandResponseBlock)block;

/**
 清除手环设置

 @param clear QNBandClear
 @param block QNBandResponseBlock
 */
- (void)clearBandConfig:(QNBandClear *)clear response:(QNBandResponseBlock)block;

/**
 重启设备

 @param block QNBandResponseBlock
 */
- (void)restartBandResponse:(QNBandResponseBlock)block;

/**
 实时数据

 @param block block
 */
- (void)realTimeDataResponse:(QNBandRealTimeDataBlock)block;

/**
 同步今日测量数据

 @param todayDataBlock QNBandTodayDataBlock
 */
- (void)synTodayHealthData:(QNBandTodayDataBlock)todayDataBlock;

/**
 同步历史测量数据

 @param historyDataBlock QNBandHistoryDataBlock
 */
- (void)synHistoryHealthData:(QNBandHistoryDataBlock)historyDataBlock;


/**
 启动OTA升级

 @param block QNBandResponseBlock
 */
- (void)startOTAProgressResponse:(QNBandResponseBlock)block;

@end

NS_ASSUME_NONNULL_END
