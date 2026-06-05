//
//  QNBleRulerDevice.h
//  QNDeviceSDK
//
//  Created by sumeng on 2022/7/5.
//  Copyright © 2022 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNBleRulerDevice : NSObject

/** mac地址 */
@property (nonatomic, readonly, strong) NSString *mac;
/** name */
@property (nonatomic, readonly, strong) NSString *bluetoothName;
/** modeId */
@property (nonatomic, readonly, strong) NSString *modeId;
/** 信号强度 */
@property (nonatomic, readonly, strong) NSNumber *RSSI;
@end

NS_ASSUME_NONNULL_END
