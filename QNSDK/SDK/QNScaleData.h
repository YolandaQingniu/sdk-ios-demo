//
//  QNScaleData.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNUser.h"
#import "QNScaleItemData.h"

@interface QNScaleData : NSObject

/** 测量数据的拥有者 */
@property (nonatomic, strong, readonly) QNUser *user;

/** 测量数据测量时间 */
@property (nonatomic, strong, readonly) NSDate *measureTime;

/** 数据标识 */
@property (nonatomic, strong, readonly) NSString *hmac;

- (instancetype)init NS_UNAVAILABLE;

/**
 通过调用该方法获取当个指标的详情

 @param type QNScaleType
 @return QNScaleItemData
 */
- (QNScaleItemData *)getItem:(QNScaleType)type;

/**
 获取当个指标的数值

 @param type QNScaleType
 @return 指标数值
 */
- (double)getItemValue:(QNScaleType)type;

/**
 获取该次测量后的指标详情

 @return 指标详情的集合
 */
- (NSArray <QNScaleItemData *> *)getAllItem;

/**
 体脂变化控制

 @param threshold 控制变化范围
 @param hmac 上次测量的数据标识
 @param callback 是否控制成功的回调
 */
- (void)setFatThreshold:(double)threshold hmac:(NSString *)hmac callBlock:(QNResultCallback)callback;

@end
