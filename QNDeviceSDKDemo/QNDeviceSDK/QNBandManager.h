//
//  QNBandManager.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/12/29.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNBandEventProtocol.h"
#import "QNCallBackConst.h"
#import "QNBandInfo.h"
#import "QNAlarm.h"
#import "QNSitRemind.h"
#import "QNThirdRemind.h"
#import "QNCleanInfo.h"
#import "QNBandBaseConfig.h"
#import "QNHealthData.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBandManager : NSObject

/** EventProtocol */
@property (nonatomic, strong) id<QNBandEventListener> bandEventListener;

- (instancetype)init NS_UNAVAILABLE;

/**
 绑定设备
 
 @param callblock 结果的回调
 */
- (void)bindBandCallback:(QNResultCallback)callblock;

/**
 设备解绑时，需要调用该方法

 @param callblock 结果的回调
 */
- (void)cancelBindCallback:(QNResultCallback)callblock;

/**
 检测手环的上次

 @param callblock 结果的回调 void(^QNObjCallback) (NSNumber *same, NSError *error)
 */
- (void)checkSameBindPhone:(QNObjCallback)callblock;

/**
 手环的固件版本、软件版本、电量

 @param callblock 结果的回调 void(^QNObjCallback) (QNBandInfo *info, NSError *error)
 */
- (void)fetchBandInfo:(QNObjCallback)callblock;

/**
 设置手环时间

 @param date 时间
 @param callblock 结果的回调
 */
- (void)syncBandTimeWithDate:(NSDate *)date callback:(QNResultCallback)callblock;

/**
 设置闹钟详情
 
 目前最多支持10个闹钟

 @param alarm QNAlarm
 @param callblock 结果的回调
 */
- (void)syncAlarm:(QNAlarm *)alarm callback:(QNResultCallback)callblock;

/**
 运动目标

 @param stepGoal 运动目标
 @param callblock 结果的回调
 */
- (void)syncGoal:(int)stepGoal callback:(QNResultCallback)callblock;

/**
 用户信息

 @param user QNUser
 @param callblock 结果的回调
 */
- (void)syncUser:(QNUser *)user callback:(QNResultCallback)callblock;

/**
 设置单位、语言、时间制式

 @param metrics QNBandMetrics
 @param callblock 结果的回调
 */
- (void)syncMetrics:(QNBandMetrics *)metrics callback:(QNResultCallback)callblock;

/**
 久坐提醒

 @param sitRemind QNSitRemind
 @param callblock 结果的回调
 */
- (void)syncSitRemind:(QNSitRemind *)sitRemind callback:(QNResultCallback)callblock;

/**
 心率的监听模式

 @param autoFlag YES 自动 NO 手动
 @param callblock 结果的回调
 */
- (void)syncHeartRateObserverModeWithAutoFlag:(BOOL)autoFlag callback:(QNResultCallback)callblock;


/**
 查找手机开关

 @param openFlag YES 开启 NO 关闭
 @param callblock 结果的回调
 */
- (void)syncFindPhoneWithOpenFlag:(BOOL)openFlag callback:(QNResultCallback)callblock;

/**
 相机模式

 @param openFlag YES 进入拍照模式 NO 退出拍照模式
 @param callblock 结果的回调
 */
- (void)syncCameraModeWithEnterFlag:(BOOL)openFlag callback:(QNResultCallback)callblock;

/**
 抬腕识别模式

 @param openFlag YES 开启抬腕亮屏 NO 关闭抬腕亮屏
 @param callblock 结果的回调
 */
- (void)syncHandRecognizeModeWithOpenFlag:(BOOL)openFlag callback:(QNResultCallback)callblock;

/**
 第三方提醒

 @param thirdRemind 第三方提醒
 @param callblock 结果的回调
 */
- (void)setThirdRemind:(QNThirdRemind *)thirdRemind callback:(QNResultCallback)callblock;

/**
 清除设置

 @param cleanInfo QNCleanInfo
 @param callblock 结果的回调
 */
- (void)resetWithCleanInfo:(QNCleanInfo *)cleanInfo callback:(QNResultCallback)callblock;


/**
 恢复出厂设置
 
 回复出厂设置后，手环会自动重启

 @param callblock 结果的回调
 */
- (void)rebootCallback:(QNResultCallback)callblock;

/**
 快捷设置
 
 仅支持ID为0003且版本号12后续版本(包含12版本)

 @param baseConifg QNBandBaseConfig
 @param callblock 结果的回调
 */
- (void)syncFastSetting:(QNBandBaseConfig *)baseConifg callback:(QNResultCallback)callblock;


/**
 同步今日数据

 @param callblock 结果的回调 void(^QNObjCallback) (QNHealthData *healthData, NSError *error)
 */
- (void)syncTodayHealthDataCallback:(QNObjCallback)callblock;

/**
 同步历史数据
 
 @param callblock 结果的回调 void(^QNObjCallback) (NSArray<QNHealthData *> *healthData, NSError *error)
 */
- (void)syncHistoryHealthDataCallback:(QNObjCallback)callblock;

@end

NS_ASSUME_NONNULL_END
