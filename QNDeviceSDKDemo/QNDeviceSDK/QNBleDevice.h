//
//  QNBleDevice.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QNDeviceType) {
    QNDeviceScale = 0,
    QNDeviceBand = 1,
};

@interface QNBleDevice : NSObject
/** mac地址 */
@property (nonatomic, readonly, strong) NSString *mac;
/** 设备名称 */
@property (nonatomic, readonly, strong) NSString *name;
/** 型号标识 */
@property (nonatomic, readonly, strong) NSString *modeId;
/** 蓝牙名称 */
@property (nonatomic, readonly, strong) NSString *bluetoothName;
/** 信号强度 */
@property (nonatomic, readonly, strong) NSNumber *RSSI;
/** 设备类型 */
@property (nonatomic, readonly, assign) QNDeviceType deviceType;
/** 系统提供的设备唯一标识 */
@property (nonatomic, readonly, strong) NSString *uuidIdentifier;
/** 是否已开机 */
@property (nonatomic, readonly, getter=isScreenOn, assign) BOOL screenOn;
@end
