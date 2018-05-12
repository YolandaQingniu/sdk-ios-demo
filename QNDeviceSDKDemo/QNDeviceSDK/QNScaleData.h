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
@property (nonatomic, readonly, strong) QNUser *user;

/** 测量数据测量时间 */
@property (nonatomic, readonly, strong) NSDate *measureTime;

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


@end
