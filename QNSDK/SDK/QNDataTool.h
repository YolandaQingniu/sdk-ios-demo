//
//  QNDataTool.h
//  QNDeviceSDK
//
//  Created by com.qn.device on 2018/4/26.
//  Copyright © 2018年 com.qn.device. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNConfig.h"

#define QNSDKInfoFileName @"QNDeviceSDK"
#define QNDataCryptPassword @"mmpyfqingniu"

@interface QNDataTool : NSObject

@property(nonatomic, strong) NSFileManager *fileManager;

@property(nonatomic, strong) NSString *sdkFilePath;

+ (QNDataTool *)sharedDataTool;

/** dic -> json */
- (NSString *)dictionaryToJson:(NSDictionary *)dictionary;

/** json -> dic */
- (NSDictionary *)jsonTodictionary:(NSString *)jsonString;

- (NSString *)toString:(NSString *)str;

- (NSInteger)toInteger:(id)obj;

- (double)toDouble:(id)obj;

- (double)convertWeightWithTargetUnit:(double)weight unit:(QNUnit)unit;

@end
