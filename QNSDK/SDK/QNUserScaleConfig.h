//
//  QNUserScaleConfig.h
//  QNDeviceSDK
//
//  Created by sumeng on 2021/11/25.
//  Copyright © 2021 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNWiFiConfig.h"
#import "QNConfig.h"
#import "QNUser.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, QNBuzzerMode) {
    QNBuzzerModeDefault  = 0,  // 默认，不做修改，使用秤端记录蜂鸣器工作状态
    QNBuzzerModeClose,         // 设置关闭秤端蜂鸣器
    QNBuzzerModeOpen,          // 设置开启秤端蜂鸣器
};

@interface QNUserScaleConfig : NSObject

/// wifi配置对象
@property (nullable, nonatomic, strong) QNWiFiConfig *wifiConfig;
/// 秤端用户列表
@property (nullable, nonatomic, strong) NSArray<QNUser *> *userlist;
/// 当前测量用户(若只需配网，无需测量，则无需设置用户)
@property (nullable, nonatomic, strong) QNUser *curUser;
/// 是否是访客模式，当使用访客模式是，可以不设置用户对象中的index与secret
@property (nonatomic, assign) BOOL isVisitor;
/// OTA升级地址
@property (nullable, nonatomic, strong) NSString *otaUrl;
/// 通讯秘钥
@property (nullable, nonatomic, strong) NSString *encryption;
/// 是否延迟显示屏熄屏时间(大约延时60s，部分设备支持)，默认false
@property(nonatomic, assign) BOOL isDelayScreenOff;

/// 用户地区(部分设备支持)用来控制秤上显示体脂标准
@property (nonatomic, assign) QNAreaType areaType;

/// 关闭测量脂肪(部分设备支持)，默认 NO，测量脂肪
@property(nonatomic, assign) BOOL isCloseMeasureFat;
/// 关闭测量脂肪是否是长期有效(部分设备支持)，默认 NO，单次链接有效
@property(nonatomic, assign) BOOL isLongTimeValid;

/// 抱婴模式(部分设备支持)，默认 NO。需要QNBleDevice.isSupportBabyCarryingModel == true开启抱婴模式，秤端只显示体重。
@property(nonatomic, assign) BOOL isBabyCarryingModel;

//  秤端蜂鸣器设置项(部分设备支持)，需要QNBleDevice.isSupportBuzzer == true时设置才生效
@property(nonatomic, assign) QNBuzzerMode buzzerMode;

@end

NS_ASSUME_NONNULL_END
