//
//  QNHeightDeviceFunction.h
//  QNDeviceSDK
//
//  Created by yolanda on 2025/10/13.
//  Copyright © 2025 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface QNHeightDeviceFunction : NSObject
@property (nonatomic, assign) QNUnit weightUnit; //体重单位
@property (nonatomic, assign) QNHeightUnit heightUnit; //身高单位
@property (nonatomic, assign) QNLanguage voiceLanguage; //语音播报语种
@property (nonatomic, assign) QNVolume volume; //音量
@end

NS_ASSUME_NONNULL_END
