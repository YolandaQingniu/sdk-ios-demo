//
//  QNNetwork.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/4/26.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNNetwork : NSObject

+ (void)registerSDKAppid:(NSString *)appid response:(void (^)(NSDictionary *result, NSError *error))block;

@end
