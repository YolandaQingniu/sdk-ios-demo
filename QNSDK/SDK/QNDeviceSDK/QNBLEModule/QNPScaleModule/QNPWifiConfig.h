//
//  QNPWifiConfig.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/20.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNPWifiConfig : NSObject

@property (nonatomic, strong) NSString *ssid;

@property (nullable, nonatomic, strong) NSString *pwd;


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
