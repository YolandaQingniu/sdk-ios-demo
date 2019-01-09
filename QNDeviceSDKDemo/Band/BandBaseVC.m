//
//  BandBaseVC.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/8.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandBaseVC.h"
#import "AppDelegate.h"

@interface BandBaseVC ()<QNBleStateListener,QNBleConnectionChangeListener,QNBleDeviceDiscoveryListener,QNDataListener>

@end

@implementation BandBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    QNBleApi *bleApi = [QNBleApi sharedBleApi];
    bleApi.bleStateListener = self;
    bleApi.connectionChangeListener = self;
    bleApi.discoveryListener = self;
    bleApi.dataListener = self;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.bandDevice == nil) {
        [self startScanDevice];
    }
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
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.bandDevice = nil;
    }
}

- (void)onDeviceDiscover:(QNBleDevice *)device {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.bandDevice || [[BandMessage sharedBandMessage].mac isEqualToString:device.mac] == NO) nil;
    delegate.bandDevice = device;
    QNBleApi *api = [QNBleApi sharedBleApi];
    __weak typeof(self) weakSelf = self;
    [api stopBleDeviceDiscorvery:^(NSError *error) {
        
    }];
    [api connectDevice:device user:nil callback:^(NSError *error) {
        if (error) {
            delegate.bandDevice = nil;
            [weakSelf startScanDevice];
        }
    }];
}

- (void)onDeviceStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([device.mac isEqualToString:delegate.bandDevice.mac] == NO) return;
    if (state == QNScaleStateDisconnected || state == QNScaleStateLinkLoss || state == QNScaleStateLinkLoss) {
        delegate.bandDevice = nil;
        [self startScanDevice];
    }
    
    if (state == QNScaleStateInteraction) {
        [self syncLocalSet];
    }
}

- (void)strikeTakePhotosWithDevice:(QNBleDevice *)device {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.contentMode = MBProgressHUDModeText;
    hud.label.text = @"收到拍照指令";
    [hud hideAnimated:YES afterDelay:1];
}

- (void)strikeFindPhoneWithDevice:(QNBleDevice *)device {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.contentMode = MBProgressHUDModeText;
    hud.label.text = @"收到查找手机指令";
    [hud hideAnimated:YES afterDelay:1];
}

- (void)syncLocalSet {
    
    
}


@end
