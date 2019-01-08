//
//  QNBandSleep.h
//  QNBandModule_iOS
//
//  Created by donyau on 2018/10/10.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QNBandSleepStype) {
    QNBandSleepSober = 1,
    QNBandSleepLight,
    QNBandSleepDeep,
};

NS_ASSUME_NONNULL_BEGIN

@interface QNBandSleepItem : NSObject
/** 当前序号 */
@property (nonatomic, assign) NSUInteger curCNT;
/** 睡眠类型(1 清醒 2 浅度 3 深度) */
@property (nonatomic, assign) QNBandSleepStype sleepType;
/** 睡眠时间 */
@property (nonatomic, assign) NSUInteger sleepTime;

@end

@interface QNBandSleep : NSObject
/** 时间戳*/
@property (nonatomic, assign) NSTimeInterval recordTimeStamp;
/** 睡醒距离凌晨的偏移(minture) */
@property (nonatomic, assign) NSUInteger giveUpOffset;
/** 总睡眠时间(minture) */
@property (nonatomic, assign) NSUInteger sumSleepTime;
/** 深睡时间(minture) */
@property (nonatomic, assign) NSUInteger deepSleepTime;
/** 浅睡时间(minture) */
@property (nonatomic, assign) NSUInteger lightSleepTime;
/** 睡眠详情 */
@property (nonatomic, strong) NSMutableArray<QNBandSleepItem *> *sleepItemAll;
@end

NS_ASSUME_NONNULL_END
