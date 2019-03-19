//
//  QNBleStateProtocol.h
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/31.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

typedef NS_ENUM(NSUInteger, QNBLEState) {
    QNBLEStateUnknown = 0,
    QNBLEStateResetting = 1,
    QNBLEStateUnsupported = 2,
    QNBLEStateUnauthorized = 3,
    QNBLEStatePoweredOff = 4,
    QNBLEStatePoweredOn = 5,
};

@protocol QNBleStateListener <NSObject>

/**
 系统蓝牙状态的回调
 
 @param state QNBLEState
 */
- (void)onBleSystemState:(QNBLEState)state;

@end
