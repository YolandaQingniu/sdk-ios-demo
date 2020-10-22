//
//  QNWspDevice.h
//  QNWspScaleModule
//
//  Created by donyau on 2019/7/27.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNWspDevice : NSObject
/** 蓝牙名称 */
@property (nonatomic, readonly, strong, nonnull) NSString *bluetoothName;
/** mac地址 */
@property (nonatomic, readonly, strong, nonnull) NSString *mac;
/** 信号强度 */
@property (nonatomic, readonly, strong, nonnull) NSNumber *RSSI;
/** 内部型号 */
@property (nonatomic, readonly, strong, nonnull) NSString *internalModel;
/** 设备UUID */
@property (nonatomic, readonly, strong) NSString *UUIDIdentifier;
/** 总用户数据 */
@property (nonatomic, readonly, assign) NSUInteger allowMaxUserNum;
/** 已访问用户数 */
@property (nonatomic, readonly, assign) NSUInteger registerUserNum;
/** 存储数据 */
@property (nonatomic, readonly, assign) NSUInteger storageNum;
/** 固件版本 */
@property (nonatomic, readonly, assign) NSUInteger firmwareVer;
/** 秤端版本 */
@property (nonatomic, readonly, assign) NSUInteger scaleVer;
/** 硬件版本 */
@property (nonatomic, readonly, assign) NSUInteger hardwareVer;
/** 是否支持心率 */
@property (nonatomic, readonly, assign) BOOL supportHeartRateFlag;
/** 是否支持充电 */
@property (nonatomic, readonly, assign) BOOL supportChargeFlag;
/** 是否是加密阻抗设备 */
@property (nonatomic, readonly, assign) BOOL isEncryFlag;
/** 是否支持更新体重 */
@property (nonatomic, readonly, assign) BOOL isUpdateWeight;
/** 是否支持昵称、定位、指标控制 */
@property (nonatomic, readonly, assign) BOOL isBow;
/** 是否是八电极 */
@property (nonatomic, readonly, assign) BOOL isEightElec;
@end

NS_ASSUME_NONNULL_END
