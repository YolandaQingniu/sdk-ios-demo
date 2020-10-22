//
//  QNBleBroadcastDevice.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/7/11.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "QNBleBroadcastDevice.h"
#import "QNBleBroadcastDevice+QNAddition.h"
#import "QNScaleData+QNAddition.h"
#import "QNUser+QNAddition.h"
#import "NSError+QNAPI.h"
#import "QNAdvertScaleModule.h"
#import "QNConfig+QNAddition.h"
#import "QNAuthInfo.h"
#import "QNDeviceTool.h"

@implementation QNBleBroadcastDevice

- (QNScaleData *)generateScaleDataWithUser:(QNUser *)user callback:(QNResultCallback)callback {
    
    if (self.isComplete == NO) {
        [NSError errorCode:QNBleErrorCodeNoComoleteMeasure callBack:callback];
        return nil;
    }
    
    NSError *userError = [user checkUserInfo];

    if (userError) {
        [NSError errorCode:userError.code callBack:callback];
        return nil;
    }
    
    QNAuthDevice *authDevice = [QNDeviceTool getDeviceInfoWithInternalModel:self.modeId];
    if (authDevice == nil) {
        [NSError errorCode:QNBleErrorCodeIllegalArgument callBack:callback];
        return nil;
    }
    
    
    QNDataCypher *dateCypher = [QNDataCypher buildCypherWithWeight:self.weight res:self.res secRes:0 timeTemp:self.timeTemp device:authDevice heartRate:0];
    [dateCypher calculateMeasureDataWithUser:user];
    
    return [QNScaleData buildDataCypher:dateCypher user:user isCallCalculate:YES];
}

- (void)syncUnitCallback:(QNResultCallback)callback {
    if (self.supportUnitChange == NO || self.advertDevice == nil) {
        [NSError errorCode:QNBleErrorCodeNoSupportModify callBack:callback];
        return;
    }
    
    QNConfig *config = [QNConfig sharedConfig];
    QNAdvertScaleUnitMode mode = QNAdvertScaleUnitKG;
    switch (config.unit) {
        case QNUnitLB: mode = QNAdvertScaleUnitLB; break;
        case QNUnitJIN: mode = QNAdvertScaleUnitJin; break;
        case QNUnitST: mode = QNAdvertScaleUnitLB; break;
        default:
            mode = QNAdvertScaleUnitKG;
            break;
    }
    
    [[QNAdvertScaleManager sharedAdvertScaleManager] setScaleUnit:mode device:self.advertDevice response:nil];
}

@end
