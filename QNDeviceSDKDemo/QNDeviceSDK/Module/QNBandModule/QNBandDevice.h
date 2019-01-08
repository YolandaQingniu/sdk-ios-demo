//
//  QNBandDevice.h
//  QNBandModule_iOS
//
//  Created by donyau on 2018/9/30.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNBandEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBandDevice : NSObject

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

@end

NS_ASSUME_NONNULL_END
