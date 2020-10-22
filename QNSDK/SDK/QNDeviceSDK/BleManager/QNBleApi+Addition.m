//
//  QNBleApi+Addition.m
//  QNDeviceSDK
//
//  Created by JuneLee on 2019/9/18.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "QNBleApi+Addition.h"
#import "QNBleApi+BroadcastDevice.h"
#import "QNScaleData+QNAddition.h"
#import "QNScaleStoreData+QNAddition.h"
#import "QNBleApi+NormalDevice.h"

@implementation QNBleApi (Addition)
static char QNBleApi_centralManager;
static char QNBleApi_deviceList;
static char QNBleApi_connectDevice;
static char QNBleApi_connectDeviceFlag;
static char QNBleApi_scanTimer;
static char QNBleApi_scanBehaviorFlag;
static char QNBleApi_storageAll;
static char QNBleApi_bleProtocolListener;

- (void)setCentralManager:(CBCentralManager *)centralManager {
    objc_setAssociatedObject(self, &QNBleApi_centralManager, centralManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CBCentralManager *)centralManager {
    return objc_getAssociatedObject(self, &QNBleApi_centralManager);
}

- (void)setDeviceList:(NSMutableArray<QNBleDevice *> *)deviceList {
    objc_setAssociatedObject(self, &QNBleApi_deviceList, deviceList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<QNBleDevice *> *)deviceList {
    NSMutableArray *list = objc_getAssociatedObject(self, &QNBleApi_deviceList);
    if (list == nil) {
        list = [NSMutableArray<QNBleDevice *> array];
        objc_setAssociatedObject(self, &QNBleApi_deviceList, list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return list;
}

- (void)setConnectDevice:(QNBleDevice *)connectDevice {
    objc_setAssociatedObject(self, &QNBleApi_connectDevice, connectDevice, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNBleDevice *)connectDevice{
    QNBleDevice *connectDevice = (QNBleDevice *)objc_getAssociatedObject(self, &QNBleApi_connectDevice);
    return connectDevice;
}


- (void)setConnectDeviceFlag:(BOOL)connectDeviceFlag {
    objc_setAssociatedObject(self, &QNBleApi_connectDeviceFlag, [NSNumber numberWithBool:connectDeviceFlag], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)connectDeviceFlag {
    NSNumber *num = objc_getAssociatedObject(self, &QNBleApi_connectDeviceFlag);
    if (num == nil) {
        num = [NSNumber numberWithBool:NO];
    }
    return [num boolValue];
}

- (void)setScanTimer:(NSTimer *)scanTimer {
    objc_setAssociatedObject(self, &QNBleApi_scanTimer, scanTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)scanTimer {
    return objc_getAssociatedObject(self, &QNBleApi_scanTimer);
}

- (void)setScanBehaviorFlag:(BOOL)scanBehaviorFlag {
    objc_setAssociatedObject(self, &QNBleApi_scanBehaviorFlag, [NSNumber numberWithBool:scanBehaviorFlag], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)scanBehaviorFlag {
    NSNumber *num = objc_getAssociatedObject(self, &QNBleApi_scanBehaviorFlag);
    if (num == nil) {
        num = [NSNumber numberWithBool:NO];
    }
    return [num boolValue];
}

- (void)setStorageAll:(NSMutableArray<QNScaleStoreData *> *)storageAll {
    objc_setAssociatedObject(self, &QNBleApi_storageAll, storageAll, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<QNScaleStoreData *> *)storageAll {
    NSMutableArray *list = objc_getAssociatedObject(self, &QNBleApi_storageAll);
    if (list == nil) {
        list = [NSMutableArray array];
        objc_setAssociatedObject(self, &QNBleApi_storageAll, list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return list;
}

- (void)setBleProtocolListener:(id<QNBleProtocolDelegate>)bleProtocolListener {
    self.scaleManager.isCallBackWriteData = YES;
    objc_setAssociatedObject(self, &QNBleApi_bleProtocolListener, bleProtocolListener, OBJC_ASSOCIATION_ASSIGN);
}

- (id<QNBleProtocolDelegate>)bleProtocolListener {
    return objc_getAssociatedObject(self, &QNBleApi_bleProtocolListener);
}

#pragma mark -
- (QNBleDevice *)getBleDeviceWithMac:(NSString *)mac {
    if (self.connectDevice != nil) {
        return self.connectDevice;
    }
    for (QNBleDevice *device in self.deviceList) {
        if ([device.mac isEqualToString:mac]) {
            return device;
        }
    }
    return nil;
}

- (void)cancelScanTimer {
    if (self.scanTimer) {
        [self.scanTimer setFireDate:[NSDate distantFuture]];
        [self.scanTimer invalidate];
        self.scanTimer = nil;
    }
}


#pragma mark -
- (void)privateStopBleDeviceWithMac:(NSString *)mac isCallback:(BOOL)isCallback resultCallback:(QNResultCallback)callback {
    [self cancelScanTimer];
    BOOL connectedAdvert = self.connectDeviceFlag && [self getBleDeviceWithMac:mac].advertDevice != nil;
    if (!connectedAdvert) {
        [self.centralManager stopScanDevice];
        [self.advertManager endEnhanceBroadcaset];
    }
    if (isCallback) {
        if (QNDelegate(self.discoveryListener,onStopScan)) [self.discoveryListener onStopScan];
    }
    !callback ?: callback(nil);
}

- (void)handleRealTimeWeight:(double)weight connectDevice:(QNBleDevice *)device {
    if (QNDelegate(self.dataListener,onGetUnsteadyWeight:weight:)) {
        [self.dataListener onGetUnsteadyWeight:[self getBleDeviceWithMac:device.mac] weight:weight];
    }
}

- (void)handleResultDataCypher:(QNDataCypher *)dataCypher connectDevice:(QNBleDevice *)device isCalculate:(BOOL)isCalculate {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    QNScaleData *scaleData = [QNScaleData buildDataCypher:dataCypher user:bleDevice.user isCallCalculate:isCalculate];
    if (QNDelegate(self.dataListener,onGetScaleData:data:)) {
        [self.dataListener onGetScaleData:bleDevice data:scaleData];
    }
}


- (void)handleStoragDataCypher:(QNDataCypher *)dataCypher connectDevice:(nonnull QNBleDevice *)device user:(nullable QNUser *)user isComplete:(BOOL)isComplete{
    QNScaleStoreData *scaleStoreData = [QNScaleStoreData buildDataCypher:dataCypher mac:device.mac userData:user];
    [self.storageAll addObject:scaleStoreData];
    
    if (isComplete) {
        [self receiveStorageDataCompleteWithMac:device.mac];
    }
}

- (void)receiveStorageDataCompleteWithMac:(NSString *)mac {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:mac];
    if (QNDelegate(self.dataListener,onGetStoredScale:data:)) {
        [self.dataListener onGetStoredScale:bleDevice data:[self.storageAll mutableCopy]];
    }
}

@end
