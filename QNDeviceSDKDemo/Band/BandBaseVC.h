//
//  BandBaseVC.h
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/8.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BandBaseVC : UIViewController

- (void)onDeviceStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state;

@end

NS_ASSUME_NONNULL_END
