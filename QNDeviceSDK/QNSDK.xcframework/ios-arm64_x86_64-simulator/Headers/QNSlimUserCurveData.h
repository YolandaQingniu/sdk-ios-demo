//
//  QNSlimUserCurveData.h
//  QNDeviceSDK
//
//  Created by yolanda on 2025/10/27.
//  Copyright © 2025 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNSlimUserCurveData : NSObject
/// 曲线体重数据数组，用于存储体重曲线上的体重数据点。 体重数据单位为千克（kg）
@property (nonatomic, strong) NSArray<NSNumber *> *curveWeightArr;
/// YES：最后一个有效体重（WEIGHT14）是今日测量的数据   NO：最后一个有效体重不是今日测量的数据
@property (nonatomic, assign) BOOL todayFlag;

@end

NS_ASSUME_NONNULL_END
