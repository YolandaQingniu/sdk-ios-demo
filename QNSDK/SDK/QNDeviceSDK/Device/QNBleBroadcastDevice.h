//
//  QNBleBroadcastDevice.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/7/11.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "QNUser.h"
#import "QNConfig.h"
#import "QNScaleData.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBleBroadcastDevice : NSObject

/** mac地址 */
@property (nonatomic, readonly, strong) NSString *mac;
/** 设备名称 */
@property (nonatomic, readonly, strong) NSString *name;
/** 型号标识 */
@property (nonatomic, readonly, strong) NSString *modeId;
/** 蓝牙名称 */
@property (nonatomic, readonly, strong) NSString *bluetoothName;
/** 信号强度 */
@property (nonatomic, readonly, strong) NSNumber *RSSI;
/** 是否支持通过协议方式修改单位 */
@property(nonatomic, readonly, assign) BOOL supportUnitChange;
/** 秤体当前显示的单位 */
@property(nonatomic, readonly, assign) QNUnit unit;
/** 当前体重 */
@property(nonatomic, readonly, assign) double weight;
/** 是否完成测量 */
@property(nonatomic, readonly, assign) BOOL isComplete;
/** 完成测量时的数据编码 */
@property(nonatomic, readonly, assign) int measureCode;

- (QNScaleData *)generateScaleDataWithUser:(QNUser *)user callback:(QNResultCallback)callback;

- (void)syncUnitCallback:(QNResultCallback)callback;

@end

NS_ASSUME_NONNULL_END
