//
//  KitchenVC.m
//  QNDeviceSDKDemo
//
//  Created by qiudongquan on 2019/10/24.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "KitchenVC.h"
#import <QNSDK/QNDeviceSDK.h>

@interface KitchenVC ()<QNBleDeviceDiscoveryListener>
@property (weak, nonatomic) IBOutlet UILabel *peelLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@end

@implementation KitchenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.peelLabel.hidden = YES;
    [QNBleApi sharedBleApi].discoveryListener = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[QNBleApi sharedBleApi] startBleDeviceDiscovery:^(NSError *error) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[QNBleApi sharedBleApi] stopBleDeviceDiscorvery:^(NSError *error) {
        
    }];
}

- (void)onKitchenDeviceDiscover:(QNBleKitchenDevice *)device {
    self.peelLabel.hidden = !device.isPeel;
    if (device.isOverload) {
        self.weightLabel.text = @"Err";
    } else {
        NSString *weightStr = nil;
        switch (device.unit) {
            case QNUnitML:
                weightStr = [NSString stringWithFormat:@"%.1f ml",[[QNBleApi sharedBleApi] convertWeightWithTargetUnit:device.weight unit:QNUnitML]];
                break;
            
            case QNUnitOZ:
                weightStr = [NSString stringWithFormat:@"%.1f ml",[[QNBleApi sharedBleApi] convertWeightWithTargetUnit:device.weight unit:QNUnitOZ]];
                break;
            case QNUnitLBOZ:
            {
                double ozNum = [[QNBleApi sharedBleApi] convertWeightWithTargetUnit:device.weight unit:QNUnitOZ];
                int lbNum = ozNum / 16;
                ozNum = ozNum - lbNum * 16;
                weightStr = [NSString stringWithFormat:@"%d lb %.1f oz",lbNum,ozNum];
            }
                break;
            default:
                weightStr = [NSString stringWithFormat:@"%.1f g",device.weight];
                break;
        }
        
        if (device.isNegative) {
            weightStr = [@"- " stringByAppendingString:weightStr];
        }
        self.weightLabel.text = weightStr;
    }
}



@end
