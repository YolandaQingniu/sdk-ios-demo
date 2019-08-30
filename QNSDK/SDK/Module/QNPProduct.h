//
//  QNPProduct.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/15.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNPProduct : NSObject
/** 轻牛ID */
@property (nonatomic, strong) NSString *qnId;
/** 阿里ID */
@property (nonatomic, strong, nullable) NSString *aliId;
/** 秤体自身最小重量 */
@property (nonatomic, strong) NSString *scaleMin;
/** 秤体自身最大重量 */
@property (nonatomic, strong) NSString *scaleMax;
/** 秤体超载重量 */
@property (nonatomic, strong) NSString *overWeight;
/** 电池类型 */
@property (nonatomic, assign) int batteryNum;
/** 是否支持心率 */
@property(nonatomic, assign) BOOL isSupportHeartRate;
@end

NS_ASSUME_NONNULL_END
