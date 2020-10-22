//
//  QNDeviceTool.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/2/26.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNAuthInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNDeviceTool : NSObject

+ (nullable QNAuthDevice *)getDeviceInfoWithInternalModel:(NSString *)internalModel;

+ (QNAuthDevice *)getShareDeviceInfo;

@end

NS_ASSUME_NONNULL_END
