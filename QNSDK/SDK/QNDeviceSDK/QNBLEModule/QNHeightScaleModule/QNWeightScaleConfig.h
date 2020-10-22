//
//  QNWeightScaleConfig.h
//  Pods
//
//  Created by qiudongquan on 2020/6/10.
//

#import <Foundation/Foundation.h>
#import "QNHeightScaleEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNWeightScaleConfig : NSObject
@property(nonatomic, assign) QNHeightScaleUnitMode unit;
@property(nonatomic, assign) NSInteger connectOverTime;

@end

NS_ASSUME_NONNULL_END
