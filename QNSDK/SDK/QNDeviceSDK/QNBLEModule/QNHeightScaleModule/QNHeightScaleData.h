//
//  QNHeightScaleData.h
//  Pods
//
//  Created by qiudongquan on 2020/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNHeightScaleData : NSObject
/** 体重 */
@property (nonatomic, assign) double weight;
/** 测量的时间戳 */
@property (nonatomic, assign) NSTimeInterval timeTemp;
/** 50电阻的值 */
@property (nonatomic, assign) NSUInteger resistance;
/** 500电阻的值 */
@property (nonatomic, assign) NSUInteger secResistance;
/** 身高 */
@property (nonatomic, assign) double height;
/** 是否是体脂模式 */
@property(nonatomic, assign) BOOL isBodyFatMode;
@end

NS_ASSUME_NONNULL_END
