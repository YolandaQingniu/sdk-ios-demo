//
//  QNBleApi+WspDevice.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/2/26.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNBleApi+WspDevice.h"
#import "QNWspScaleDataProtocol.h"

@implementation QNBleApi (WspDevice)
static char QNBleApi_wspManager;

- (void)setWspManager:(QNWspManager *)wspManager {
    objc_setAssociatedObject(self, &QNBleApi_wspManager, wspManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNWspManager *)wspManager {
    return objc_getAssociatedObject(self, &QNBleApi_wspManager);
}

#pragma mark - 
- (void)wspScaleReceiveRealTimeWeight:(double)weight connectedDevice:(QNWspDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    [self handleRealTimeWeight:weight connectDevice:bleDevice];
}

- (void)receiveWspSn:(NSString *)sn connectedDevice:(QNWspDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    if (QNDelegate(self.dataListener,wspReadSnComplete:sn:)) {
        id<QNWspScaleDataListener> wspDataDelegate = (id<QNWspScaleDataListener>)self.dataListener;
        [wspDataDelegate wspReadSnComplete:bleDevice sn:sn];
    }
}

- (void)wspScaleReceiveWeightCompleteData:(double)weight connectedDevice:(QNWspDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    [self handleRealTimeWeight:weight connectDevice:bleDevice];
}

- (void)wspScaleReceiveResultData:(QNWspScaleData *)scaleData connectedDevice:(QNWspDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    if (self.storageAll.count > 0) {
        [self receiveStorageDataCompleteWithMac:device.mac];
    }
    
    QNDataCypher *dataCypher = [QNDataCypher buildCypherWithWeight:scaleData.weight res:scaleData.resistance secRes:scaleData.secResistance timeTemp:scaleData.timeStamp device:bleDevice.authDevice heartRate:scaleData.heartRate];
    
    dataCypher.BMI = scaleData.bmi;
    dataCypher.bodyfatRate = scaleData.bodyFat;
    dataCypher.subcutaneousFat = scaleData.subFat;
    dataCypher.visceralFat = scaleData.visfat;
    dataCypher.bodyWaterRate = scaleData.water;
    dataCypher.muscleRate = scaleData.muscle;
    dataCypher.boneMass = scaleData.bone;
    dataCypher.BMR = scaleData.bmr;
    dataCypher.bodyType = (int)scaleData.bodyShape;
    dataCypher.protein = scaleData.protein;
    dataCypher.leanBodyWeight = scaleData.fatFreeWeight;
    dataCypher.muscleMass = scaleData.sinew;
    dataCypher.metabolicAge = scaleData.bodyage;
    dataCypher.healthScore = scaleData.bodyScore;
    dataCypher.heartIndex = scaleData.cardiacIndex;
    [dataCypher calculateWspMeasureDataWithUser:bleDevice.user];
    [self handleResultDataCypher:dataCypher connectDevice:bleDevice isCalculate:NO];
}

- (void)wspScaleReceiveStorageData:(QNWspScaleData *)storageData connectedDevice:(QNWspDevice *)device {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    QNDataCypher *dataCypher = [QNDataCypher buildCypherWithWeight:storageData.weight res:storageData.resistance secRes:storageData.secResistance timeTemp:storageData.timeStamp device:bleDevice.authDevice heartRate:storageData.heartRate];
    if (storageData.unknowFlag) {
        //未知测量数据
        [self handleStoragDataCypher:dataCypher connectDevice:bleDevice user:nil isComplete:NO];
        return;
    }
    
    //已知测量数据
    dataCypher.BMI = storageData.bmi;
    dataCypher.bodyfatRate = storageData.bodyFat;
    dataCypher.subcutaneousFat = storageData.subFat;
    dataCypher.visceralFat = storageData.visfat;
    dataCypher.bodyWaterRate = storageData.water;
    dataCypher.muscleRate = storageData.muscle;
    dataCypher.boneMass = storageData.bone;
    dataCypher.BMR = storageData.bmr;
    dataCypher.bodyType = (int)storageData.bodyShape;
    dataCypher.protein = storageData.protein;
    dataCypher.leanBodyWeight = storageData.fatFreeWeight;
    dataCypher.muscleMass = storageData.sinew;
    dataCypher.metabolicAge = storageData.bodyage;
    dataCypher.healthScore = storageData.bodyScore;
    dataCypher.heartIndex = storageData.cardiacIndex;
    [dataCypher calculateWspMeasureDataWithUser:bleDevice.user];
    [self handleStoragDataCypher:dataCypher connectDevice:bleDevice user:bleDevice.user isComplete:NO];
}

- (void)wspScaleChangeToScaleState:(QNWspScaleState)scaleState user:(QNWspUser *)user connectedDevice:(QNWspDevice *)device errCode:(NSInteger)errCode error:(NSError *)error {
    QNBleDevice *bleDevice = [self getBleDeviceWithMac:device.mac];
    QNScaleState qnScaleState = QNScaleStateDisconnected;
    QNScaleEvent qnScaleEvent = 0;
    switch (scaleState) {
        case QNWspStateConnecting:
            qnScaleState = QNScaleStateConnecting;
            if (QNDelegate(self.connectionChangeListener, onConnecting:)) {
                [self.connectionChangeListener onConnecting:bleDevice];
            }
            break;
        
        case QNWspStatConnectFail:
            qnScaleState = QNScaleStateLinkLoss;
            self.connectDeviceFlag = NO;
            if (QNDelegate(self.connectionChangeListener, onConnectError:error:)) {
                [self.connectionChangeListener onConnectError:bleDevice error:error];
            }
            break;
            
        case QNWspStateConnected:
            qnScaleState = QNScaleStateConnected;
            if (QNDelegate(self.connectionChangeListener, onConnected:)) {
                [self.connectionChangeListener onConnected:bleDevice];
            }
            break;
            
        case QNWspStateDiscoverServices:
            if (QNDelegate(self.connectionChangeListener, onServiceSearchComplete:)) {
                [self.connectionChangeListener onServiceSearchComplete:bleDevice];
            }
            break;
            
        case QNWspStateDiscoverCharacteristics:
            break;
            
        case QNWspStateObserverMeasureData:
            qnScaleState = QNScaleStateStartMeasure;
            break;
            
        case QNWspStateWiFiStartNetwork:
            qnScaleState = QNScaleStateWiFiBleStartNetwork;
            qnScaleEvent = QNScaleEventWiFiBleStartNetwork;
            break;
            
        case QNWspStateWiFiNetworkSuccess:
            qnScaleState = QNScaleStateWiFiBleNetworkSuccess;
            qnScaleEvent = QNScaleEventWiFiBleNetworkSuccess;
            break;
            
        case QNWspStateWiFiNetworkFail:
            qnScaleState = QNScaleStateWiFiBleNetworkFail;
            qnScaleEvent = QNScaleEventWiFiBleNetworkFail;
            break;
            
        case QNWspStateRealTimeWeight:
            qnScaleState = QNScaleStateRealTime;
            break;
            
        case QNWspStateMeasureBodyFat:
            qnScaleState = QNScaleStateBodyFat;
            break;
            
        case QNWspStateMeasureHeartReat:
            qnScaleState = QNScaleStateHeartRate;
            break;
            
        case QNWspStateMeasureComplete:
            qnScaleState = QNScaleStateMeasureCompleted;
            if (QNDelegate(self.connectionChangeListener,onDisconnecting:)) {
                [self.connectionChangeListener onDisconnecting:bleDevice];
            }
            break;
            
        case QNWspStateDisconected:
            qnScaleState = QNScaleStateLinkLoss;
            self.connectDeviceFlag = NO;
            [self cancelScanTimer];
            break;
         
        case QNWspStateRegistUserSuccess:
            qnScaleEvent = QNScaleEventRegistUserSuccess;
            if (QNDelegate(self.dataListener,wspRegisterUserComplete:user:)) {
                bleDevice.user.index = [user.secretIndex intValue];
                id<QNWspScaleDataListener> wspDataDelegate = (id<QNWspScaleDataListener>)self.dataListener;
                [wspDataDelegate wspRegisterUserComplete:bleDevice user:bleDevice.user];
            }
            break;
            
        case QNWspStateRegistUserFail:
            qnScaleEvent = QNScaleEventRegistUserFail;
            break;
            
        case QNWspStateVisitUserSuccess:
            qnScaleEvent = QNScaleEventVisitUserSuccess;
            break;
        
        case QNWspStateVisitUserFail:
            qnScaleEvent = QNScaleEventVisitUserFail;
            break;
            
        case QNWspStateSynUserInfoFail:
            qnScaleEvent = QNScaleEventSyncUserInfoFail;
            break;
            
        case QNWspStateSynUserInfoSuccess:
            qnScaleEvent = QNScaleEventSyncUserInfoSuccess;
            break;
        
        case QNWspStateDeleteUserSuccess:
            qnScaleEvent = QNScaleEventDeleteUserSuccess;
            break;
         
        case QNWspStateDeleteUserFail:
            qnScaleEvent = QNScaleEventDeleteUserFail;
            break;
            
        case QNWspStateSyncLocationSuccess:
            if (QNDelegate(self.dataListener,wspLocationSyncStatus:suceess:)) {
                id<QNWspScaleDataListener> wspDataDelegate = (id<QNWspScaleDataListener>)self.dataListener;
                [wspDataDelegate wspLocationSyncStatus:bleDevice suceess:YES];
            }
            break;
        case QNWspStateSyncLocationFail:
            if (QNDelegate(self.dataListener,wspLocationSyncStatus:suceess:)) {
                id<QNWspScaleDataListener> wspDataDelegate = (id<QNWspScaleDataListener>)self.dataListener;
                [wspDataDelegate wspLocationSyncStatus:bleDevice suceess:NO];
            }
            break;
            
        default:break;
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
