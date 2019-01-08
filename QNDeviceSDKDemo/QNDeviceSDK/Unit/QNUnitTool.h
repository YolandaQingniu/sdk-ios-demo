//
//  QNUnitTool.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/31.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNConfig.h"

@interface QNUnitTool : NSObject

+ (double)convertWeightWithTargetUnit:(double)kgWeight unit:(QNUnit)unit;

@end
