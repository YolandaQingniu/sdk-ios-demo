//
//  WspConfigVC.h
//  QNDeviceSDKDemo
//
//  Created by qiudongquan on 2020/3/10.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNDeviceSDK.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WspConfigVCDelegate <NSObject>

- (void)selectWspConfig:(QNWspConfig *)wspConfig userIndex:(int)userIndex userSecret:(int)userSecret device:(QNBleDevice *)device;
- (void)dismissWspConfigVC;
@end

@interface WspConfigVC : UIViewController
@property(nonatomic, weak) id<WspConfigVCDelegate> delegate;

@property(nonatomic, strong) QNBleDevice *bleDevice;

@end

NS_ASSUME_NONNULL_END
