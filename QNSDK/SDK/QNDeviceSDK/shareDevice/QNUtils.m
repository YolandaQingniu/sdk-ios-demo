//
//  QNUtils.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/1/27.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "QNUtils.h"
#import "QNDataTool.h"
#import "NSError+QNAPI.h"
#import "QNUser+QNAddition.h"
#import "QNShareDecode.h"
#import "QNDataCypher.h"
#import "QNBleDevice+QNAddition.h"
#import "QNScaleData+QNAddition.h"
#import "QNDeviceTool.h"

@implementation QNShareData : NSObject

@end

@implementation QNUtils

+ (QNShareData *)decodeShareDataWithCode:(NSString *)qnCode user:(QNUser *)user validTime:(long)validTime callblock:(QNResultCallback)callblock{
    NSError *checkoutError = [[QNAuthInfo sharedAuthInfo] checkUseAuth];
    if (checkoutError) {
        //不允许使用
        [NSError errorCode:checkoutError.code callBack:callblock];
        return nil;
    }
    
    if (validTime < 0) {
        [NSError errorCode:QNBleErrorCodeIllegalArgument callBack:callblock];
        return nil;
    }
    
    NSError *userError = [user checkUserInfo];
    if (userError) {
        [NSError errorCode:userError.code callBack:callblock];
        return nil;
    }
    
    QNDecodeResult *decodeResult = [QNShareDecode decodeWithCodeStr:qnCode validTime:validTime];
    
    if (decodeResult.error != nil) {
        if (callblock) callblock(decodeResult.error);
        return nil;
    }
    
    QNAuthDevice *deviceInfo = [QNDeviceTool getShareDeviceInfo];
    QNDataCypher *dataCypher = [QNDataCypher buildCypherWithWeight:decodeResult.weight res:decodeResult.resistance secRes:decodeResult.secResistance timeTemp:decodeResult.measureTime device:deviceInfo heartRate:0];
    
    QNScaleData *scaleData = [QNScaleData buildDataCypher:dataCypher user:user isCallCalculate:YES];

    QNShareData *sharedData = [[QNShareData alloc] init];
    [sharedData setValue:decodeResult.sn forKeyPath:@"sn"];
    [sharedData setValue:scaleData forKeyPath:@"scaleData"];
    return  sharedData;
}

+ (QNShareData *)decodeShareDataWithCode:(NSString *)qnCode user:(QNUser *)user callblock:(QNResultCallback)callblock {
    return [self decodeShareDataWithCode:qnCode user:user validTime:0 callblock:callblock];
}

@end
