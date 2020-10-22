//
//  QNPScaleHelp.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/15.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "QNPScaleEnum.h"
#import "QNPUser.h"
#import "QNPScaleReplayData.h"
#import "QNPScaleConfig.h"
#import "QNPWifiConfig.h"

#define QNWriteModelMaxFailNumber 3

typedef NS_ENUM(NSUInteger, QNPScaleServerMode) {
    QNPScaleServerFFE0 = 0,
    QNPScaleServerFFF0 = 1,
};

#pragma mark 秤端支持的单位类型
typedef NS_ENUM(NSUInteger, QNPScaleSupportUnitMode) {
    QNBTScaleSupportUnitKGLB = 0,
    QNBTScaleSupportUnitKGLBJIN = 1,
    QNBTScaleSupportUnitKGLBJINST = 2,
};

#pragma mark 秤端精度
typedef NS_ENUM(NSUInteger, QNPScaleResolutionMode) {
    QNPScaleResolutionTwo = 0,
    QNPScaleResolutionOne = 1,
};

typedef NS_ENUM(NSUInteger, QNPScaleLowElectric) {
    QNPScaleLowElectricNone = 0,
    QNPScaleLowElectricYes,
    QNPScaleLowElectricNo,
};

NS_ASSUME_NONNULL_BEGIN

@interface QNPScaleHelp : NSObject
/** wifi配置信息 */
@property (nullable, nonatomic, strong) QNPWifiConfig *wifiConfig;
/** 配置信息 */
@property (nullable, nonatomic, strong) QNPScaleConfig *scaleConfig;
/** 服务类型 */
@property (nonatomic, assign) QNPScaleServerMode serverMode;
/** deviceType为FF的标记，却是否是新的型号写入方式 */
@property(nonatomic, assign) BOOL newProtocolFlag;
/** 写型号失败次数*/
@property(nonatomic, assign) int writeModelFailNum;
/** 存储数据 */
@property (nonatomic, assign) NSInteger storageNum;
/** indicate特征 */
@property (nullable, nonatomic, strong) CBCharacteristic *indicateCharacteristic;
/** 写特征 */
@property (nullable, nonatomic, strong) CBCharacteristic *writeCharacteristic;
/** 通知特征 */
@property (nullable, nonatomic, strong) CBCharacteristic *notifyCharacteristic;
/** 写特征 */
@property (nullable, nonatomic, strong) CBCharacteristic *storageWriteCharacteristic;
/** 写型号 */
@property (nullable, nonatomic, strong) CBCharacteristic *productWriteCharacteristic;
/** 电量特征 */
@property (nullable, nonatomic, strong) CBCharacteristic *batteryCharacteristic;
/** OTA特征 */
@property (nullable, nonatomic, strong) CBCharacteristic *otaCharacteristic;
/** 型号标识 */
@property (nonatomic, assign) Byte deviceByte;
/** 秤体端软件版本 */
@property (nonatomic, assign) NSUInteger scaleVer;
/** 蓝牙体端软件版本 */
@property (nonatomic, assign) NSUInteger bleVer;
/** macData(倒序) */
@property (nonatomic, strong) NSData *macData;
/** 相对2000年的时间戳 */
@property (nonatomic, assign) NSUInteger timeTemp;
/** 设备支持的单位 */
@property (nonatomic, assign) QNPScaleSupportUnitMode supportUnit;
/** 设备精度 */
@property (nonatomic, assign) QNPScaleResolutionMode resolution;
/** 低电量 */
@property (nonatomic, assign) QNPScaleLowElectric lowElectric;
/** 用户信息 */
@property (nullable, nonatomic, strong) QNPUser *scaleUser;
/** 测量时间 */
@property (nonatomic, assign) NSTimeInterval measureTimeTemp;
/** 是否已经更新设备信息 */
@property(nonatomic, assign) BOOL isHasUpdateDeviceMesgFlag;
/** 基准时间是否写入成功 */
@property(nonatomic, assign) BOOL writeBaseTimeStampFlag;
/** 收到第一条体重信息 */
@property (nonatomic, assign) BOOL receiveFistWeight;
/** 21命令发送次数 */
@property (nonatomic, assign) int timeCmdNum;
/** 是否收到阻抗 */
@property (nonatomic, assign) BOOL receiveResistance;
/** 是否测量完成 */
@property (nonatomic, assign) BOOL measureComplete;
/** 开始实时测量 */
@property (nonatomic, assign) BOOL realTime;
/** 是否已经回调体重数据 */
@property (nonatomic, assign) BOOL weightCallback;
/** 心率秤回复的数据 */
@property (nullable, nonatomic, strong) QNPScaleReplayData *replayData;
/** 是否已经解析设备的类型 */
@property (nonatomic, getter=isConfirmDeviceMode, assign) BOOL confirmDeviceMode;
/** 是否收到电量 */
@property (nonatomic, getter=isReceiveElectric, assign) BOOL receiveElectricFlag;

//wifi配网字段
@property(nonatomic, assign) int packageNum;
@property(nonatomic, assign) int curPackageNum;
@property(nonatomic, assign) int repeatNum;
@property(nullable, nonatomic, strong) NSTimer *wifiTimer;

//ota升级
@property(nonatomic, strong) NSData *otaDataPack;
@property(nonatomic, assign) NSUInteger otaPackCount;
@property(nonatomic, assign) NSUInteger otaPackIndex;
@property(nullable, nonatomic, strong) NSTimer *otaTimer;


//启动计时器监测是否开始测量阻抗
- (void)startTimerForMeasureResistanceStateHanle:(void (^)(void))block;
//取消定时器
- (void)cancelMeasureResistanceTimer;

//写入型号定时器
- (void)startSetProductInternalModelTimer:(void (^)(void))block;
//取消定时器
- (void)cancelWriteInternalTimer;

//交互的定时器
- (void)startInteractiveTimer:(void (^)(void))block;
//取消定时器
- (void)cancelInteractiveTimer;

//21命令定时器
- (void)starCurTimeCmdTimer:(void (^)(void))block;
//取消定时器
- (void)cancelCurTimeCmdTimer;
@end

NS_ASSUME_NONNULL_END
