//
//  QNBandSport.h
//  QNBandModule_iOS
//
//  Created by donyau on 2018/10/10.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNBandSportItem : NSObject
/** 当前序号 */
@property (nonatomic, assign) NSUInteger curCNT;
/** 运动类型(未知) */
@property (nonatomic, assign) NSUInteger sportType;
/** 运动步数 */
@property (nonatomic, assign) NSUInteger step;
/** 运动时间 */
@property (nonatomic, assign) NSUInteger activeTime;
/** 卡路里 */
@property (nonatomic, assign) NSUInteger calories;
/** 距离 */
@property (nonatomic, assign) NSUInteger distance;
@end

@interface QNBandSport : NSObject
/** 时间戳 */
@property (nonatomic, assign) NSTimeInterval recordTimeStamp;
/** 开始记录时间的偏移（离凌晨的分钟数）*/
@property (nonatomic, assign) NSUInteger startRecordTimeOffset;
/** 每组的时间间隔 */
@property (nonatomic, assign) NSUInteger itemTimeInterval;
/** 当天总步数 */
@property (nonatomic, assign) NSUInteger sumStep;
/** 当天卡路里 */
@property (nonatomic, assign) NSUInteger sumCalories;
/** 当天总运动距离 */
@property (nonatomic, assign) NSUInteger sumDistance;
/** 当天运动时间 */
@property (nonatomic, assign) NSUInteger sumActiveTime;
/** 运动详情 */
@property (nonatomic, strong) NSMutableArray<QNBandSportItem *> *sportItemAll;
@end

NS_ASSUME_NONNULL_END
