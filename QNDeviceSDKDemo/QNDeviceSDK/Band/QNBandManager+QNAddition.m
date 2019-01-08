//
//  QNBandManager+QNAddition.m
//  QNDeviceSDK
//
//  Created by donyau on 2019/1/3.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "QNBandManager+QNAddition.h"
#import <objc/runtime.h>

@implementation QNBandManager (QNAddition)
static char QNBandManager_wristManagerKey;

- (void)setWristManager:(QNWristManager *)wristManager {
    objc_setAssociatedObject(self, &QNBandManager_wristManagerKey, wristManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QNWristManager *)wristManager {
    return objc_getAssociatedObject(self, &QNBandManager_wristManagerKey);
}

- (instancetype)initWithCentralManager:(QNCentralManager *)centralManager delegate:(id<QNBandDelegate>)delegate {
    if (self = [super init]) {
        self.wristManager = [[QNWristManager alloc] initWithCentralManager:centralManager];
        self.wristManager.delegate = delegate;
    }
    return self;
}

@end
