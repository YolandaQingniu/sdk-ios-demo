//
//  QNDataTool.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/4/26.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNDataTool.h"
#import "QNFileManage.h"
#import "NSError+QNAPI.h"

static QNDataTool *dataTool = nil;

@interface QNDataTool ()

@end

@implementation QNDataTool

+ (QNDataTool *)sharedDataTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataTool = [QNDataTool alloc];
    });
    return dataTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataTool = [[super allocWithZone:zone] init];
    });
    return dataTool;
}

#pragma mark -
- (NSString *)dictionaryToJson:(NSDictionary *)dictionary {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

- (NSDictionary *)jsonTodictionary:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        return nil;
    }
    return dic;
}

#pragma mark -
- (NSString *)toString:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        return str;
    }else{
        return nil;
    }
}

- (NSInteger)toInteger:(id)obj {
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj integerValue];
    }else if ([obj isKindOfClass:[NSString class]]) {
        return [obj integerValue];
    }else{
        return 0;
    }
}

#pragma mark - 验证是否有权限使用SDK
- (NSError *)checkoutUseLimit {
    NSString *vailyAppid = [[QNFileManage sharedFileManager] verifyAppid];
    if (vailyAppid == nil) {
        return  [NSError errorCode:QNBleErrorCodeInvalidateAppId];
    }
    QNSDKConfig *sdkConfig = [[QNFileManage sharedFileManager] sdkConfig];
    if (sdkConfig == nil) {
        return [NSError errorCode:QNBleErrorCodeInitFile];
    }
    
    if (![vailyAppid isEqualToString:sdkConfig.appid] || sdkConfig.code == 50000) {
        return  [NSError errorCode:QNBleErrorCodeInvalidateAppId];
    }
    
    BOOL bundleIdentifilyFlag = YES;
    if (sdkConfig.packages.count) {
        bundleIdentifilyFlag = NO;
        NSString *currentAppIdentifily = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleIdentifier"];
        for (NSString *package in sdkConfig.packages) {
            if ([package isEqualToString:currentAppIdentifily]) {
                bundleIdentifilyFlag = YES;
                break;
            }
        }
    }
    if (bundleIdentifilyFlag) {
        return nil;
    }else{
        return [NSError errorCode:QNBleErrorCodeBundleID];
    }
}

- (NSInteger)currentDaynumSince1970 {
    NSTimeInterval timerIntercal = [[NSDate date] timeIntervalSince1970];
    return floor(timerIntercal / (3600 * 24));
}

@end
