//
//  QNScaleStoreData.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNScaleStoreData.h"
#import "QNScaleStoreData+QNResultData.h"
#import "QNScaleData+QNResultData.h"

@implementation QNScaleStoreData

- (void)setUser:(QNUser *)user {
    self.resultData.user = user;
    [self.resultData reckonMeasureResult];
}

- (QNScaleData *)generateScaleData {
    if (self.resultData.user == nil) {
        return nil;
    }
    QNScaleData *scaleData = [[QNScaleData alloc] init];
    if (self.resultData.user) {
        [scaleData setValue:self.resultData.user forKeyPath:@"user"];
    }
    if (self.measureTime) {
        [scaleData setValue:self.measureTime forKeyPath:@"measureTime"];
    }
    scaleData.resultData = self.resultData;
    return scaleData;
}

@end
