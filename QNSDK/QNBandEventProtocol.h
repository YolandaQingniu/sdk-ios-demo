//
//  QNBandEventProtocol.h
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2019/1/22.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "QNBleDevice.h"

@protocol QNBandEventListener <NSObject>
@optional
/**
 拍照回调

 @param device QNBleDevice
 */
- (void)strikeTakePhotosWithDevice:(QNBleDevice *)device;

/**
 查找手机回调

 @param device QNBleDevice
 */
- (void)strikeFindPhoneWithDevice:(QNBleDevice *)device;

@end
