//
//  QNDeviceTool.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/2/26.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNDeviceTool.h"

@implementation QNDeviceTool

+ (QNAuthDevice *)getDeviceInfoWithInternalModel:(NSString *)internalModel {
    QNAuthInfo *authInfo = [QNAuthInfo sharedAuthInfo];
    QNAuthDevice *device = nil;
    for (QNAuthDevice *item in authInfo.authDevices) {
        if ([internalModel isEqualToString:item.internalModel]) {
            device = item;
            break;
        }
    }
    
    if (device == nil && authInfo.connectOtherFlag) {
        device = [[QNAuthDevice alloc] init];
        device.model = authInfo.defaultModel;
        device.method = authInfo.defaultMethod;
        device.internalModel = internalModel;
        device.bodyIndexFlag = authInfo.defaultIndexFlag;
        device.otherTargetFlag = authInfo.defaultAddTargetFlag;
    }
    return device;
}

+ (QNAuthDevice *)getShareDeviceInfo {
    QNAuthInfo *authInfo = [QNAuthInfo sharedAuthInfo];
    QNAuthDevice *device = [[QNAuthDevice alloc] init];
    device.model = authInfo.defaultModel;
    device.method = authInfo.defaultMethod;
    device.internalModel = @"0000";
    device.bodyIndexFlag = authInfo.defaultIndexFlag;
    device.otherTargetFlag = authInfo.defaultAddTargetFlag;
    return device;
}

@end
