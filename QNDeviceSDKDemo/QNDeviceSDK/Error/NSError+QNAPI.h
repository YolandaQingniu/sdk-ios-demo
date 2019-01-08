//
//  NSError+QNAPI.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNCentralEnum.h"
#import "QNPScaleEnum.h"
#import "QNBandEnum.h"
#import "QNErrorCode.h"
#import "QNCallBackConst.h"

@interface NSError (QNAPI)

+ (NSError *)errorCode:(QNBleErrorCode)code;

+ (NSError *)transformModuleError:(NSError *)bleModuleError;

@end
