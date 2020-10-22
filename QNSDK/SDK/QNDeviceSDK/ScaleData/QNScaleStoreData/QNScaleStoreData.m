//
//  QNScaleStoreData.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNScaleStoreData.h"
#import "QNScaleStoreData+QNAddition.h"
#import "QNScaleData+QNAddition.h"
#import "QNAESCrypt.h"
#import "QNDataTool.h"
#import "NSError+QNAPI.h"
#import "QNDebug.h"
#import "QNDeviceTool.h"

@implementation QNScaleStoreData
@synthesize hmac = _hmac;

- (BOOL)setUser:(QNUser *)user {
    if (self.isDataComplete) {
        return NO;
    }
    self.userData = user;
    return YES;
}

- (NSString *)hmac {
    if (_hmac == nil) {
        if (self.dataCypher == nil) return nil;
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSMutableDictionary *hmacJson = [NSMutableDictionary dictionary];
        hmacJson[@"heart_rate"] = [NSNumber numberWithUnsignedInteger:self.dataCypher.heartRate];
        hmacJson[@"model_id"] = self.dataCypher.authDevice.internalModel;
        hmacJson[@"measure_time"] = [dateformatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.dataCypher.timeTemp]];
        hmacJson[@"mac"] = self.mac;
        hmacJson[@"resistance_50"] = [NSNumber numberWithUnsignedInteger:self.dataCypher.resistance];
        hmacJson[@"resistance_500"] = [NSNumber numberWithUnsignedInteger:self.dataCypher.secResistance];
        hmacJson[@"weight"] = [NSNumber numberWithInt:self.dataCypher.weight];

        _hmac = [QNAESCrypt AES128Encrypt:[[QNDataTool sharedDataTool] dictionaryToJson:hmacJson]];
    }
    return _hmac;
}

- (QNScaleData *)generateScaleData {
    if (self.userData == nil) return nil;
    return [QNScaleData buildDataCypher:self.dataCypher user:self.userData isCallCalculate:YES];
}

+ (QNScaleStoreData *)buildStoreDataWithWeight:(double)weight measureTime:(NSDate *)measureTime mac:(NSString *)mac hmac:(NSString *)hmac callBlock:(QNResultCallback)callback {
    NSString *decrypt = [QNAESCrypt AES128Decrypt:hmac];
    NSDictionary *resultDic = [[QNDataTool sharedDataTool] jsonTodictionary:decrypt];
    
    if (resultDic == nil) {
        [NSError errorCode:QNBleErrorCodeIllegalArgument callBack:callback];
        return nil;
    }
    
    NSInteger heartRate = [[QNDataTool sharedDataTool] toInteger:resultDic[@"heart_rate"]];
    NSString *internalModel = [[QNDataTool sharedDataTool] toString:resultDic[@"model_id"]];
    NSString *measureDate = [[QNDataTool sharedDataTool] toString:resultDic[@"measure_time"]];
    NSString *deviceMac = [[QNDataTool sharedDataTool] toString:resultDic[@"mac"]];
    NSInteger res = [[QNDataTool sharedDataTool] toInteger:resultDic[@"resistance_50"]];
    NSInteger secRes = [[QNDataTool sharedDataTool] toInteger:resultDic[@"resistance_500"]];
    double hweight = [[QNDataTool sharedDataTool] toDouble:resultDic[@"weight"]];
    QNAuthDevice *device = [QNDeviceTool getDeviceInfoWithInternalModel:internalModel];

    NSDate *date = nil;
    if ([measureDate containsString:@"-"]) {
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date = [dateformatter dateFromString:measureDate];
    } else if ([resultDic[@"measure_time"] isKindOfClass:[NSNumber class]]) {
        NSInteger timeStamp = [resultDic[@"measure_time"] integerValue];
        date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    }

    bool noVail = fabs(weight - hweight) > 0.0001 || mac.length == 0 || internalModel.length == 0 || deviceMac == nil || [mac.uppercaseString isEqualToString:deviceMac.uppercaseString] == NO || date == nil || [date timeIntervalSinceDate:measureTime] > 0 || device == nil;
    if (noVail) {
        if (QNDebugLogIsVail) {
            NSString *log = [NSString stringWithFormat:@"weight: %f measureTime: %@ mac: %@ hmac: %@", weight, measureDate, mac,hmac];
            [[QNDebug sharedDebug] log:log];
        }
        [NSError errorCode:QNBleErrorCodeIllegalArgument callBack:callback];
        return nil;
    }
    
    QNScaleStoreData *scaleStoreData = [[QNScaleStoreData alloc] init];
    QNDataCypher *dataCypher = [QNDataCypher buildCypherWithWeight:weight res:res secRes:secRes timeTemp:[date timeIntervalSince1970] device:device heartRate:heartRate];
    scaleStoreData.dataCypher = dataCypher;
    
    [scaleStoreData setValue:[NSNumber numberWithDouble:hweight] forKeyPath:@"weight"];
    [scaleStoreData setValue:mac forKeyPath:@"mac"];
    if (date) {
        [scaleStoreData setValue:date forKeyPath:@"measureTime"];
    }
    return scaleStoreData;
}

@end
