//
//  QNUnitTool.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/31.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNUnitTool.h"

@implementation QNUnitTool

#pragma mark 转换单位
+ (double)convertWeightWithTargetUnit:(double)kgWeight unit:(QNUnit)unit {
    if (unit == QNUnitLB || unit == QNUnitST) {
        return ((int)(((kgWeight * 100) * 11023 + 50000)/100000) << 1 ) / 10.0;
    }else if (unit == QNUnitJIN) {
        return kgWeight * 2;
    }else {
        return kgWeight;
    }
}

@end
