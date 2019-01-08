//
//  QNPProduct.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/15.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QNPScaleBatteryStype) {
     QNPScaleBatteryFour = 0,
     QNPScaleBatteryThree = 1,
     QNPScaleBatteryCharge = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface QNPProduct : NSObject
/** 轻牛ID */
@property (nonatomic, assign) NSUInteger QNID;
/** 阿里ID */
@property (nonatomic, assign) NSUInteger ALIID;
/** 秤体自身最小重量 */
@property (nonatomic, assign) NSUInteger scaleMin;
/** 秤体自身最大重量 */
@property (nonatomic, assign) NSUInteger scaleMax;
/** 秤体超载重量 */
@property (nonatomic, assign) NSUInteger overWeight;
/** 电池类型 */
@property (nonatomic, assign) QNPScaleBatteryStype batteryMode;
/** BatteryInfo */
@property (nonatomic, assign, readonly) Byte batteryByte;
@end

NS_ASSUME_NONNULL_END
