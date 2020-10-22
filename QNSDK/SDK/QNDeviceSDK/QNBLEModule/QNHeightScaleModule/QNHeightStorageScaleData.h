//
//  QNHeightStorageScaleData.h
//  Pods
//
//  Created by qiudongquan on 2020/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNHeightStorageScaleData : NSObject
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
/** 身高 */
@property (nonatomic, assign) double height;
/** 心率 */
@property (nonatomic, assign) NSUInteger heartRate;
@end

NS_ASSUME_NONNULL_END
