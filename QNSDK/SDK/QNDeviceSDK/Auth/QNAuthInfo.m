//
//  QNAuthInfo.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/2/24.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNAuthInfo.h"
#import "QNAESCrypt.h"
#import "QNDataTool.h"
#import "NSError+QNAPI.h"

@interface QNAuthInfo ()

@property(nonatomic, strong) NSString *configPath;
@property(nonatomic, strong) NSLock *lock;
@end

@implementation QNAuthInfo
static QNAuthInfo *_authInfo;

+ (QNAuthInfo *)sharedAuthInfo {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _authInfo = [QNAuthInfo alloc];
    });
    return _authInfo;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _authInfo = [[super allocWithZone:zone] init];
    });
    return _authInfo;
}

- (instancetype)init {
    if (self = [super init]) {
        self.configPath = [[QNDataTool sharedDataTool].sdkFilePath stringByAppendingPathComponent:@"QNADM.abc"];
    }
    return self;
}

#pragma mark -
- (NSInteger)dayNumSince1970 {
    NSTimeInterval timerIntercal = [[NSDate date] timeIntervalSince1970];
    return floor(timerIntercal / (3600 * 24));
}


#pragma mark - 
- (BOOL)updateAuthInfoWithEncryptInfo:(NSString *)encryptInfo{
    if (encryptInfo.length == 0) return NO;

    encryptInfo = [encryptInfo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (encryptInfo.length == 0) return NO;
    
    NSString *authInfo= [QNAESCrypt AES128Decrypt:encryptInfo];
    if (authInfo.length == 0) return NO;
    NSDictionary *authJson = [[QNDataTool sharedDataTool] jsonTodictionary:authInfo];
    return [self updateAuthInfoWithJson:authJson];
}

- (void)askAuthInfoWithMethodAppid:(NSString *)methodAppid {
    self.methodAppid = methodAppid;
    if (self.appid != nil) return;
    
    NSError *error = nil;
    NSString *encryptInfo = [NSString stringWithContentsOfFile:self.configPath encoding:NSUTF8StringEncoding error:&error];
    [self updateAuthInfoWithEncryptInfo:encryptInfo];
}


- (BOOL)updateAuthInfoWithJson:(NSDictionary *)json {
     if (json == nil) return NO;
    [self.lock lock];
    NSString *jsonAppid = [[QNDataTool sharedDataTool] toString:[json valueForKey:@"app_id"]];
    //验证appid是否正确
    if ([jsonAppid isEqualToString:self.methodAppid] == NO) {
        [self.lock unlock];
        return NO;
    }
    
    NSInteger code = [[QNDataTool sharedDataTool] toInteger:[json valueForKey:@"code"]];
    
    //初始化
    if (self.appid == nil) {
        if (code == 20000) {
            [self analysisJsonData:json];
            [self.lock unlock];
            return YES;
        } else {
            [self.lock unlock];
            return NO;
        }
    }
    
    //更新操作
    if (code == 20001) { //无需更新
        [self.lock unlock];
        return YES;
    }
    
    NSInteger updateTime = [[QNDataTool sharedDataTool] toInteger:[json valueForKey:@"update_time_stamp"]];
    if (self.updateTimeStamp >= updateTime) {
        [self.lock unlock];
        return NO;
    }
    
    [self analysisJsonData:json];
    return YES;
}

- (void)analysisJsonData:(NSDictionary *)json {
    self.appid = [[QNDataTool sharedDataTool] toString:[json valueForKey:@"app_id"]];
    self.code = [[QNDataTool sharedDataTool] toInteger:[json valueForKey:@"code"]];
    self.serverType = [[QNDataTool sharedDataTool] toInteger:[json valueForKey:@"server_type"]];
    
    NSMutableArray *packages = [NSMutableArray array];
    NSArray *packageList = [[[QNDataTool sharedDataTool] toString:[json valueForKey:@"package_name_array"]] componentsSeparatedByString:@","];
    for (NSString *item in packageList) {
        NSString *package = [item stringByReplacingOccurrencesOfString:@"," withString:@""];
        if (package.length > 0) {
            [packages addObject:item];
        }
    }
    self.packages = packages;
    
    
    self.connectOtherFlag = [[QNDataTool sharedDataTool] toInteger:[json valueForKey:@"connect_other"]];
    self.defaultModel = [[QNDataTool sharedDataTool] toString:[json valueForKey:@"default_model"]];
    self.defaultMethod = [[QNDataTool sharedDataTool] toInteger:[json valueForKey:@"default_method"]];
    self.defaultIndexFlag = [[QNDataTool sharedDataTool] toInteger:[json valueForKey:@"default_index_flag"]];
    self.updateTimeStamp = [[QNDataTool sharedDataTool] toInteger:[json valueForKey:@"update_time_stamp"]];
    self.defaultAddTargetFlag = [[QNDataTool sharedDataTool] toInteger:[json valueForKey:@"default_added_flag"]];
    
    NSMutableArray<QNAuthDevice *> *deviceInfoList = [NSMutableArray array];
    NSArray *modelList = [json valueForKey:@"models"];
    for (NSDictionary *item in modelList) {
        QNAuthDevice *device = [[QNAuthDevice alloc] init];
        device.model = [[QNDataTool sharedDataTool] toString:[item valueForKey:@"model"]];
        device.method = [[QNDataTool sharedDataTool] toInteger:[item valueForKey:@"method"]];
        device.internalModel = [[QNDataTool sharedDataTool] toString:[item valueForKey:@"internal_model"]];
        
        device.bodyIndexFlag = [[QNDataTool sharedDataTool] toInteger:[item valueForKey:@"body_index_flag"]];
        device.otherTargetFlag = [[QNDataTool sharedDataTool] toInteger:[item valueForKey:@"added_index_flag"]];
        [deviceInfoList addObject:device];
    }
    self.authDevices = deviceInfoList;
    
    NSString *writeJson = [[QNDataTool sharedDataTool] dictionaryToJson:json];
    if (writeJson.length == 0) return;
    NSString *encryptJson = [QNAESCrypt encrypt:writeJson password:QNDataCryptPassword];
    if (encryptJson.length == 0) return;
    
    NSError *error = nil;
    [encryptJson writeToFile:self.configPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}


#pragma mark -
- (NSError *)checkUseAuth {
    if (self.methodAppid == nil || self.appid == nil) {
        return [NSError errorCode:QNBleErrorCodeInitFile];
    }
    
    if ([self.methodAppid isEqualToString:self.appid] == NO) {
        return [NSError errorCode:QNBleErrorCodeInvalidateAppId];
    }
    
    BOOL bundleIdentifilyFlag = YES;
    if (self.packages.count) {
        bundleIdentifilyFlag = NO;
        NSString *currentAppIdentifily = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleIdentifier"];
        for (NSString *package in self.packages) {
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

@end
