//
//  QNConfig+QNAddition.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/2/25.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNConfig+QNAddition.h"
#import "QNDataTool.h"
#import <objc/runtime.h>

@implementation QNConfig (QNAddition)
static char QNConfig_filePath;
static char QNConfig_lock;

static QNConfig *_config;

- (void)setConfigPath:(NSString *)configPath {
    objc_setAssociatedObject(self, &QNConfig_filePath, configPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)configPath {
    return  objc_getAssociatedObject(self, &QNConfig_filePath);
}

- (void)setLock:(NSLock *)lock {
    objc_setAssociatedObject(self, &QNConfig_lock, lock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLock *)lock {
    return  objc_getAssociatedObject(self, &QNConfig_lock);
}

- (instancetype)initConvenient {
    if (self = [super init]) {
        if (self.configPath == nil) {
            self.configPath = [[QNDataTool sharedDataTool].sdkFilePath stringByAppendingPathComponent:@"qnConfig.plist"];
        }
        if (self.lock == nil) {
            self.lock = [[NSLock alloc] init];
        }
        if ([[QNDataTool sharedDataTool].fileManager fileExistsAtPath:self.configPath] == NO) {
            self.onlyScreenOn = NO;
            self.allowDuplicates = NO;
            self.duration = 0;
            self.unit = QNUnitKG;
            self.showPowerAlertKey = NO;
            self.enhanceBleBoradcast = NO;
            [self save];
        } else {
            NSDictionary *json = [NSMutableDictionary dictionaryWithContentsOfFile:self.configPath];
            self.onlyScreenOn = [[QNDataTool sharedDataTool] toInteger:json[QNFileManageConfigOnlyScreenOn]];
            self.allowDuplicates = [[QNDataTool sharedDataTool] toInteger:json[QNFileManageConfigAllowDuplicates]];
            self.duration = (int)[[QNDataTool sharedDataTool] toInteger:json[QNFileManageConfigDuration]];

            self.unit = [[QNDataTool sharedDataTool] toInteger:json[QNFileManageConfigUnit]];
            self.showPowerAlertKey = [[QNDataTool sharedDataTool] toInteger:json[QNFileManageConfigShowPowerAlertKey]];
            self.enhanceBleBoradcast = [[QNDataTool sharedDataTool] toInteger:json[QNFileManageConfigEnhanceBleBroadcastKey]];
        }
    }
    return self;
}

+ (QNConfig *)sharedConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _config = [QNConfig alloc];
    });
    return _config;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _config = [[super allocWithZone:zone] initConvenient];
    });
    return _config;
}

@end
