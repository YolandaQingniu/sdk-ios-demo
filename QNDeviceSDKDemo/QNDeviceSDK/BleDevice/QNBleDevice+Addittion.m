//
//  QNBleDevice+Addittion.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/10.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNBleDevice+Addittion.h"
#import "QNDataTool.h"
#import <objc/runtime.h>
#import "QNFileManage.h"

@implementation QNBleDevice (Addittion)
static char QNBleDevice_scaleDevice;
static char QNBleDevice_bandDevice;
static char QNBleDevice_deviceMessage;

- (void)setScaleDevice:(QNPScaleDevice *)scaleDevice {
    objc_setAssociatedObject(self, &QNBleDevice_scaleDevice, scaleDevice, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNPScaleDevice *)scaleDevice{
    QNPScaleDevice *scale = (QNPScaleDevice *)objc_getAssociatedObject(self, &QNBleDevice_scaleDevice);
    return scale;
}

- (void)setBandDevice:(QNBandDevice *)bandDevice {
    objc_setAssociatedObject(self, &QNBleDevice_bandDevice, bandDevice, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNBandDevice *)bandDevice {
    return objc_getAssociatedObject(self, &QNBleDevice_bandDevice);
}

- (void)setDeviceMessage:(QNDeviceMessage *)deviceMessage {
    objc_setAssociatedObject(self, &QNBleDevice_deviceMessage, deviceMessage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNDeviceMessage *)deviceMessage {
    QNDeviceMessage *deviceMesg = (QNDeviceMessage *)objc_getAssociatedObject(self, &QNBleDevice_deviceMessage);
    return deviceMesg;
}

+ (QNBleDevice *)createQNBleDeviceForDevice:(id)device{
    QNSDKConfig *sdkConfig = [[QNFileManage sharedFileManager] sdkConfig];
    if (sdkConfig == nil || device == nil) {
        return nil;
    }
    
    if ([device isKindOfClass:[QNBandDevice class]]) {
        QNBandDevice *bandDevice = (QNBandDevice *)device;
        QNBleDevice *bleDevice = [[QNBleDevice alloc] init];
        bleDevice.bandDevice = bandDevice;
        [bleDevice setValue:bandDevice.mac forKeyPath:@"mac"];
        [bleDevice setValue:@"QN-Band" forKeyPath:@"name"];
        [bleDevice setValue:bandDevice.internalModel forKeyPath:@"modeId"];
        [bleDevice setValue:bandDevice.bluetoothName forKeyPath:@"bluetoothName"];
        [bleDevice setValue:bandDevice.RSSI forKeyPath:@"RSSI"];
        [bleDevice setValue:[NSNumber numberWithUnsignedInteger:QNDeviceBand] forKeyPath:@"deviceType"];
        [bleDevice setValue:bandDevice.UUIDIdentifier forKeyPath:@"uuidIdentifier"];
        return bleDevice;
    }
    
    
    QNPScaleDevice *scaleDevice = (QNPScaleDevice *)device;
    
    for (QNDeviceMessage *deviceMesg in sdkConfig.models) {
        if ([deviceMesg.internalModel isEqualToString:scaleDevice.internalModel]) {
            return [self bleDeviceQNBDevice:scaleDevice deviceMessage:deviceMesg];
        }
    }
    if (sdkConfig.connectOtherFlag) {
        QNDeviceMessage *deviceMesg = [[QNDeviceMessage alloc] init];
        deviceMesg.model = sdkConfig.defaultModel;
        deviceMesg.method = sdkConfig.defaultMethod;
        deviceMesg.internalModel = nil;
        deviceMesg.bodyIndexFlag = sdkConfig.defaultIndexFlag;
        return [self bleDeviceQNBDevice:device deviceMessage:deviceMesg];
    }
    return nil;
}

+ (QNBleDevice *)bleDeviceQNBDevice:(QNPScaleDevice *)device deviceMessage:(QNDeviceMessage *)deviceMessage {
    QNBleDevice *bleDevice = [[QNBleDevice alloc] init];
    bleDevice.scaleDevice = device;
    bleDevice.deviceMessage = deviceMessage;
    [bleDevice setValue:device.mac forKeyPath:@"mac"];
    [bleDevice setValue:deviceMessage.model forKeyPath:@"name"];
    [bleDevice setValue:device.internalModel forKeyPath:@"modeId"];
    [bleDevice setValue:device.bluetoothName forKeyPath:@"bluetoothName"];
    [bleDevice setValue:device.RSSI forKeyPath:@"RSSI"];
    [bleDevice setValue:[NSNumber numberWithUnsignedInteger:QNDeviceScale] forKeyPath:@"deviceType"];
    [bleDevice setValue:device.UUIDIdentifier forKeyPath:@"uuidIdentifier"];
    [bleDevice setValue:[NSNumber numberWithBool:device.screenState == QNDeviceScreenStateOpen ? YES : NO] forKeyPath:@"screenOn"];
    return bleDevice;
}


@end
