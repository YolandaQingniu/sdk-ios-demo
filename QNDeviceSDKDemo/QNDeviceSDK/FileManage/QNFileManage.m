//
//  QNFileManage.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/12.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNFileManage.h"
#import "QNAESCrypt.h"
#import "QNDataTool.h"

#define QNFileName @"QNDeviceSDK"
#define QNPrivateDataCryptPassword @"mmpyfqingniu"//sdk私有数据加密的密码
#define QNBoolYesKey @"yes"
#define QNBoolNoKey @"no"


@interface QNFileManage ()

@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, strong) QNSDKConfig *sdkConfigCache;

@property (nonatomic, strong) NSString *appidCache;

@property (nonatomic, strong) QNConfig *configCache;

@end

@implementation QNFileManage
#define QNEncrypt(str) [QNAESCrypt encrypt:str password:QNPrivateDataCryptPassword]
#define QNDecrypt(str) [QNAESCrypt decrypt:str password:QNPrivateDataCryptPassword]


static QNFileManage *qnfileManager = nil;
#define QNFileManageConfigOnlyScreenOn @"onlyScreenOn"
#define QNFileManageConfigAllowDuplicates @"allowDuplicates"
#define QNFileManageConfigDuration @"duration"
#define QNFileManageConfigUnit @"unit"
#define QNFileManageConfigShowPowerAlertKey @"showPowerAlertKey"

+ (QNFileManage *)sharedFileManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        qnfileManager = [QNFileManage alloc];
    });
    return qnfileManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        qnfileManager = [[super allocWithZone:zone] init];
    });
    return qnfileManager;
}

