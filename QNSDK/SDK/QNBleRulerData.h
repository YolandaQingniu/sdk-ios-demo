//
//  QNBleRulerData.h
//  QNDeviceSDK
//
//  Created by sumeng on 2022/7/5.
//  Copyright © 2022 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QNBleRulerUnit) {
    QNBleRulerUnitCM = 0,
    QNBleRulerUnitIN = 1,
};

@interface QNBleRulerData : NSObject
/** 数值 */
@property (nonatomic, assign) double value;

/** 单位 */
@property (nonatomic, assign) QNBleRulerUnit unit;
@end

NS_ASSUME_NONNULL_END
