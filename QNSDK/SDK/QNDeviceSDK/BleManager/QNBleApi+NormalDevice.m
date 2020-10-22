//
//  QNBleApi+NormalDevice.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/2/26.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNBleApi+NormalDevice.h"

@implementation QNBleApi (NormalDevice)
static char QNBleApi_normalDeviceManager;

#pragma mark - 
- (void)setScaleManager:(QNPScaleManager *)scaleManager {
    objc_setAssociatedObject(self, &QNBleApi_normalDeviceManager, scaleManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNPScaleManager *)scaleManager {
    return objc_getAssociatedObject(self, &QNBleApi_normalDeviceManager);
}

#pragma mark - QNPScaleDelegate
- (void)publicScaleReceiveRealTimeWeight:(double)weight connectedDevice:(nonnull QNPScaleDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    [self handleRealTimeWeight:[QNDataCypher calculateCurWeightWithUser:bleDevice.user weight:weight] connectDevice:bleDevice];;
}

- (void)publicScaleReceiveResultData:(QNPScaleData *)scaleData connectedDevice:(QNPScaleDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    QNDataCypher *dataCypher = [QNDataCypher buildCypherWithWeight:scaleData.weight res:scaleData.resistance secRes:scaleData.secResistance timeTemp:scaleData.timeTemp device:bleDevice.authDevice heartRate:scaleData.heartRate];
    [self handleResultDataCypher:dataCypher connectDevice:bleDevice isCalculate:YES];
}

- (void)publicScaleReceiveStorageData:(QNPScaleStorageData *)storageScaleData connectedDevice:(QNPScaleDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    QNDataCypher *dataCypher = [QNDataCypher buildCypherWithWeight:storageScaleData.weight res:storageScaleData.resistance secRes:storageScaleData.secResistance timeTemp:storageScaleData.timeTemp device:bleDevice.authDevice heartRate:storageScaleData.heartRate];
    [self handleStoragDataCypher:dataCypher connectDevice:bleDevice user:nil isComplete:storageScaleData.curCNT == storageScaleData.total];
}


- (QNPScaleReplayData *)publicScaleRequestRelayDataForMeasureData:(QNPScaleData *)scaleData connectedDevice:(QNPScaleDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    QNDataCypher *dataCypher = [QNDataCypher buildCypherWithWeight:scaleData.weight res:scaleData.resistance secRes:scaleData.secResistance timeTemp:scaleData.timeTemp device:bleDevice.authDevice heartRate:scaleData.heartRate];
    [dataCypher calculateMeasureDataWithUser:bleDevice.user];
    
    QNPScaleReplayData *replayData = [[QNPScaleReplayData alloc] init];
    replayData.bodyFat = dataCypher.bodyfatRate;
    replayData.BMI = dataCypher.BMI;
    replayData.bodyFatLevel = QNScaleBodyFatLevelStand;
    replayData.BMILevel = QNScaleBMILevelStand;
    return replayData;
}

- (void)publicScaleReceiveElectric:(NSUInteger)electric connectedDevice:(QNPScaleDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    if (QNDelegate(self.dataListener,onGetElectric:device:)) {
        [self.dataListener onGetElectric:electric device:bleDevice];
    }
}

- (void)publicScaleLowElectricConnectedDevice:(QNPScaleDevice *)device {
    
}

- (void)publicScaleWriteData:(QNPProtocolData *)protocolData connectedDevice:(QNPScaleDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    if (QNDelegate(self.bleProtocolListener,writeCharacteristicValue:characteristicUUID:data:device:)) {
        [self.bleProtocolListener writeCharacteristicValue:protocolData.serviceUUID characteristicUUID:protocolData.characteristicUUID data:protocolData.data device:bleDevice];
    }
}

- (void)publicScaleChangeToScaleState:(QNPScaleState)scaleState connectedDevice:(QNPScaleDevice *)device errCode:(NSInteger)errCode error:(NSError *)error {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    QNScaleState qnScaleState = QNScaleStateDisconnected;
    QNScaleEvent qnScaleEvent = 0;
    switch (scaleState) {
        case QNPScaleStateConnecting:
            qnScaleState = QNScaleStateConnecting;
            if (QNDelegate(self.connectionChangeListener,onConnecting:)) {
                [self.connectionChangeListener onConnecting:bleDevice];
            }
            break;
            
        case QNPScaleStateConnectFail:
            qnScaleState = QNScaleStateLinkLoss;
            self.connectDeviceFlag = NO;
            if (QNDelegate(self.connectionChangeListener,onConnectError:error:)) {
                [self.connectionChangeListener onConnectError:bleDevice error:[NSError errorForQNBLEModuleError:error]];
            }
            break;
            
        case QNPScaleStateConnected:
            qnScaleState = QNScaleStateConnected;
            if (QNDelegate(self.connectionChangeListener,onConnected:)) {
                [self.connectionChangeListener onConnected:bleDevice];
            }
            break;
            
        case QNPScaleStateDiscoverServices:
            if (QNDelegate(self.connectionChangeListener,onServiceSearchComplete:)) {
                [self.connectionChangeListener onServiceSearchComplete:bleDevice];
            }
            break;
            
        case QNPScaleStateDiscoverCharacteristics:
            
            break;
            
        case QNPScaleStateConfirmDeviceMode:
            qnScaleState = QNScaleStateStartMeasure;
            break;
            
        case QNPScaleStateWifiStartNetwork:
            qnScaleState = QNScaleStateWiFiBleStartNetwork;
            qnScaleEvent = QNScaleEventWiFiBleStartNetwork;
            break;
            
        case QNPScaleStateWifiNetworkSuccess:
            qnScaleState = QNScaleStateWiFiBleNetworkSuccess;
            qnScaleEvent = QNScaleEventWiFiBleNetworkSuccess;
            break;
            
        case QNPScaleStateWifiNetworkFail:
            qnScaleState = QNScaleStateWiFiBleNetworkFail;
            qnScaleEvent = QNScaleEventWiFiBleNetworkFail;
            break;
            
        case QNPScaleStateRealTime:
            qnScaleState = QNScaleStateRealTime;
            break;
            
        case QNPScaleStateBodyFat:
            qnScaleState = QNScaleStateBodyFat;
            break;
            
        case QNPScaleStateHeartRate:
            qnScaleState = QNScaleStateHeartRate;
            break;
            
        case QNPScaleStateMeasureComplete:
            qnScaleState = QNScaleStateMeasureCompleted;
            if (QNDelegate(self.connectionChangeListener,onDisconnecting:)) {
                [self.connectionChangeListener onDisconnecting:bleDevice];
            }
            break;
            
        case QNPScaleStateDisconected:
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



@end
