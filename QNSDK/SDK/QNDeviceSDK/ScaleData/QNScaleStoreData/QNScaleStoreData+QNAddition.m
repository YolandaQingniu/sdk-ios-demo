//
//  QNScaleStoreData+QNAddition.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/10.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNScaleStoreData+QNAddition.h"
#import <objc/runtime.h>

@implementation QNScaleStoreData (QNAddition)
static char QNScaleStoreData_dataCypher;
static char QNScaleStoreData_user;

- (void)setUserData:(QNUser *)userData {
    objc_setAssociatedObject(self, &QNScaleStoreData_user, userData, OBJC_ASSOCIATION_RETAIN);
}

- (QNUser *)userData {
    return objc_getAssociatedObject(self, &QNScaleStoreData_user);
}

- (void)setDataCypher:(QNDataCypher *)dataCypher {
    objc_setAssociatedObject(self, &QNScaleStoreData_dataCypher, dataCypher, OBJC_ASSOCIATION_RETAIN);
}

- (QNDataCypher *)dataCypher {
    return objc_getAssociatedObject(self, &QNScaleStoreData_dataCypher);
}

- (instancetype)initConvenient {
    if (self = [super init]) {
        
    }
    return self;
}

+ (QNScaleStoreData *)buildDataCypher:(QNDataCypher *)dataCypher mac:(NSString *)mac userData:(QNUser *)userData{
    QNScaleStoreData *storeData = [[QNScaleStoreData alloc] initConvenient];
    storeData.dataCypher = dataCypher;
    [storeData setValue:[NSNumber numberWithDouble:dataCypher.weight] forKey:@"weight"];
    [storeData setValue:[NSNumber numberWithDouble:dataCypher.height] forKey:@"height"];
    [storeData setValue:[NSDate dateWithTimeIntervalSince1970:dataCypher.timeTemp] forKey:@"measureTime"];
    [storeData setValue:mac forKey:@"mac"];
    [storeData setValue:[NSNumber numberWithBool:userData != nil] forKey:@"isDataComplete"];
    storeData.userData = userData;
    return storeData;
}

@end
