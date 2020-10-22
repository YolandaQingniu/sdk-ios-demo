//
//  QNWspDeploy.h
//  QNWSPScaleModule
//
//  Created by qiudongquan on 2019/7/29.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNWspUser.h"
#import "QNWspWiFi.h"
#import "QNWspEnum.h"
#import "QNWspLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNWspDeploy : NSObject

// 默认 15 秒
@property(nonatomic, assign) NSTimeInterval connectOverTime;

@property(nonatomic, assign) BOOL isNeedCheckWiFiStatus;

@property(nonatomic, assign) QNWspDeviceUnit unit;
// 需删除用户(可不填)
@property(nonatomic, strong, nullable) NSMutableArray<QNWspUser *> *deleteUsers;
// 当前测量用户
@property(nonatomic, strong, nullable) QNWspUser *visitUser;
// 经纬度(可不填)
@property(nonatomic, strong, nullable) QNWspLocation *location;
// 是否读取SN
@property(nonatomic, assign) BOOL readSn;

@property(nonatomic, strong, nullable) QNWspWiFi *wifiConfig;

/// 该参数用于SDK的设置,设置为YES时,当用户同时传递user与wifiConfig时,需要先配网成功才能操作user
@property(nonatomic, assign) BOOL isWifiChannel;

@end

NS_ASSUME_NONNULL_END
