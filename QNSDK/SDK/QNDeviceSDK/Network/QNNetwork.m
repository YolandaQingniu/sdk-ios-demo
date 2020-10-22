//
//  QNNetwork.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/4/26.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNNetwork.h"
#import "QNAESCrypt.h"
#import "QNDataTool.h"
#import "QNDebug.h"
#import "NSError+QNAPI.h"
#import "QNAuthInfo.h"

#define QNSDKBaseURL @"https://sdk.yolanda.hk/open_api/sdk/"
//#define QNSDKBaseURL @"http://sit.yolanda.hk/open_api/sdk/"


@implementation QNNetwork

+ (void)registerSDKAppid:(NSString *)appid response:(void (^)(NSDictionary *, NSError *))block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appid forKey:@"business_app_id"];
    [params setObject:@"0.6.2" forKey:@"current_sdk_version"];
    QNAuthInfo *authInfo = [QNAuthInfo sharedAuthInfo];
    if (authInfo) {
        [params setObject:[NSString stringWithFormat:@"%ld",(long)authInfo.updateTimeStamp] forKey:@"last_at"];
    }
    [self postURL:@"init" params:params response:^(NSDictionary *result, NSError *error) {
        if (block) {
            block(result,error);
        }
    }];
}

+ (void)registerDevice:(QNBleDevice *)device response:(void (^)(BOOL, NSError *))block {
    QNAuthInfo *authInfo = [QNAuthInfo sharedAuthInfo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (authInfo.appid != nil) {
        [params setValue:authInfo.appid forKey:@"appid"];
    }
    if (device.mac != nil) {
        [params setValue:device.mac forKey:@"mac"];
    }
    if (device.modeId != nil) {
        [params setValue:device.modeId forKey:@"internal_model"];
    }
    [self postURL:@"register_device" params:params response:^(NSDictionary *result, NSError *error) {
        NSError *customError = nil;
        if (error) {
            customError = [NSError errorWithDomain:QNDeviceSDKErrorDomain code:QNBleErrorCodeRegisterDevice userInfo:error.userInfo];
        }else {
            NSInteger code = [[QNDataTool sharedDataTool] toInteger:[result valueForKey:@"code"]];
            if (code !=  20000) {
                NSString *errMesg = [[QNDataTool sharedDataTool] toString:result[@"message"]];
                customError = [NSError errorWithDomain:QNDeviceSDKErrorDomain code:QNBleErrorCodeRegisterDevice userInfo:@{NSLocalizedFailureReasonErrorKey : errMesg}];
            }
        }

        if (QNDebugLogIsVail) {
            if (customError == nil) {
                [[QNDebug sharedDebug] log:[NSString stringWithFormat:@"%@ 注册成功",device.mac]];
            }else {
                [[QNDebug sharedDebug] log:[NSString stringWithFormat:@"%@ 注册失败  %@",device.mac,[customError description]]];
            }
        }
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (customError) {
                    block(NO, customError);
                }else {
                    block(YES, nil);
                }
            });
        }
    }];
}

+ (void)postURL:(NSString *)url params:(NSMutableDictionary *)params response:(void (^)(NSDictionary *result, NSError * error))block {
    NSURL *requestURL = [NSURL URLWithString:[QNSDKBaseURL stringByAppendingString:url]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.timeoutInterval = 30;
    request.HTTPMethod = @"POST";
    NSString *aescryptStr = [QNAESCrypt AES128Encrypt:[[QNDataTool sharedDataTool] dictionaryToJson:params]];
    NSData *data = [aescryptStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [session finishTasksAndInvalidate];
        if (error) {
            if (block) {
                block(nil,error);
            }
        }else{
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode != 200) {
                if (block) {
                    block(nil,[NSError errorWithDomain:@"QNSDKNetwork" code:1002 userInfo:@{NSLocalizedFailureReasonErrorKey : @"httpCode isn't 200"}]);
                }
            }else {
                NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSString *decrypt = [QNAESCrypt AES128Decrypt:results];
                NSDictionary *resultDic = [[QNDataTool sharedDataTool] jsonTodictionary:decrypt];
                if (resultDic == nil) {
                    if (block) {
                        block(nil,[NSError errorWithDomain:@"QNSDKNetwork" code:1004 userInfo:@{NSLocalizedDescriptionKey : @"jsonToDic error"}]);
                    }
                }else{
                    if (block) {
                        block(resultDic, nil);
                    }
                }
            }
        }
    }];
    [dataTask resume];
}





@end
