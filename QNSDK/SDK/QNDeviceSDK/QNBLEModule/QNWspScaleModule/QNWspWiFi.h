//
//  QNWspWiFi.h
//  QNWSPScaleModule
//
//  Created by qiudongquan on 2019/8/1.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNWspWiFi : NSObject

@property(nonatomic, strong) NSString *ssid;

@property(nonatomic, strong, nullable) NSString *pwd;

@property(nonatomic, strong, nullable) NSString *serverUrl;

@property(nonatomic, strong, nullable) NSString *otaUrl;

@property(nonatomic, strong, nullable) NSString *encryption;

/**
 检测SSID的有效性

 @return 结果
 */
- (BOOL)checkoutSSIDVail;

/**
 检测pwd的有效性
 
 @return 结果
 */
- (BOOL)checkoutpwdVail;

@end

NS_ASSUME_NONNULL_END
