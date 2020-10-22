//
//  QNAuthInfo.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/2/24.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNAuthInfo.h"
#import "QNAuthDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNAuthInfo : NSObject
/// 初始化方法的appid
@property (nonatomic, strong) NSString *methodAppid;
/// 服务器请求记录，用于判断当天是否通讯成功
@property (nonatomic, assign) NSInteger dayNum;

@property (nonatomic, strong) NSString *appid;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) NSInteger serverType;

@property (nonatomic, strong) NSMutableArray *packages;

@property (nonatomic, assign) BOOL connectOtherFlag;

@property (nonatomic, strong) NSString *defaultModel;

@property (nonatomic, assign) NSInteger defaultMethod;

@property (nonatomic, assign) NSInteger defaultIndexFlag;

@property (nonatomic, assign) NSInteger updateTimeStamp;

@property (nonatomic, assign) BOOL defaultAddTargetFlag;

@property (nonatomic, strong) NSMutableArray<QNAuthDevice *> *authDevices;

+ (QNAuthInfo *)sharedAuthInfo;

- (NSInteger)dayNumSince1970;

- (void)askAuthInfoWithMethodAppid:(NSString *)methodAppid;

- (BOOL)updateAuthInfoWithEncryptInfo:(NSString *)encryptInfo;

- (BOOL)updateAuthInfoWithJson:(NSDictionary *)json;

- (nullable NSError *)checkUseAuth;

@end

NS_ASSUME_NONNULL_END
