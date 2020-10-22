//
//  QNWspTarget.h
//  Pods
//
//  Created by qiudongquan on 2020/6/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNWspTarget : NSObject
/// 昵称
@property(nonatomic, assign) BOOL nick;
/// BMI
@property(nonatomic, assign) BOOL bmi;
/// 骨量
@property(nonatomic, assign) BOOL bone;
/// 体脂率
@property(nonatomic, assign) BOOL bodyfat;
/// 肌肉量
@property(nonatomic, assign) BOOL sinew;
/// 水分
@property(nonatomic, assign) BOOL water;
/// 心率
@property(nonatomic, assign) BOOL hearRate;
/// 天气
@property(nonatomic, assign) BOOL weather;
@end

NS_ASSUME_NONNULL_END
