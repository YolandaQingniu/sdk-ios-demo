//
//  QNScaleData+QNAddition.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//
#import "QNScaleData.h"
#import "QNDataCypher.h"

@interface QNScaleData (QNAddition)

@property (nonatomic, strong) QNDataCypher *dataCypher;

+ (QNScaleData *)buildDataCypher:(QNDataCypher *)dataCypher user:(QNUser *)user isCallCalculate:(BOOL)isCallCalculate;

@end
