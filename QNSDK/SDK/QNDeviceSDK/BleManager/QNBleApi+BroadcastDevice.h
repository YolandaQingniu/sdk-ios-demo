//
//  QNBleApi+BroadcastDevice.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/2/26.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNBleApi+Addition.h"
#import "QNAdvertScaleModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBleApi (BroadcastDevice)<QNAdvertScaleDelegate>
/** 设备管理 */
@property (nonatomic, strong) QNAdvertScaleManager *advertManager;

@end

NS_ASSUME_NONNULL_END
