//
//  QNSDKConfig.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/4/26.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNSDKConfig.h"
#import "QNDataTool.h"

@implementation QNDeviceMessage


@end

@implementation QNSDKConfig

+ (QNSDKConfig *)sdkConfigDic:(NSDictionary *)dic {
    if (dic == nil) {
        return nil;
    }
    QNSDKConfig *sdkConfig = [[QNSDKConfig alloc] init];
    sdkConfig.appid = [[QNDataTool sharedDataTool] toString:[dic valueForKey:@"app_id"]];
    sdkConfig.code = [[QNDataTool sharedDataTool] toInteger:[dic valueForKey:@"code"]];
    sdkConfig.serverType = [[QNDataTool sharedDataTool] toInteger:[dic valueForKey:@"server_type"]];
    NSMutableArray *pachages = [NSMutableArray array];
    NSString *packageStr = [[QNDataTool sharedDataTool] toString:[dic valueForKey:@"package_name_array"]];
    if (packageStr != nil && packageStr.length > 0) {
        NSArray *packageAry = [packageStr componentsSeparatedByString:@","];
        for (NSString *pachageItem in packageAry) {
            NSString *package = [pachageItem stringByReplacingOccurrencesOfString:@"," withString:@""];
            if (package != nil && package.length > 0) {
                [pachages addObject:package];
            }
        }
    }
    sdkConfig.packages = pachages;
    sdkConfig.connectOtherFlag = [[QNDataTool sharedDataTool] toInteger:[dic valueForKey:@"connect_other"]];
    sdkConfig.defaultModel = [[QNDataTool sharedDataTool] toString:[dic valueForKey:@"default_model"]];
    sdkConfig.defaultMethod = [[QNDataTool sharedDataTool] toInteger:[dic valueForKey:@"default_method"]];
    sdkConfig.defaultIndexFlag = [[QNDataTool sharedDataTool] toInteger:[dic valueForKey:@"default_index_flag"]];
    sdkConfig.updateTimeStamp = [[QNDataTool sharedDataTool] toInteger:[dic valueForKey:@"update_time_stamp"]];
    NSMutableArray *models = [NSMutableArray array];
    NSArray *modelsAry = [dic valueForKey:@"models"];
    for (NSDictionary *modelItem in modelsAry) {
        QNDeviceMessage *deviceMessage = [[QNDeviceMessage alloc] init];
        deviceMessage.model = [[QNDataTool sharedDataTool] toString:[modelItem valueForKey:@"model"]];
        deviceMessage.method = [[QNDataTool sharedDataTool] toInteger:[modelItem valueForKey:@"method"]];
        deviceMessage.internalModel = [[QNDataTool sharedDataTool] toString:[modelItem valueForKey:@"internal_model"]];
        deviceMessage.bodyIndexFlag = [[QNDataTool sharedDataTool] toInteger:[modelItem valueForKey:@"body_index_flag"]];
        [models addObject:deviceMessage];
    }
    sdkConfig.models = models;
    return sdkConfig;
}

@end

