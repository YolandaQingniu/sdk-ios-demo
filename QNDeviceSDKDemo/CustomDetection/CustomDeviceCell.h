//
//  CustomDeviceCell.h
//  QNDeviceSDKDemo
//
//  Created by qiudongquan on 2020/10/22.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNDeviceSDK.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CustomDeviceCellDelegate <NSObject>

- (void)disconnectDevice:(QNBleDevice *)device;

@end

@interface CustomDeviceCell : UITableViewCell
@property(nonatomic, weak) id<CustomDeviceCellDelegate> delegate;

@property(nonatomic, strong) QNBleDevice *device;

@end

NS_ASSUME_NONNULL_END
