//
//  QNWiFiConfig.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/4/25.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNWiFiConfig : NSObject

/** WiFi名称 */
@property(nonatomic, strong) NSString *ssid;
/** WiFi密码 */
@property(nonatomic, strong, nullable) NSString *pwd;

/** 检查WiFi名称的有效性 */
- (BOOL)checkSSIDVail;
/** 检查WiFi密码的有效性 */
- (BOOL)checkPWDVail;

@end

NS_ASSUME_NONNULL_END