- (instancetype)init {
    if (self = [super init]) {
        if (self.filePath == nil) {
            NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            self.filePath = [documentPath stringByAppendingPathComponent:QNFileName];
            if ([self fileExistsAtPath:self.filePath] == NO) {
                [self.fileManager createDirectoryAtPath:self.filePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
    }
    return self;
}

- (NSFileManager *)fileManager {
    if (_fileManager == nil) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

- (BOOL)fileExistsAtPath:(NSString *)filePath {
    return [self.fileManager fileExistsAtPath:filePath];
}

#pragma mark - SDK操作配置信息
- (void)updateConfig:(QNConfig *)config {
    if (![config isKindOfClass:[QNConfig class]]) {
        return;
    }
    NSLock *locak = [[NSLock alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [locak lock];
        NSMutableDictionary *configDic = [NSMutableDictionary dictionary];
        [configDic setObject:[NSNumber numberWithBool:config.onlyScreenOn] forKey:QNFileManageConfigOnlyScreenOn];
        [configDic setObject:[NSNumber numberWithBool:config.allowDuplicates] forKey:QNFileManageConfigAllowDuplicates];
        [configDic setObject:[NSNumber numberWithInt:config.duration] forKey:QNFileManageConfigDuration];
        [configDic setObject:[NSNumber numberWithUnsignedInteger:config.unit] forKey:QNFileManageConfigUnit];
        [configDic setObject:[NSNumber numberWithBool:config.showPowerAlertKey] forKey:QNFileManageConfigShowPowerAlertKey];
        [configDic writeToFile:[self configFilePath] atomically:YES];
        [locak unlock];
    });
}


- (QNConfig *)config {
    if (self.configCache == nil) {
        QNConfig *config = [[QNConfig alloc] init];
        if (![self fileExistsAtPath:[self configFilePath]]) {
            config.onlyScreenOn = NO;
            config.allowDuplicates = NO;
            config.duration = 0;
            config.unit = QNUnitKG;
            config.showPowerAlertKey = NO;
            [self updateConfig:config];
        }else{
            NSDictionary *configDic = [NSMutableDictionary dictionaryWithContentsOfFile:[self configFilePath]];
            config.onlyScreenOn = [[configDic valueForKey:QNFileManageConfigOnlyScreenOn] boolValue];
            config.allowDuplicates = [[configDic valueForKey:QNFileManageConfigAllowDuplicates] boolValue];
            config.duration = [[configDic valueForKey:QNFileManageConfigDuration] intValue];
            config.unit = [[configDic valueForKey:QNFileManageConfigUnit] unsignedIntegerValue];
            config.showPowerAlertKey = [[configDic valueForKey:QNFileManageConfigShowPowerAlertKey] boolValue];
        }
        self.configCache = config;
    }
    return self.configCache;
}

- (NSString *)configFilePath {
    return [self.filePath stringByAppendingPathComponent:@"qnConfig.plist"];
}


#pragma mark -
#pragma mark 将sdk配置信息写入磁盘
- (BOOL)updateSdkConfigForDic:(NSDictionary *)dic {
    return [self updateDiskSdkConfig:[dic mutableCopy]];
}

- (BOOL)updateSdkConfigForFilePath:(NSString *)filePath {
    if (![self fileExistsAtPath:filePath]) {
        return NO;
    }
    NSError *error = nil;
    NSString *encryptStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    encryptStr = [encryptStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (error || encryptStr == nil || encryptStr.length == 0) {
        return NO;
    }
    NSString *decrypt = [QNAESCrypt AES128Decrypt:encryptStr];
    if (decrypt == nil) {
        return NO;
    }
    NSDictionary *sdkConfigDic = [[QNDataTool sharedDataTool] jsonTodictionary:decrypt];
    if ([sdkConfigDic.allKeys containsObject:@"app_id"]) {
        NSString *appid = [sdkConfigDic valueForKey:@"app_id"];
        if (appid != nil && [appid isKindOfClass:[NSString class]] && appid.length > 0) {
            [[QNFileManage sharedFileManager] updateVerifyAppid:appid];
        }
    }
    return [self updateSdkConfigForDic:sdkConfigDic];
}

#pragma mark 更新SDK配置信息
- (BOOL)updateDiskSdkConfig:(NSMutableDictionary *)dic {
    if (dic == nil || dic.allKeys.count == 0) {
        return NO;
    }
    NSInteger code = 0;
    if ([dic.allKeys containsObject:@"code"]) {
        code = [[QNDataTool sharedDataTool] toInteger:[dic valueForKey:@"code"]];
        if (code != 20000 && code != 50000) {
            return YES;
        }
    }
    NSDictionary *diskDic = [self sdkConfigFromDisk];
    if (code == 50000 && diskDic != nil) {
        dic = [diskDic mutableCopy];
        [dic setObject:[NSNumber numberWithInteger:50000] forKey:@"code"];
        [dic setObject:[NSNumber numberWithInteger:0] forKey:@"update_time_stamp"];
    }
    BOOL isNeedUpdate = NO;
    if (diskDic == nil || diskDic.allKeys.count == 0) {
        isNeedUpdate = YES;
    }else {
        NSInteger code = [[QNDataTool sharedDataTool] toInteger:[dic valueForKey:@"code"]];
        NSInteger diskUpdateTimeTemp = [[QNDataTool sharedDataTool] toInteger:[diskDic valueForKey:@"update_time_stamp"]];
        NSInteger prepareUpdateTimeTemp = [[QNDataTool sharedDataTool] toInteger:[dic valueForKey:@"update_time_stamp"]];
        NSString *appid = [dic valueForKey:@"app_id"];
        NSString *prepareAppid = [diskDic valueForKey:@"app_id"];
        if (([appid isEqualToString:self.appidCache] && ((prepareUpdateTimeTemp > diskUpdateTimeTemp) || code == 50000)) || ![appid isEqualToString:prepareAppid]) {
            isNeedUpdate = YES;
        }else {
            isNeedUpdate = NO;
        }
    }
    if (isNeedUpdate == NO) {
        return YES;
    }else {
        self.sdkConfigCache = [QNSDKConfig sdkConfigDic:dic];
        NSString *json = [[QNDataTool sharedDataTool] dictionaryToJson:dic];
        if (json == nil || json.length == 0) {
            return NO;
        }else {
            NSString *encrypt = [QNAESCrypt encrypt:json password:QNPrivateDataCryptPassword];
            if (encrypt == nil || encrypt.length == 0) {
                return NO;
            }else {
                NSError *error = nil;
                [encrypt writeToFile:[self sdkConifgFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
                return YES;
            }
        }
    }
}

#pragma mark 从磁盘中读取SDK配置信息
- (NSDictionary *)sdkConfigFromDisk {
    NSString *configFilePath = [self sdkConifgFilePath];
    if (![self fileExistsAtPath:configFilePath]) {
        return nil;
    }
    NSError *error = nil;
    NSString *encryptStr = [NSString stringWithContentsOfFile:configFilePath encoding:NSUTF8StringEncoding error:&error];
    if (error != nil || encryptStr == nil) {
        return nil;
    }
    NSString *decrypt = [QNAESCrypt decrypt:encryptStr password:QNPrivateDataCryptPassword];
    if (decrypt == nil) {
        return nil;
    }
    NSDictionary *dic = [[QNDataTool sharedDataTool] jsonTodictionary:decrypt];
    if (dic) {
        return dic;
    }else {
        return nil;
    }
}

#pragma mark 获取sdk配置对象
- (QNSDKConfig *)sdkConfig{
    if (self.sdkConfigCache == nil) {
        NSDictionary *dic = [self sdkConfigFromDisk];
        self.sdkConfigCache = [QNSDKConfig sdkConfigDic:dic];
        return self.sdkConfigCache;
    }
    return self.sdkConfigCache;
}

- (NSString *)sdkConifgFilePath {
    return [self.filePath stringByAppendingPathComponent:@"QNADM.abc"];
}

#pragma mark - 需要验证的appid
- (BOOL)updateVerifyAppid:(NSString *)appid {
    if (![appid isKindOfClass:[NSString class]] || appid.length == 0) {
        return NO;
    }
    BOOL isNeedUpdate = NO;
    if (self.appidCache == nil || self.appidCache.length == 0 || ![appid isEqualToString:self.appidCache]) {
        isNeedUpdate = YES;
    }else{
        isNeedUpdate = NO;
    }
    if (isNeedUpdate == NO) {
        return YES;
    }else {
        self.appidCache = appid;
        NSString *encryptAppid = [QNAESCrypt encrypt:appid password:QNPrivateDataCryptPassword];
        if (encryptAppid != nil && encryptAppid.length) {
            NSError *error = nil;
            [encryptAppid writeToFile:[self verifyAppidFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
        }
        return YES;
    }
}

- (NSString *)verifyAppid {
    if (self.appidCache != nil) {
        return self.appidCache;
    }else {
        if ([self fileExistsAtPath:[self verifyAppidFilePath]]) {
            NSString *encryptAppid = [NSString stringWithContentsOfFile:[self verifyAppidFilePath] encoding:NSUTF8StringEncoding error:nil];
            if (encryptAppid == nil) {
                return nil;
            }else{
                NSString *appidStr = [QNAESCrypt decrypt:encryptAppid password:QNPrivateDataCryptPassword];
                if (appidStr && appidStr.length) {
                    self.appidCache = appidStr;
                    return appidStr;
                }else {
                    return nil;
                }
            }
        }
        return nil;
    }
}

- (NSString *)verifyAppidFilePath {
    return [self.filePath stringByAppendingPathComponent:@"QNAPD.abc"];
}

#pragma mark - 更新时间
- (NSInteger)lastRequestUpdateSDKConfigFromServiceTime {
    if (![self fileExistsAtPath:[self updateSdkConfigTimeFilePath]]) {
        return 0;
    }else {
        NSError *error = nil;
        NSString *encryptTime = [NSString stringWithContentsOfFile:[self updateSdkConfigTimeFilePath] encoding:NSUTF8StringEncoding error:&error];
        if (encryptTime == nil || error || encryptTime.length == 0) {
            return 0;
        }else {
            NSString *decryptTime = [QNAESCrypt decrypt:encryptTime password:QNPrivateDataCryptPassword];
            if (decryptTime == nil || decryptTime.length == 0) {
                return 0;
            }else {
                return [decryptTime integerValue];
            }
        }
    }
}

- (void)saveRequsetUpdateSdkConfigTime:(NSInteger)time{
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)time];
    NSString *encryptTime = [QNAESCrypt encrypt:timeStr password:QNPrivateDataCryptPassword];
    if (encryptTime && encryptTime.length) {
        [encryptTime writeToFile:[self updateSdkConfigTimeFilePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (NSString *)updateSdkConfigTimeFilePath {
    return [self.filePath stringByAppendingPathComponent:@"QNUPT.abc"];
}

@end
