//
//  QNWiFiConfig.h
//  QNDeviceSDK
//
//  Created by com.qn.device on 2019/4/25.
//  Copyright © 2019 com.qn.device. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNWiFiConfig : NSObject

/** WiFi名称 */
@property(nonatomic, strong) NSString *ssid;
/** WiFi密码 */
@property(nonatomic, strong, nullable) NSString *pwd;

/** 数据传输地址。WSP设备设置有效，其他设备可设为 null*/
@property(nonatomic, strong, nullable) NSString *serveUrl;

/** 检查WiFi名称的有效性 */
- (BOOL)checkSSIDVail;
/** 检查WiFi密码的有效性 */
- (BOOL)checkPWDVail;

@end

NS_ASSUME_NONNULL_END
