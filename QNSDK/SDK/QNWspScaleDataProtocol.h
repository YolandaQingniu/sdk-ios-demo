//
//  QNWspScaleDataProtocol.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/3/6.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNScaleDataProtocol.h"
#import "QNBleDevice.h"
#import "QNUser.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QNWspScaleDataListener <QNScaleDataListener>

- (void)wspRegisterUserComplete:(QNBleDevice *)device user:(QNUser *)user;

@end

NS_ASSUME_NONNULL_END
