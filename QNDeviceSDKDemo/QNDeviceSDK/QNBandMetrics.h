//
//  QNBandMetrics.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/1/3.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QNBandLengthMode) {
    QNBandLengthModeMetric  = 0,
    QNBandLengthModeBritish = 1,
};

typedef NS_ENUM(NSUInteger, QNBandLanguageMode) {
    QNBandLanguageModeChina  = 0,
    QNBandLanguageModeEnglish = 1,
};

typedef NS_ENUM(NSUInteger, QNBandFormatHourMode) {
    QNBandFormatHourMode24  = 0,
    QNBandFormatHourMode12 = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface QNBandMetrics : NSObject
/** 长度 */
@property (nonatomic, assign) QNBandLengthMode length;
/** 语言 */
@property (nonatomic, assign) QNBandLanguageMode language;
/** 小时制 */
@property (nonatomic, assign) QNBandFormatHourMode formatHour;
@end

NS_ASSUME_NONNULL_END
