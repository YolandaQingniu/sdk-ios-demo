//
//  QNBleApi+BroadcastDevice.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/2/26.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNBleApi+BroadcastDevice.h"

@implementation QNBleApi (BroadcastDevice)
static char QNBleApi_advertManager;

- (void)setAdvertManager:(QNAdvertScaleManager *)advertManager {
    objc_setAssociatedObject(self, &QNBleApi_advertManager, advertManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNAdvertScaleManager *)advertManager {
    return objc_getAssociatedObject(self, &QNBleApi_advertManager);
}

#pragma mark - 
- (void)advertScaleReceiveRealTimeWeight:(double)weight connectedDevice:(QNAdvertScaleDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    [self handleRealTimeWeight:[QNDataCypher calculateCurWeightWithUser:bleDevice.user weight:weight] connectDevice:bleDevice];
}

- (void)advertScaleReceiveResultData:(QNAdvertScaleData *)scaleData connectedDevice:(QNAdvertScaleDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    QNDataCypher *dataCypher = [QNDataCypher buildCypherWithWeight:scaleData.weight res:scaleData.resistance secRes:0 timeTemp:scaleData.timeTemp device:bleDevice.authDevice heartRate:0];
    [self handleResultDataCypher:dataCypher connectDevice:bleDevice isCalculate:YES];
}

- (void)advertScaleReceiveStorageData:(QNAdvertScaleData *)storageScaleData connectedDevice:(QNAdvertScaleDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    QNDataCypher *dataCypher = [QNDataCypher buildCypherWithWeight:storageScaleData.weight res:storageScaleData.resistance secRes:0 timeTemp:storageScaleData.timeTemp device:bleDevice.authDevice heartRate:0];
    [self handleStoragDataCypher:dataCypher connectDevice:bleDevice user:nil isComplete:device.storageNum == 1];
}


- (void)advertScaleVersion:(NSUInteger)scaleVersion bleVersion:(NSUInteger)bleVersion connectedDevice:(QNAdvertScaleDevice *)device {
    
}

- (void)advertScaleChangeToScaleState:(QNAdvertScaleState)scaleState connectedDevice:(QNAdvertScaleDevice *)device error:(NSError *)error {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    QNScaleState qnScaleState = QNScaleStateDisconnected;
    switch (scaleState) {
        case QNAdvertScaleStateConnecting:
            qnScaleState = QNScaleStateConnecting;
            if (QNDelegate(self.connectionChangeListener,onConnecting:)) {
                [self.connectionChangeListener onConnecting:bleDevice];
            }
            break;
            
        case QNAdvertScaleStateConnectFail:
            qnScaleState = QNScaleStateLinkLoss;
            if (self.scanBehaviorFlag == NO) {
                [self privateStopBleDeviceWithMac:device.mac isCallback:NO resultCallback:nil];
            }
            if (QNDelegate(self.connectionChangeListener,onConnectError:error:)) {
                [self.connectionChangeListener onConnectError:bleDevice error:[NSError errorForQNBLEModuleError:error]];

            }
            break;
            
        case QNAdvertScaleStateConnected:
            qnScaleState = QNScaleStateConnected;
            if (QNDelegate(self.connectionChangeListener,onConnected:)) {
                [self.connectionChangeListener onConnected:bleDevice];
            }
            break;
            
        case QNAdvertScaleStateRealTime:
            qnScaleState = QNScaleStateRealTime;
            break;
            
        case QNAdvertScaleStateMeasureComplete:
            qnScaleState = QNScaleStateMeasureCompleted;
            break;
            
        case QNAdvertScaleStateDisconected:
            qnScaleState = QNScaleStateLinkLoss;
            if (QNDelegate(self.connectionChangeListener,onDisconnecting:)) {
                [self.connectionChangeListener onDisconnecting:bleDevice];
            }
            self.connectDeviceFlag = NO;
            if (self.scanBehaviorFlag == NO) {
                [self privateStopBleDeviceWithMac:device.mac isCallback:NO resultCallback:nil];
            }
            break;
        default:
            break;
    }
    if (qnScaleState != QNScaleStateDisconnected) {
        if (QNDelegate(self.dataListener,onScaleStateChange:scaleState:)) {
            [self.dataListener onScaleStateChange:bleDevice scaleState:qnScaleState];
        }
    }
}

@end
