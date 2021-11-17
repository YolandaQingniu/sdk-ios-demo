//
//  QNBleDevice+Addition.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2020/10/21.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNBleDevice+Addition.h"
#import <objc/runtime.h>

@implementation QNBleDevice (Addition)
static char QNBleDevice_peripheral_key;
static char QNBleDevice_ffe3_write_key;
static char QNBleDevice_ffe4_write_key;
static char QNBleDevice_fff2_write_key;
static char QNBleDevice_abf2_write_key;
static char QNBleDevice_protocol_handler_key;

- (void)setPeripheral:(CBPeripheral *)peripheral {
    objc_setAssociatedObject(self, &QNBleDevice_peripheral_key, peripheral, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CBPeripheral *)peripheral {
    return objc_getAssociatedObject(self, &QNBleDevice_peripheral_key);
}

- (void)setFfe3Write:(CBCharacteristic *)ffe3Write {
    objc_setAssociatedObject(self, &QNBleDevice_ffe3_write_key, ffe3Write, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CBCharacteristic *)ffe3Write {
    return objc_getAssociatedObject(self, &QNBleDevice_ffe3_write_key);
}

- (void)setFfe4Write:(CBCharacteristic *)ffe4Write {
    objc_setAssociatedObject(self, &QNBleDevice_ffe4_write_key, ffe4Write, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CBCharacteristic *)ffe4Write {
    return objc_getAssociatedObject(self, &QNBleDevice_ffe4_write_key);
}

- (void)setFff2Write:(CBCharacteristic *)fff2Write {
    objc_setAssociatedObject(self, &QNBleDevice_fff2_write_key, fff2Write, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CBCharacteristic *)fff2Write {
    return objc_getAssociatedObject(self, &QNBleDevice_fff2_write_key);
}

- (void)setAbf2Write:(CBCharacteristic *)abf2Write {
    objc_setAssociatedObject(self, &QNBleDevice_abf2_write_key, abf2Write, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CBCharacteristic *)abf2Write {
    return objc_getAssociatedObject(self, &QNBleDevice_abf2_write_key);
}

- (void)setHandler:(QNBleProtocolHandler *)handler {
    objc_setAssociatedObject(self, &QNBleDevice_protocol_handler_key, handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNBleProtocolHandler *)handler{
    return objc_getAssociatedObject(self, &QNBleDevice_protocol_handler_key);
}

@end
