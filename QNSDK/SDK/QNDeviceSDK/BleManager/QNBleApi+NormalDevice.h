//
//  QNBleApi+NormalDevice.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/2/26.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNBleApi+Addition.h"
#import "QNPScaleModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBleApi (NormalDevice)<QNPScaleDelegate>
/** 设备管理 */
@property (nonatomic, strong) QNPScaleManager *scaleManager;

@end

NS_ASSUME_NONNULL_END
