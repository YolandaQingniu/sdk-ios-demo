//
//  HeightSetFunctionVC.h
//  QNDeviceSDKDemo
//
//  Created by yolanda on 2025/9/8.
//  Copyright © 2025 Yolanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNDeviceSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface HeightSetFunctionVC : UIViewController
@property (nonatomic, strong) QNBleDevice *connectedDevice;
@property (nonatomic, strong) QNWiFiConfig *wifiConfig;

@end

NS_ASSUME_NONNULL_END
