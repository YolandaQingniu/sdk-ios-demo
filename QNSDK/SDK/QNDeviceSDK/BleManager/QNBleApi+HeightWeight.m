//
//  QNBleApi+HeightWeight.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/6/12.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNBleApi+HeightWeight.h"

@implementation QNBleApi (HeightWeight)
static char QNBleApi_heightScaleManager;

- (void)setHeightScaleManager:(QNHeightScaleManager *)heightScaleManager {
    objc_setAssociatedObject(self, &QNBleApi_heightScaleManager, heightScaleManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNHeightScaleManager *)heightScaleManager {
    return objc_getAssociatedObject(self, &QNBleApi_heightScaleManager);
}

#pragma mark - QNHeightScaleDelegate
- (void)heightScaleReceiveRealTimeWeight:(double)weight connectedDevice:(QNHeightScaleDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    [self handleRealTimeWeight:[QNDataCypher calculateCurWeightWithUser:bleDevice.user weight:weight] connectDevice:bleDevice];;
}

- (void)heightScaleReceiveRealTimeHeight:(double)height connectedDevice:(QNHeightScaleDevice *)device {
    
}

- (void)heightScaleReceiveResultData:(QNHeightScaleData *)scaleData connectedDevice:(QNHeightScaleDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    QNDataCypher *dataCypher = [QNDataCypher buildHeihgtWeightCypherWithWeight:scaleData.weight res:scaleData.resistance secRes:scaleData.secResistance timeTemp:scaleData.timeTemp device:bleDevice.authDevice height:scaleData.height mode:scaleData.isBodyFatMode ? QNHeightWeightModeBodyfat : QNHeightWeightModeWeight];
    [self handleResultDataCypher:dataCypher connectDevice:bleDevice isCalculate:YES];
}

- (void)heightScaleReceiveStorageData:(QNHeightStorageScaleData *)storageScaleData connectedDevice:(QNHeightScaleDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    QNDataCypher *dataCypher = [QNDataCypher buildHeihgtWeightCypherWithWeight:storageScaleData.weight res:storageScaleData.resistance secRes:storageScaleData.secResistance timeTemp:storageScaleData.timeTemp device:bleDevice.authDevice height:storageScaleData.height mode: storageScaleData.resistance > 0 ? QNHeightWeightModeBodyfat : QNHeightWeightModeWeight];
    [self handleStoragDataCypher:dataCypher connectDevice:bleDevice user:nil isComplete:storageScaleData.curCNT == storageScaleData.total];
}

- (void)heightScaleChangeToScaleState:(QNHeightScaleState)scaleState connectedDevice:(QNHeightScaleDevice *)device error:(NSError *)error {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    QNScaleState qnScaleState = QNScaleStateDisconnected;
    QNScaleEvent qnScaleEvent = 0;
    switch (scaleState) {
        case QNHeightScaleConnecting:
            qnScaleState = QNScaleStateConnecting;
            if (QNDelegate(self.connectionChangeListener,onConnecting:)) {
                [self.connectionChangeListener onConnecting:bleDevice];
            }
            break;
            
        case QNHeightScaleConnectFail:
            qnScaleState = QNScaleStateLinkLoss;
            self.connectDeviceFlag = NO;
            if (QNDelegate(self.connectionChangeListener,onConnectError:error:)) {
                [self.connectionChangeListener onConnectError:bleDevice error:[NSError errorForQNBLEModuleError:error]];
            }
            break;
            
        case QNHeightScaleConnected:
            qnScaleState = QNScaleStateConnected;
            if (QNDelegate(self.connectionChangeListener,onConnected:)) {
                [self.connectionChangeListener onConnected:bleDevice];
            }
            break;
            
        case QNHeightScaleDiscoverServices:
            if (QNDelegate(self.connectionChangeListener,onServiceSearchComplete:)) {
                [self.connectionChangeListener onServiceSearchComplete:bleDevice];
            }
            break;
            
        case QNHeightScaleDiscoverCharacteristics:
            break;
            
        case QNHeightScaleReadyWeight:
            qnScaleState = QNScaleStateRealTime;
            break;
            
        case QNHeightScaleReadyHeight:
            break;
            
        case QNHeightScaleBodyFat:
            qnScaleState = QNScaleStateBodyFat;
            break;
            
        case QNHeightScaleMeasureComplete:
            qnScaleState = QNScaleStateMeasureCompleted;
            if (QNDelegate(self.connectionChangeListener,onDisconnecting:)) {
                [self.connectionChangeListener onDisconnecting:bleDevice];
            }
            break;
            
        case QNHeightScaleDisconected:
            qnScaleState = QNScaleStateLinkLoss;
            self.connectDeviceFlag = NO;
            [self cancelScanTimer];
            break;
        default:
            break;
    }
    if (qnScaleState != QNScaleStateDisconnected) {
        if (QNDelegate(self.dataListener,onScaleStateChange:scaleState:)) {
            [self.dataListener onScaleStateChange:bleDevice scaleState:qnScaleState];
        }
    }
    if (qnScaleEvent > 0) {
        if (QNDelegate(self.dataListener, onScaleEventChange:scaleEvent:)) {
            [self.dataListener onScaleEventChange:bleDevice scaleEvent:qnScaleEvent];
        }
    }
}

- (void)heightScaleVersion:(NSUInteger)scaleVersion bleVersion:(NSUInteger)bleVersion connectedDevice:(QNHeightScaleDevice *)device {
    
}

@end
