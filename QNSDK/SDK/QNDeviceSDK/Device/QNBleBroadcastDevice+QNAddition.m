//
//  QNBleBroadcastDevice+QNAddition.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/7/11.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "QNBleBroadcastDevice+QNAddition.h"
#import "QNBleDevice+QNAddition.h"
#import <objc/runtime.h>

@implementation QNBleBroadcastDevice (QNAddition)
static char QNBleBroadcastDeviceResistanceKey;
static char QNBleBroadcastDeviceTimeTempKey;
static char QNBleBroadcastAdvertDeviceKey;

- (void)setRes:(int)res {
    objc_setAssociatedObject(self, &QNBleBroadcastDeviceResistanceKey, [NSNumber numberWithInt:res], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int)res {
    NSNumber *num = objc_getAssociatedObject(self, &QNBleBroadcastDeviceResistanceKey);
    if (num == nil) {
        return 0;
    }else {
        return [num intValue];
    }
}

- (void)setTimeTemp:(NSTimeInterval)timeTemp {
    objc_setAssociatedObject(self, &QNBleBroadcastDeviceTimeTempKey, [NSNumber numberWithDouble:timeTemp], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)timeTemp {
    NSNumber *num = objc_getAssociatedObject(self, &QNBleBroadcastDeviceTimeTempKey);
    if (num == nil) {
        return 0;
    }else {
        return [num doubleValue];
    }
}


- (void)setAdvertDevice:(QNAdvertScaleDevice *)advertDevice {
    objc_setAssociatedObject(self, &QNBleBroadcastAdvertDeviceKey, advertDevice, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNAdvertScaleDevice *)advertDevice {
    return objc_getAssociatedObject(self, &QNBleBroadcastAdvertDeviceKey);
}

- (void)tranform:(QNBleDevice *)device {
    [self setValue:device.mac forKeyPath:@"mac"];
    [self setValue:device.name forKeyPath:@"name"];
    [self setValue:device.modeId forKeyPath:@"modeId"];
    [self setValue:device.bluetoothName forKeyPath:@"bluetoothName"];
    [self setValue:device.RSSI forKeyPath:@"RSSI"];
    [self setValue:[NSNumber numberWithBool:device.advertDevice.supportUnitChangeFlag] forKeyPath:@"supportUnitChange"];

    QNUnit unit = QNUnitKG;
    switch (device.advertDevice.unit) {
        case QNAdvertScaleUnitLB:
            unit = QNUnitLB;
            break;
        case QNAdvertScaleUnitJin:
            unit = QNUnitJIN;
            break;
        default:
            unit = QNUnitKG;
            break;
    }
    
    [self setValue:[NSNumber numberWithUnsignedInteger:unit] forKeyPath:@"unit"];
    [self setValue:[NSNumber numberWithDouble:device.advertDevice.weight] forKeyPath:@"weight"];
    [self setValue:[NSNumber numberWithBool:device.advertDevice.isComplete] forKeyPath:@"isComplete"];
    [self setValue:[NSNumber numberWithInt:(int)device.advertDevice.count] forKeyPath:@"measureCode"];
    self.advertDevice = device.advertDevice;
    self.res = (int)device.advertDevice.resistance;
}

@end
