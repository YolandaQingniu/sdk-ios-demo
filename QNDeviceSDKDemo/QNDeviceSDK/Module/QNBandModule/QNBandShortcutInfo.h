//
//  QNBandShortcutInfo.h
//  QNBandModule
//
//  Created by donyau on 2018/12/26.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNBandEnum.h"
#import "QNBandUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBandShortcutInfo : NSObject
/** 心率检测 */
@property (nonatomic, assign) BOOL autoHeartRateFlag;
/** 抬腕亮屏 */
@property (nonatomic, assign) BOOL handRecognizeFlag;
/** 查找手机 */
@property (nonatomic, assign) BOOL findPhoneFlag;
/** 防丢提醒 */
@property (nonatomic, assign) BOOL lossRemindFlag;
/** 年龄 */
@property (nonatomic, assign) NSUInteger age;
/** 性别 */
@property (nonatomic, assign) QNBandGender gender;
/** 体重 */
@property (nonatomic, assign) float weight;
/** 身高 */
@property (nonatomic, assign) float height;
/** 目标步数 */
@property (nonatomic, assign) NSUInteger sportGoal;
/** 距离单位 */
@property (nonatomic, assign) QNBandUnitStype unit;
/** 语言 */
@property (nonatomic, assign) QNBandLanguageStype language;
/** 小时 */
@property (nonatomic, assign) QNBandHourFormat hourFormat;
@end

NS_ASSUME_NONNULL_END
