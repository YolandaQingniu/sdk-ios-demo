//
//  NSError+QNAPI.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNCentralEnum.h"
#import "QNAdvertScaleEnum.h"
#import "QNPScaleEnum.h"
#import "QNErrorCode.h"
#import "QNCallBackConst.h"

#define QNDeviceSDKErrorDomain @"QNDeviceSDkDomain"

@interface NSError (QNAPI)

+ (NSError *)errorCode:(QNBleErrorCode)code callBack:(QNResultCallback)block;


+ (NSError *)errorCode:(QNBleErrorCode)code;


+ (NSError *)errorForQNBLEModuleError:(NSError *)bleModuleError;

@end
