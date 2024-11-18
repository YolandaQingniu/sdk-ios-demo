//
//  BleRulerVC.m
//  QNDeviceSDKDemo
//
//  Created by sumeng on 2022/7/5.
//  Copyright © 2022 Yolanda. All rights reserved.
//

#import "BleRulerVC.h"
#import <QNDeviceSDK/QNDeviceSDK.h>


@interface BleRulerVC ()<QNBleStateListener,QNBleRulerListener>
@property (weak, nonatomic) IBOutlet UILabel *macLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) QNBleApi *bleApi;
@property (nonatomic, strong) QNBleRulerDevice *ruler;
@property (nonatomic, assign) BOOL isScan;
@end

@implementation BleRulerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _bleApi = [QNBleApi sharedBleApi];
    _bleApi.bleRulerListener = self;
    _bleApi.bleStateListener = self;
}

- (void)startScan {
    [_bleApi startBleDeviceDiscovery:^(NSError *error) {
        
    }];
}

- (void)stopScan {
    [_bleApi stopBleDeviceDiscorvery:^(NSError *error) {
        
    }];
}

- (IBAction)clickButton:(id)sender {
    _isScan = !_isScan;
    if (_isScan) {
        [self startScan];
        [self.button setTitle:@"扫描中..." forState:UIControlStateNormal];
        return;
    }
    
    [self stopScan];
    [self.button setTitle:@"扫描设备" forState:UIControlStateNormal];
    if (_ruler) {
        [_bleApi disconnectDeviceWithMac:_ruler.mac callback:^(NSError *error) {
        }];
    }
}

#pragma mark System Bluetooth Status
- (void)onBleSystemState:(QNBLEState)state {
    if (state == QNBLEStatePoweredOn) {
        [self startScan];
    }else {
        [self stopScan];
    }
}


- (void)onRulerDeviceDiscover:(QNBleRulerDevice *)device {
    if (_ruler) return;
    [_bleApi connectRulerDevice:device callback:^(NSError *error) {
        if (!error) {
            _ruler = device;
        }
    }];
}

- (void)onRulerConnecting:(QNBleRulerDevice *)device {
    [self.button setTitle:@"正在连接" forState:UIControlStateNormal];
}

- (void)onRulerConnectFail:(QNBleRulerDevice *)device {
    [self.button setTitle:@"连接失败" forState:UIControlStateNormal];
}

- (void)onRulerConnected:(QNBleRulerDevice *)device {
    [self.button setTitle:@"连接成功" forState:UIControlStateNormal];
    _macLabel.text = device.mac;
}

- (void)onRulerDisconnected:(QNBleRulerDevice *)device {
    _macLabel.text = @"";
    _valueLabel.text = @"";
    _unitLabel.text = @"";
    _ruler = nil;
    [self.button setTitle:@"连接断开" forState:UIControlStateNormal];
}

- (void)onGetReceiveRealTimeData:(QNBleRulerData *)data device:(QNBleRulerDevice *)device {
    if (data.unit == QNBleRulerUnitCM) {
        self.valueLabel.text = [NSString stringWithFormat:@"实时 %.1f",data.value];
        self.unitLabel.text =  @"CM";
    }else {
        self.valueLabel.text = [NSString stringWithFormat:@"实时 %.2f",data.value];
        self.unitLabel.text = @"IN";
    }
}

- (void)onGetReceiveResultData:(QNBleRulerData *)data device:(QNBleRulerDevice *)device {
    if (data.unit == QNBleRulerUnitCM) {
        self.valueLabel.text = [NSString stringWithFormat:@"确认 %.1f",data.value];
        self.unitLabel.text =  @"CM";
    }else {
        self.valueLabel.text = [NSString stringWithFormat:@"确认 %.2f",data.value];
        self.unitLabel.text = @"IN";
    }
}
@end
