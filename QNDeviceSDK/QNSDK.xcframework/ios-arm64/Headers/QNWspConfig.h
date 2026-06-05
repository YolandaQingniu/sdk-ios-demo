//
//  QNWspConfig.h
//  QNDeviceSDK
//
//  Created by com.qn.device on 2020/2/19.
//  Copyright © 2020 com.qn.device. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNWiFiConfig.h"
#import "QNUser.h"
#import "QNBleOTAConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNWspConfig : NSObject
/// wifi配置对象
@property (nullable, nonatomic, strong) QNWiFiConfig *wifiConfig;
/// 需要删除的用户的indx集合
@property (nullable, nonatomic, strong) NSArray<NSNumber *> *deleteUsers;
/// 当前测量用户(若只需配网，无需测量，则无需设置用户)
@property (nullable, nonatomic, strong) QNUser *curUser;
/// 是否需要注册用户，与isChange属性，只允许其中一个为true
@property (nonatomic, assign) BOOL isRegist;
/// 是否需要修改用户信息，与isRegist属性，只允许其中一个为true
@property (nonatomic, assign) BOOL isChange;
/// 是否是访客模式，当使用访客模式是，可以不设置用户对象中的index与secret
@property (nonatomic, assign) BOOL isVisitor;
/// 数据传输地址，只有wifiConfig有值时才起作用
@property (nullable, nonatomic, strong) NSString *dataUrl;
/// OTA升级地址
@property (nullable, nonatomic, strong) NSString *otaUrl;
/// 通讯秘钥
@property (nullable, nonatomic, strong) NSString *encryption;
/// 是否读取sn码，默认不读取
@property(nonatomic, assign) BOOL isReadSN;
/// 经度, 比如"123.4"、"-22"、"+0.5"
@property(nonatomic, strong) NSString *longitude;
/// 纬度, 同上
@property(nonatomic, strong) NSString *latitude;
/// 是否延迟显示屏熄屏时间(大约延时60s)，默认false
@property(nonatomic, assign) BOOL isDelayScreenOff;

/// 蓝牙ota固件数据(当 value 值为 null 时，不进行OTA ；当 value 值为 QNOtaConfig 对象时，根据对象中的值进行OTA)
@property(nonatomic, strong, nullable) QNBleOTAConfig *otaConfig;

/// 是否隐藏秤端体重，默认不隐藏
@property(nonatomic, assign) BOOL isHideWeight;

/// 是否关闭秤端测量心率功能（秤需要支持才行），默认不关闭
@property(nonatomic, assign) BOOL isCloseHeartRate;

/// 关闭测量脂肪(部分设备支持)，默认 NO，测量脂肪
@property(nonatomic, assign) BOOL isCloseMeasureFat;
/// 关闭测量脂肪是否是长期有效(部分设备支持)，默认 NO，单次链接有效
@property(nonatomic, assign) BOOL isLongTimeValid;
@end

NS_ASSUME_NONNULL_END
