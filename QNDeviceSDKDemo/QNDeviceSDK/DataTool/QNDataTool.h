//
//  QNDataTool.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/4/26.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNSDKConfig.h"

@interface QNDataTool : NSObject

+ (QNDataTool *)sharedDataTool;

/** dic -> json */
- (NSString *)dictionaryToJson:(NSDictionary *)dictionary;

/** json -> dic */
- (NSDictionary *)jsonTodictionary:(NSString *)jsonString;

- (NSString *)toString:(NSString *)str;

- (NSInteger)toInteger:(id)obj;

/** 验证是否有权限使用SDK */
- (NSError *)checkoutUseLimit;

- (NSInteger)currentDaynumSince1970;

@end
