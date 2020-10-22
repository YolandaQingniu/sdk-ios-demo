//
//  QNAdvertScaleData.h
//  Pods
//
//  Created by donyau on 2018/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNAdvertScaleData : NSObject
/** 体重 */
@property (nonatomic, assign) double weight;
/** 测量的时间戳 */
@property (nonatomic, assign) NSTimeInterval timeTemp;
/** 50电阻的值 */
@property (nonatomic, assign) NSUInteger resistance;
@end

NS_ASSUME_NONNULL_END
