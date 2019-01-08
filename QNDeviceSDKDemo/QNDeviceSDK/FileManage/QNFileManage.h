//
//  QNFileManage.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/12.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNConfig.h"
#import "QNSDKConfig.h"

@interface QNFileManage : NSObject

+ (QNFileManage *)sharedFileManager;

- (BOOL)fileExistsAtPath:(NSString *)filePath;

/** --------------------------------------------- 蓝牙设置相关 --------------------------------------------- */
- (QNConfig *)config;

- (void)updateConfig:(QNConfig *)config;


/** --------------------------------------------- SDK配置相关 --------------------------------------------- */
- (QNSDKConfig *)sdkConfig;

- (BOOL)updateSdkConfigForDic:(NSDictionary *)dic;

- (BOOL)updateSdkConfigForFilePath:(NSString *)filePath;

/** --------------------------------------------- appID相关 --------------------------------------------- */

- (BOOL)updateVerifyAppid:(NSString *)appid;

- (NSString *)verifyAppid;

/** --------------------------------------------- 时间相关 --------------------------------------------- */
- (NSInteger)lastRequestUpdateSDKConfigFromServiceTime;

- (void)saveRequsetUpdateSdkConfigTime:(NSInteger)time;

@end
