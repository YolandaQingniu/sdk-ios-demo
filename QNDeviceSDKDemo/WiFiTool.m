//
//  WiFiTool.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2019/4/25.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "WiFiTool.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation WiFiTool

+ (NSString *)currentWifiName {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return [info objectForKey:@"SSID"];
}

@end
