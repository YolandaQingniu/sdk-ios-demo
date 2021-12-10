//
//  QNUserScaleDataProtocol.h
//  QNDeviceSDK
//
//  Created by sumeng on 2021/11/25.
//  Copyright © 2021 Yolanda. All rights reserved.
//

#import "QNScaleDataProtocol.h"
#import "QNBleDevice.h"
#import "QNUser.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QNUserScaleDataListener <QNScaleDataListener>

- (void)registerUserComplete:(QNBleDevice *)device user:(QNUser *)user;

@end

NS_ASSUME_NONNULL_END
