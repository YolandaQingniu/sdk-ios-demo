//
//  QNScaleStoreData+QNResultData.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/10.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNScaleStoreData+QNResultData.h"
#import <objc/runtime.h>

@implementation QNScaleStoreData (QNResultData)
static char QNScaleStoreData_QNResultData;

- (void)setResultData:(QNResultData *)resultData {
    objc_setAssociatedObject(self, &QNScaleStoreData_QNResultData, resultData, OBJC_ASSOCIATION_RETAIN);
}

- (QNResultData *)resultData {
    return objc_getAssociatedObject(self, &QNScaleStoreData_QNResultData);
}

@end
