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
@property (weak, nonatomic) IBOutlet UILabel *modeIdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wifiImageView;

@end
@implementation DeviceTableViewCell
- (void)setDevice:(QNBleDevice *)device {
    _device = device;
    self.nameLabel.text = device.name;
    self.macLabel.text = device.mac;
    self.RSSILabel.text = [device.RSSI stringValue];
    self.modeIdLabel.text = device.modeId;
    self.wifiImageView.hidden = !device.supportWifi || device.deviceType == QNDeviceTypeHeightScale;
}

- (void)setBroadcastDevice:(QNBleBroadcastDevice *)broadcastDevice {
    _broadcastDevice = broadcastDevice;
    self.nameLabel.text = broadcastDevice.name;
    self.macLabel.text = broadcastDevice.mac;
    self.RSSILabel.text = [broadcastDevice.RSSI stringValue];
    self.modeIdLabel.text = broadcastDevice.modeId;
    self.wifiImageView.hidden = YES;
}
@end
