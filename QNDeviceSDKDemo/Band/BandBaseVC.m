//
//  BandBaseVC.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/8.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandBaseVC.h"

@interface BandBaseVC ()<QNBleStateListener,QNBleConnectionChangeListener,QNBleDeviceDiscoveryListener>

@end

@implementation BandBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.bandDevice) return;
    
    QNBleApi *bleApi = [QNBleApi sharedBleApi];
    
    bleApi.bleStateListener = self;
    bleApi.connectionChangeListener = self;
    bleApi.discoveryListener = self;
    
    [self startScanDevice];
}

- (void)startScanDevice {
    [[QNBleApi sharedBleApi] startBleDeviceDiscovery:^(NSError *error) {
        
    }];
    
    BandMessage *message = [BandMessage sharedBandMessage];
    
    [[QNBleApi sharedBleApi] findPairBandWithMac:message.mac modeId:message.modeId uuidIdentifier:message.uuidString callback:^(NSError *error) {
        
    }];
}

- (void)onBleSystemState:(QNBLEState)state {
    if (state != QNBLEStatePoweredOn) {
        self.bandDevice = nil;
    }

}

- (void)onDeviceDiscover:(QNBleDevice *)device {
    if (self.bandDevice || [[BandMessage sharedBandMessage].mac isEqualToString:device.mac] == NO) nil;
    self.bandDevice = device;
    QNBleApi *api = [QNBleApi sharedBleApi];
    __weak typeof(self) weakSelf = self;
    [api stopBleDeviceDiscorvery:^(NSError *error) {
        
    }];
    [api connectDevice:device user:nil callback:^(NSError *error) {
        if (error) {
            weakSelf.bandDevice = nil;
            [weakSelf startScanDevice];
        }
    }];
}

- (void)onDeviceStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state {
    if ([device.mac isEqualToString:self.bandDevice.mac] == NO) return;
    if (state == QNScaleStateDisconnected || state == QNScaleStateLinkLoss || state == QNScaleStateLinkLoss) {
        self.bandDevice = nil;
        [self startScanDevice];
    }
    
    if (state == QNScaleStateInteraction) {
        [self syncLocalSet];
    }
}


- (void)syncLocalSet {
    
    
}


@end
