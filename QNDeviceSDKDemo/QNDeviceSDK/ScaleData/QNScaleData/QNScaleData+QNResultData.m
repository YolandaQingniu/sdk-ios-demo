//
//  QNScaleData+QNResultData.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNScaleData+QNResultData.h"
#import <objc/runtime.h>

@implementation QNScaleData (QNResultData)
static char QNScaleData_QNResultData;

- (void)setResultData:(QNResultData *)resultData {
    objc_setAssociatedObject(self, &QNScaleData_QNResultData, resultData, OBJC_ASSOCIATION_RETAIN);
}

- (QNResultData *)resultData {
    return objc_getAssociatedObject(self, &QNScaleData_QNResultData);
}

@end
