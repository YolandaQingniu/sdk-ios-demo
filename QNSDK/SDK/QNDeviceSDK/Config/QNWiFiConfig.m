//
//  QNWiFiConfig.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/4/25.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "QNWiFiConfig.h"

@implementation QNWiFiConfig

- (NSData *)ssidData {
    return [self.ssid dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)pwdData {
    if (self.pwd == nil || self.pwd.length == 0) {
        //无密码时，随机8位数
        return [@"12345678" dataUsingEncoding:NSUTF8StringEncoding];
    }
    return [self.pwd dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)checkSSIDVail {
    if ([self.ssid isKindOfClass:[NSString class]] == NO || self.ssid == nil || self.ssid.length == 0) {
        return NO;
    }
    return [self ssidData].length < 32;
}


- (BOOL)checkPWDVail {
    NSUInteger length = [self pwdData].length;
    return (length < 64 && length >= 8);
}

@end
