//
//  QNScaleData+QNAddition.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNScaleData+QNAddition.h"
#import <objc/runtime.h>

@implementation QNScaleData (QNAddition)
static char QNScaleData_dataCypher;

- (void)setDataCypher:(QNDataCypher *)dataCypher {
    objc_setAssociatedObject(self, &QNScaleData_dataCypher, dataCypher, OBJC_ASSOCIATION_RETAIN);
}

- (QNDataCypher *)dataCypher {
    return objc_getAssociatedObject(self, &QNScaleData_dataCypher);
}

- (instancetype)initConvenient {
    if (self = [super init]) {
        
    }
    return self;
}

+ (QNScaleData *)buildDataCypher:(QNDataCypher *)dataCypher user:(QNUser *)user isCallCalculate:(BOOL)isCallCalculate {
    QNScaleData *scaleData = [[QNScaleData alloc] initConvenient];
    [scaleData setValue:[NSNumber numberWithDouble:dataCypher.height] forKey:@"height"];
    [scaleData setValue:[NSNumber numberWithUnsignedInteger:dataCypher.heigtWeightMode] forKey:@"heightMode"];
    [scaleData setValue:user forKey:@"user"];
    [scaleData setValue:[NSDate dateWithTimeIntervalSince1970:dataCypher.timeTemp] forKeyPath:@"measureTime"];
    scaleData.dataCypher = dataCypher;
    if (isCallCalculate) {
        [dataCypher calculateMeasureDataWithUser:user];
    }
    return scaleData;
}

@end
