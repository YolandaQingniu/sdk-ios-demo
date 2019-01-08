//
//  QNBandHeartRate.h
//  QNBandModule_iOS
//
//  Created by donyau on 2018/10/10.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNBandHeartRateItem : NSObject
/** 当前序号 */
@property (nonatomic, assign) NSUInteger curCNT;
/** 距离上次测量的偏移(minture) */
@property (nonatomic, assign) NSUInteger offset;
/** 心率值 */
@property (nonatomic, assign) NSUInteger heartRate;

@end

@interface QNBandHeartRate : NSObject
/** 时间戳 */
@property (nonatomic, assign) NSTimeInterval recordTimeStamp;
/** 平稳心率 */
@property (nonatomic, assign) NSUInteger slientHeartRate;
/** 脂肪燃烧 */
@property (nonatomic, assign) NSUInteger burnFatThreshold;
/** 有氧锻炼 */
@property (nonatomic, assign) NSUInteger aerobicThreshold;
/** 极限锻炼 */
@property (nonatomic, assign) NSUInteger limitThreshold;
/** 心率详情 */
@property (nonatomic, strong) NSMutableArray<QNBandHeartRateItem *> *heartRateItemAll;
@end

NS_ASSUME_NONNULL_END
