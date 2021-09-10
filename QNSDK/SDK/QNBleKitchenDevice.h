//
//  QNBleKitchenDevice.h
//  QNDeviceSDK
//
//  Created by com.qn.device on 2019/10/22.
//  Copyright © 2019 com.qn.device. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBleKitchenDevice : NSObject
/** mac地址 */
@property (nonatomic, readonly, strong) NSString *mac;
/** name */
@property (nonatomic, readonly, strong) NSString *name;
/** modeId */
@property (nonatomic, readonly, strong) NSString *modeId;
/** 信号强度 */
@property (nonatomic, readonly, strong) NSNumber *RSSI;
/** 秤体当前显示的单位（G、ml、oz、lb:oz） */
@property(nonatomic, readonly, assign) QNUnit unit;
/** 当前重量，单位g */
@property(nonatomic, readonly, assign) double weight;
/** 是否已经去皮 */
@property(nonatomic, readonly, assign) BOOL isPeel;
/** 是否负重量 */
@property(nonatomic, readonly, assign) BOOL isNegative;
/** 是否超载 */
@property(nonatomic, readonly, assign) BOOL isOverload;
/** 是否是蓝牙厨房秤 */
@property(nonatomic, readonly, assign) BOOL isBluetooth;
/** 测量重量是否稳定, 针对蓝牙厨房秤有效 */
@property(nonatomic, readonly, assign) BOOL isStable;
/** 蓝牙名称, 针对蓝牙厨房秤有效 */
@property (nonatomic, readonly, strong) NSString *bluetoothName;

@end

NS_ASSUME_NONNULL_END
