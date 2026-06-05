//
//  QNHeightDeviceConfig.h
//  QNDeviceSDK
//
//  Created by yolanda on 2025/8/28.
//  Copyright © 2025 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNWiFiConfig.h"
#import "QNUser.h"
NS_ASSUME_NONNULL_BEGIN

@interface QNHeightDeviceConfig : NSObject
/// wifi配置对象
@property (nullable, nonatomic, strong) QNWiFiConfig *wifiConfig;

/// 当前测量用户
@property (nullable, nonatomic, strong) QNUser *curUser;

@property (nonatomic, assign) QNUnit weightUnit; //体重单位
@property (nonatomic, assign) QNHeightUnit heightUnit; //身高单位
@property (nonatomic, assign) QNLanguage voiceLanguage; //语音播报语种

@end

NS_ASSUME_NONNULL_END
