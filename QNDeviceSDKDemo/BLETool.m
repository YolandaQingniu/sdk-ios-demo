//
//  BLETool.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/8.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BLETool.h"


@interface BLETool ()<QNBleDeviceDiscoveryListener,QNBleConnectionChangeListener,QNDataListener,QNBleStateListener>
@property (nonatomic, strong) QNBleApi *bleApi;
@end

@implementation BLETool
static BLETool *_bleTool = nil;

+ (BLETool *)sharedBLETool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bleTool = [BLETool alloc];
    });
    return _bleTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bleTool = [[super allocWithZone:zone] init];
    });
    return _bleTool;
}

- (instancetype)init {
    if (self = [super init]) {
        self.bleApi = [QNBleApi sharedBleApi];
        self.bleApi.discoveryListener = self;
        self.bleApi.connectionChangeListener = self;
        self.bleApi.dataListener = self;
        self.bleApi.bleStateListener = self;

        QNConfig *config = [self.bleApi getConfig];
        config.showPowerAlertKey = YES;
        
        QNBleApi.debug = YES;
        NSString *file = [[NSBundle mainBundle] pathForResource:@"123456789" ofType:@"qn"];
        [self.bleApi initSdk:@"123456789" firstDataFile:file callback:^(NSError *error) {
            
        }];
    }
    return self;
}

- (void)connectDevice:(QNBleDevice *)device user:(QNUser *)user {
    [self.bleApi connectDevice:device user:user callback:^(NSError *error) {
        
    }];
}

@end
