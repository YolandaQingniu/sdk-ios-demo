//
//  QNHeightDeviceConfig.h
//  QNDeviceSDK
//
//  Created by yolanda on 2025/8/28.
//  Copyright © 2025 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNWiFiConfig.h"
#import "QNUser.h"
NS_ASSUME_NONNULL_BEGIN

#pragma mark 秤语音播报设置
typedef NS_ENUM(int, QNHeightVoiceLanguageType) {
    QNHeightVoiceLanguageTypeNone = -1, //如果是设置语音播报语种，则代表"不切换"；如果是获取当前语音播报语种，则代表"未知"
    QNHeightVoiceLanguageTypeZH = 0, //中文语音播报
    QNHeightVoiceLanguageTypeEN = 1, //英文语音播报
    QNHeightVoiceLanguageTypeARABIC = 2 //阿拉伯语音播报
};


#pragma mark 秤单位设置
typedef NS_ENUM(int, QNHeightWeightUnitMode) {
    QNHeightWeightUnitNone = -1, //如果是设置单位，则代表"不切换"；如果是获取当前单位，则代表"未知"
    QNHeightWeightUnitKg    = 0,
    QNHeightWeightUnitLb    = 1,
    QNHeightWeightUnitJin   = 2, //若秤不支持斤的显示，则显示KG
    QNHeightWeightUnitStLb  = 3, //若秤不支持STLB的显示，则显示lb
    QNHeightWeightUnitSt    = 4, //若秤不支持ST的显示，则显示lb
};

#pragma mark 秤身高单位设置
typedef NS_ENUM(int, QNHeightHeightUnitMode) {
    QNHeightHeightUnitNone = -1,//如果是设置单位，则代表"不切换"；如果是获取当前单位，则代表"未知"
    QNHeightHeightUnitCm = 0,
    QNHeightHeightUnitFtIn = 1,
    QNHeightHeightUnitIn = 2,
    QNHeightHeightUnitFt = 3,
};

/// 当前使用模式
typedef NS_ENUM(int, QNHeightUserMode) {
    QNHeightUserModeNone = -1, //如果是设置场景（用户模式），则代表"不切换"；如果是获取当前场景（用户模式），则代表"未知"
    QNHeightUserModeHousehold = 0, // 家用模式
    QNHeightUserModeCommercial = 1,   // 商用模式（公共模式）
    QNHeightUserModeScanCode = 2     // 扫码枪模式(属于家用模式)
};

//新协议设置功能（体重单位、身高单位等）
typedef struct {
    QNHeightWeightUnitMode weightUnit; //体重单位
    QNHeightHeightUnitMode heightUnit; //身高单位
    QNHeightVoiceLanguageType voiceLanguage; //语音播报语种
    QNHeightUserMode userMode; //用户模式（使用场景）
} QNHeightDeviceSetFunction;

typedef struct {
    BOOL weightUnitSetResult; //体重单位设置结果
    BOOL heighUnitSetResult; //身高单位设置结果
    BOOL voiceLanguageSetResult; //语音播报语种设置结果
    BOOL userModeSetResult; //用户模式（使用场景）设置结果
} QNHeightDeviceSetFunctionResult;


@interface QNHeightDeviceConfig : NSObject
/// wifi配置对象
@property (nullable, nonatomic, strong) QNWiFiConfig *wifiConfig;

/// 当前测量用户
@property (nullable, nonatomic, strong) QNUser *curUser;

@end

NS_ASSUME_NONNULL_END
