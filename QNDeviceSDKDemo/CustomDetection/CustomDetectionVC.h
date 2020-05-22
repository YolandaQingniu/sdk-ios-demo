//
//  CustomDetectionVC.h
//  QNDeviceSDKDemo
//
//  Created by JuneLee on 2019/8/29.
//  Copyright © 2019 Yolanda. All rights reserved.
//  蓝牙自主管理demo

#import <UIKit/UIKit.h>
#import "QNDeviceSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomDetectionVC : UIViewController

@property (nonatomic, strong) QNUser *user;

@property (nonatomic, strong) QNConfig *config;

@end

NS_ASSUME_NONNULL_END
