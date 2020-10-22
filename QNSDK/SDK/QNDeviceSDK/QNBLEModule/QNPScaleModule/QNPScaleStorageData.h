//
//  QNPScaleStorageData.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/15.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNPScaleEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNPScaleStorageData : NSObject
/** 体重 */
@property (nonatomic, assign) double weight;
/** 测量的时间戳 */
@property (nonatomic, assign) NSTimeInterval timeTemp;
/** 50电阻的值 */
@property (nonatomic, assign) NSUInteger resistance;
/** 500电阻的值 */
@property (nonatomic, assign) NSUInteger secResistance;
/** 秤中的总存储数据 */
@property (nonatomic, assign) NSUInteger total;
/** 秤上传的当前存储数据 */
@property (nonatomic, assign) NSUInteger curCNT;
/** 心率秤测得的心率值 */
@property (nonatomic, assign) NSUInteger heartRate;

/** 左侧重量(左右平衡秤专属) */
@property (nonatomic, assign) double leftWeight;;
/** 右侧重量(左右平衡秤专属) */
@property (nonatomic, assign) double rightWeight;;
@end

NS_ASSUME_NONNULL_END
