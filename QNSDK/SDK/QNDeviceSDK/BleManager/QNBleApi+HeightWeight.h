//
//  QNBleApi+HeightWeight.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/6/12.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNBleApi+Addition.h"
#import "QNHeightScaleModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBleApi (HeightWeight)<QNHeightScaleDelegate>
/** 设备管理 */
@property (nonatomic, strong) QNHeightScaleManager *heightScaleManager;
@end

NS_ASSUME_NONNULL_END
