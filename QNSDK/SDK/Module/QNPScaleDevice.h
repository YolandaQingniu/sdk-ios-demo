//
//  QNPScaleDevice.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/15.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNPScaleEnum.h"
#import "QNPScaleHelp.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNPScaleDevice : NSObject

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
/** 是否亮屏 */
@property (nonatomic, readonly, assign) QNDeviceScreenState screenState;
/** 是否是双模设备 */
@property (nonatomic, readonly, assign) BOOL doubleModuleFlag;
/** 设备帮助类 */
@property (nonatomic, strong) QNPScaleHelp *scaleHelp;
/** 外设设备 */
@property (nonatomic, strong) CBPeripheral *peripheral;
@end

@interface QNPScaleDevice (Addition)
/** 存储数据(一般不作为依据) */
@property (nonatomic, readonly, assign) NSUInteger storage;
/** 是否支持心率(连上设备后，该属性才有效) */
@property (nonatomic, readonly, assign) BOOL supportHeartRateFlag;
/** 是否支持充电(连上设备后，该属性才有效) */
@property (nonatomic, readonly, assign) BOOL supportChargeFlag;
/** 是否支持用户ID(连上设备后，该属性才有效) */
@property (nonatomic, readonly, assign) BOOL supportUserFlag;
/** 是否正在充电(连上设备后，该属性才有效) */
@property (nonatomic, readonly, assign) BOOL chargingFlag;
/** 是否支持左右平衡(连上设备后，该属性才有效) */
@property (nonatomic, readonly, assign) BOOL supportBalanceFlag;
@end

NS_ASSUME_NONNULL_END
