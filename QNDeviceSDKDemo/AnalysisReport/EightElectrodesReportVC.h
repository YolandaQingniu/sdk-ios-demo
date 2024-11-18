//
//  EightElectrodesReportVC.h
//  QNDeviceSDKDemo
//
//  Created by sumeng on 2021/7/6.
//  Copyright © 2021 Yolanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QNDeviceSDK/QNUser.h>
#import <QNDeviceSDK/QNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface EightElectrodesReportVC : UIViewController

@property (nonatomic, strong) QNUser *user;

@property (nonatomic, strong) QNConfig *config;

@property (nonatomic, strong) NSMutableArray *scaleDataAry;
@end

NS_ASSUME_NONNULL_END
