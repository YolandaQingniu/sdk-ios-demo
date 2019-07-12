//
//  DeviceTableViewCell.h
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/16.
//  Copyright © 2018年 Yolanda. All rights reserved.
//  外设信息cell 

#import <UIKit/UIKit.h>
#import "QNBleDevice.h"
#import "QNBleBroadcastDevice.h"

@interface DeviceTableViewCell : UITableViewCell

@property (nonatomic, strong) QNBleDevice *device;

@property (nonatomic, strong) QNBleBroadcastDevice *broadcastDevice;

@end
