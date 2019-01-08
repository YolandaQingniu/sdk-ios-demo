//
//  QNConfig.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/27.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNConfig.h"
#import "QNFileManage.h"

@implementation QNConfig

- (void)setOnlyScreenOn:(BOOL)onlyScreenOn {
    _onlyScreenOn = onlyScreenOn;
    [[QNFileManage sharedFileManager] updateConfig:self];
}

- (void)setAllowDuplicates:(BOOL)allowDuplicates {
    _allowDuplicates = allowDuplicates;
    [[QNFileManage sharedFileManager] updateConfig:self];
}


- (void)setDuration:(int)duration {
    if ((duration > 0 && duration < 3000) || duration < 0) {
        duration = 0;
    }
    _duration = duration;
    [[QNFileManage sharedFileManager] updateConfig:self];
}

- (void)setUnit:(QNUnit)unit {
    _unit = unit;
    [[QNFileManage sharedFileManager] updateConfig:self];
}

- (void)setShowPowerAlertKey:(BOOL)showPowerAlertKey {
    _showPowerAlertKey = showPowerAlertKey;
    [[QNFileManage sharedFileManager] updateConfig:self];
}

@end
