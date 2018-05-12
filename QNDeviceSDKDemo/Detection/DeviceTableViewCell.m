//
//  DeviceTableViewCell.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/16.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "DeviceTableViewCell.h"
@interface DeviceTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;
@property (weak, nonatomic) IBOutlet UILabel *RSSILabel;

@end
@implementation DeviceTableViewCell
- (void)setDevice:(QNBleDevice *)device {
    _device = device;
    self.nameLabel.text = device.name;
    self.macLabel.text = device.mac;
    self.RSSILabel.text = [device.RSSI stringValue];
}

@end
