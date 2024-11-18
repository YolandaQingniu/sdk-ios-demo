//
//  QNBleOTAConfig.h
//  QNDeviceSDK
//
//  Created by sumeng on 2021/10/29.
//  Copyright © 2021 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNBleOTAConfig : NSObject
/// OTA数据包
@property(nonatomic, strong) NSData *OTAData;
/// OTA固件版本
@property(nonatomic, assign) int OTAVer;
@end

