//
//  QNBleProtocolHandler.m
//  QNDeviceSDKDemo
//
//  Created by JuneLee on 2019/8/26.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "QNBleProtocolHandler.h"
#import "QNBleApi.h"
#import "QNPScaleDevice.h"
#import "QNBleDevice+QNAddition.h"
#import "QNBleApi+Addition.h"
#import "QNPScaleModule.h"
#import "QNBleProtocolHandler+QNAddition.h"
#import <objc/runtime.h>

@implementation QNBleProtocolHandler

#pragma mark - 通知协议处理器做初始化的工作
- (void)prepare:(NSString *)serviceUUID {
    if (self.device.publicDevice == nil || serviceUUID.length == 0) {
        return;
    }
    [[QNPScaleManager sharedScaleManager] prepareBleWithDevice:self.device.publicDevice protocol:serviceUUID];
}

#pragma mark - 获取蓝牙数据
- (void)onGetBleData:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID data:(NSData *)data {    
    [[QNPScaleManager sharedScaleManager] analysisProtocolData:serviceUUID characteristicUUID:characteristicUUID receiveData:data scaleDevice:self.device.publicDevice error:nil];
}
@end


@implementation QNBleProtocolHandler (QNAddition)
static char QNBleProtocolHandler_device_key;
- (void)setDevice:(QNBleDevice *)device {
    objc_setAssociatedObject(self, &QNBleProtocolHandler_device_key, device, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNBleDevice *)device {
    return objc_getAssociatedObject(self, &QNBleProtocolHandler_device_key);
}
@end
