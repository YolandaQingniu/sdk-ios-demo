//
//  QNConfig.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/27.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNConfig.h"
#import "QNConfig+QNAddition.h"

@interface QNConfig ()


@end

@implementation QNConfig

- (void)setOnlyScreenOn:(BOOL)onlyScreenOn {
    _onlyScreenOn = onlyScreenOn;
}

- (void)setAllowDuplicates:(BOOL)allowDuplicates {
    _allowDuplicates = allowDuplicates;
}

- (void)setDuration:(int)duration {
    if ((duration > 0 && duration < 3000) || duration < 0) {
        duration = 0;
    }
    _duration = duration;
}

- (void)setUnit:(QNUnit)unit {
    _unit = unit;
}

- (void)setShowPowerAlertKey:(BOOL)showPowerAlertKey {
    _showPowerAlertKey = showPowerAlertKey;
}

- (void)setEnhanceBleBoradcast:(BOOL)enhanceBleBoradcast {
    _enhanceBleBoradcast = enhanceBleBoradcast;
}

- (BOOL)save {
    [self.lock lock];
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[QNFileManageConfigOnlyScreenOn] = [NSNumber numberWithBool:self.onlyScreenOn];
    json[QNFileManageConfigAllowDuplicates] = [NSNumber numberWithBool:self.allowDuplicates];
    json[QNFileManageConfigDuration] = [NSNumber numberWithInt:self.duration];
    json[QNFileManageConfigUnit] = [NSNumber numberWithInteger:self.unit];
    json[QNFileManageConfigShowPowerAlertKey] = [NSNumber numberWithBool:self.showPowerAlertKey];
    json[QNFileManageConfigEnhanceBleBroadcastKey] = [NSNumber numberWithBool:self.enhanceBleBoradcast];
    BOOL result = [json writeToFile:self.configPath atomically:YES];
    [self.lock unlock];
   return result;
}

@end
