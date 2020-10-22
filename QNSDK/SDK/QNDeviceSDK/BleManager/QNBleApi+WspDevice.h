//
//  QNBleApi+WspDevice.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/2/26.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNBleApi+Addition.h"
#import "QNWspScaleModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBleApi (WspDevice)<QNWspScaleDelegate>
@property (nonatomic, strong) QNWspManager *wspManager;
@end

NS_ASSUME_NONNULL_END
