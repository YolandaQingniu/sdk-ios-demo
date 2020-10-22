//
//  QNScaleStoreData+QNAddition.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/10.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNScaleStoreData.h"
#import "QNDataCypher.h"
#import "QNUser.h"

@interface QNScaleStoreData (QNAddition)
@property (nonatomic, strong) QNDataCypher *dataCypher;

@property(nonatomic, strong) QNUser *userData;

//当wsp设备已识别用户时，需要赋值userData
+ (QNScaleStoreData *)buildDataCypher:(QNDataCypher *)dataCypher mac:(NSString *)mac userData:(QNUser *)userData;

@end
