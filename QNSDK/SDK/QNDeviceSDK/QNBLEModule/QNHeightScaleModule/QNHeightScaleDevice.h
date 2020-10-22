//
//  QNHeightScaleDevice.h
//  Pods
//
//  Created by qiudongquan on 2020/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNHeightScaleDevice : NSObject
/** 蓝牙名称 */
@property (nonatomic, strong, nonnull) NSString *bluetoothName;
/** mac地址 */
@property (nonatomic, strong, nonnull) NSString *mac;
/** 信号强度 */
@property (nonatomic, strong, nonnull) NSNumber *RSSI;
/** 内部型号 */
@property (nonatomic, strong, nonnull) NSString *internalModel;
/** sn码 */
@property (nonatomic, strong, nonnull) NSString *sn;
/** 设备UUID */
@property (nonatomic, strong) NSString *UUIDIdentifier;
/** 是否支持wifi */
@property (nonatomic, assign) BOOL isSupportWifi;
@end

NS_ASSUME_NONNULL_END
