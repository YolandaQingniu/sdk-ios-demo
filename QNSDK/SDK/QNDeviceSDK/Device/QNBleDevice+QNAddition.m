//
//  QNBleDevice+QNAddition.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/10.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNBleDevice+QNAddition.h"
#import "QNDataTool.h"
#import <objc/runtime.h>

@implementation QNBleDevice (QNAddition)
static char QNBleDevice_publicDevice;
static char QNBleDevice_advertDevice;
static char QNBleDevice_wspDevice;
static char QNBleDevice_heightScaleDevice;
static char QNBleDevice_authDevice;
static char QNBleDevice_user;

- (void)setPublicDevice:(QNPScaleDevice *)publicDevice {
    objc_setAssociatedObject(self, &QNBleDevice_publicDevice, publicDevice, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNPScaleDevice *)publicDevice{
    QNPScaleDevice *scale = (QNPScaleDevice *)objc_getAssociatedObject(self, &QNBleDevice_publicDevice);
    return scale;
}

- (void)setAdvertDevice:(QNAdvertScaleDevice *)advertDevice {
    objc_setAssociatedObject(self, &QNBleDevice_advertDevice, advertDevice, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNAdvertScaleDevice *)advertDevice {
    QNAdvertScaleDevice *scale = (QNAdvertScaleDevice *)objc_getAssociatedObject(self, &QNBleDevice_advertDevice);
    return scale;
}


- (void)setAuthDevice:(QNAuthDevice *)authDevice {
    objc_setAssociatedObject(self, &QNBleDevice_authDevice, authDevice, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNAuthDevice *)authDevice {
    return objc_getAssociatedObject(self, &QNBleDevice_authDevice);
}

- (void)setWspDevice:(QNWspDevice *)wspDevice {
    objc_setAssociatedObject(self, &QNBleDevice_wspDevice, wspDevice, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNWspDevice *)wspDevice {
    QNWspDevice *scale = (QNWspDevice *)objc_getAssociatedObject(self, &QNBleDevice_wspDevice);
    return scale;
}

- (void)setHeightScaleDevice:(QNHeightScaleDevice *)heightScaleDevice {
    objc_setAssociatedObject(self, &QNBleDevice_heightScaleDevice, heightScaleDevice, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNHeightScaleDevice *)heightScaleDevice {
    QNHeightScaleDevice *scale = (QNHeightScaleDevice *)objc_getAssociatedObject(self, &QNBleDevice_heightScaleDevice);
    return scale;
}

- (void)setUser:(QNUser *)user {
    objc_setAssociatedObject(self, &QNBleDevice_user, user, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNUser *)user {
    return objc_getAssociatedObject(self, &QNBleDevice_user);
}

+ (QNBleDevice *)buildBleDeviceWithDevice:(id)device {
    if (device == nil) return nil;
    
    NSString *internalModel = nil;
    if (device != nil) {
        if ([device isKindOfClass:[QNPScaleDevice class]]) {
            internalModel = ((QNPScaleDevice *)device).internalModel;
        } else if ([device isKindOfClass:[QNAdvertScaleDevice class]]) {
            internalModel = ((QNAdvertScaleDevice *)device).internalModel;
        } else if ([device isKindOfClass:[QNWspDevice class]]) {
            internalModel = ((QNWspDevice *)device).internalModel;
        } else if ([device isKindOfClass:[QNHeightScaleDevice class]]) {
            internalModel = ((QNHeightScaleDevice *)device).internalModel;
        }
    }
    
    if (internalModel == nil) return nil;
    
    QNAuthDevice *authDevice = [QNDeviceTool getDeviceInfoWithInternalModel:internalModel];
    
    if (authDevice == nil) return nil;
    
    if ([device isKindOfClass:[QNAdvertScaleDevice class]]) {
        QNAdvertScaleDevice *advertDevice = (QNAdvertScaleDevice *)device;
        if (advertDevice.deviceType == QNAdvertDeviceTypeKitchen) {
            authDevice.model = @"CK10A";
        }
    }
    return [self bleDeviceQNBDevice:device authDevice:authDevice];
}

+ (QNBleDevice *)bleDeviceQNBDevice:(id)device authDevice:(QNAuthDevice *)authDevice {
    QNBleDevice *bleDevice = [[QNBleDevice alloc] init];
    bleDevice.authDevice = authDevice;
    [bleDevice setValue:authDevice.model forKeyPath:@"name"];
    if ([device isKindOfClass:[QNPScaleDevice class]]) {
        QNPScaleDevice *publicDevice = (QNPScaleDevice *)device;
        bleDevice.publicDevice = publicDevice;
        [bleDevice setValue:publicDevice.mac forKeyPath:@"mac"];
        [bleDevice setValue:publicDevice.internalModel forKeyPath:@"modeId"];
        [bleDevice setValue:publicDevice.bluetoothName forKeyPath:@"bluetoothName"];
        [bleDevice setValue:publicDevice.RSSI forKeyPath:@"RSSI"];
        [bleDevice setValue:[NSNumber numberWithBool:publicDevice.screenState == QNDeviceScreenStateOpen ? YES : NO] forKeyPath:@"screenOn"];
        [bleDevice setValue:[NSNumber numberWithInteger:QNDeviceTypeScaleBleDefault] forKeyPath:@"deviceType"];
        [bleDevice setValue:[NSNumber numberWithBool:publicDevice.doubleModuleFlag] forKeyPath:@"supportWifi"];
    } else if ([device isKindOfClass:[QNAdvertScaleDevice class]]) {
        QNAdvertScaleDevice *advertDevice = (QNAdvertScaleDevice *)device;
        bleDevice.advertDevice = advertDevice;
        [bleDevice setValue:advertDevice.mac forKeyPath:@"mac"];
        [bleDevice setValue:advertDevice.internalModel forKeyPath:@"modeId"];
        [bleDevice setValue:advertDevice.bluetoothName forKeyPath:@"bluetoothName"];
        [bleDevice setValue:advertDevice.RSSI forKeyPath:@"RSSI"];
        [bleDevice setValue:[NSNumber numberWithBool:YES] forKeyPath:@"screenOn"];
        [bleDevice setValue:[NSNumber numberWithInteger:QNDeviceTypeScaleBroadcast] forKeyPath:@"deviceType"];
    } else if ([device isKindOfClass:[QNWspDevice class]]) {
        QNWspDevice *wspDevice = (QNWspDevice *)device;
        bleDevice.wspDevice = wspDevice;
        [bleDevice setValue:wspDevice.mac forKeyPath:@"mac"];
        [bleDevice setValue:wspDevice.internalModel forKeyPath:@"modeId"];
        [bleDevice setValue:wspDevice.bluetoothName forKeyPath:@"bluetoothName"];
        [bleDevice setValue:wspDevice.RSSI forKeyPath:@"RSSI"];
        [bleDevice setValue:[NSNumber numberWithBool:YES] forKeyPath:@"screenOn"];
        [bleDevice setValue:[NSNumber numberWithBool:YES] forKeyPath:@"supportWifi"];
        [bleDevice setValue:[NSNumber numberWithInteger:QNDeviceTypeScaleWsp] forKeyPath:@"deviceType"];
        [bleDevice setValue:[NSNumber numberWithInteger:wspDevice.allowMaxUserNum] forKeyPath:@"maxUserNum"];
        [bleDevice setValue:[NSNumber numberWithInteger:wspDevice.registerUserNum] forKeyPath:@"registeredUserNum"];

    } else if ([device isKindOfClass:[QNHeightScaleDevice class]]) {
        QNHeightScaleDevice *heightWeightDevice = (QNHeightScaleDevice *)device;
        bleDevice.heightScaleDevice = heightWeightDevice;
        [bleDevice setValue:heightWeightDevice.mac forKeyPath:@"mac"];
        [bleDevice setValue:heightWeightDevice.internalModel forKeyPath:@"modeId"];
        [bleDevice setValue:heightWeightDevice.bluetoothName forKeyPath:@"bluetoothName"];
        [bleDevice setValue:heightWeightDevice.RSSI forKeyPath:@"RSSI"];
        [bleDevice setValue:[NSNumber numberWithBool:YES] forKeyPath:@"screenOn"];
        [bleDevice setValue:[NSNumber numberWithBool:YES] forKeyPath:@"supportWifi"];
        [bleDevice setValue:[NSNumber numberWithInteger:QNDeviceTypeHeightScale] forKeyPath:@"deviceType"];
    }
    return bleDevice;
}
@end
