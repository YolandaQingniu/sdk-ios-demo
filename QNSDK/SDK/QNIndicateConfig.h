//
//  QNIndicateConfig.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/7/1.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNIndicateConfig : NSObject
/// 是否显示用户名
@property(nonatomic, assign) BOOL showUserName;
/// 是否显示BMI
@property(nonatomic, assign) BOOL showBmi;
/// 是否显示骨量
@property(nonatomic, assign) BOOL showBone;
/// 是否显示体脂率
@property(nonatomic, assign) BOOL showFat;
/// 是否显示肌肉量
@property(nonatomic, assign) BOOL showMuscle;
/// 是否显示体水分
@property(nonatomic, assign) BOOL showWater;
/// 是否显示心率
@property(nonatomic, assign) BOOL showHeartRate;
/// 是否显示天气
@property(nonatomic, assign) BOOL showWeather;
@end

NS_ASSUME_NONNULL_END
