//
//  CustomBleManagerVC.h
//  QNDeviceSDKDemo
//
//  Created by qiudongquan on 2020/10/21.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNDeviceSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomBleManagerVC : UIViewController

@property (nonatomic, strong) QNUser *user;

@property (nonatomic, strong) QNConfig *config;

@end

NS_ASSUME_NONNULL_END
