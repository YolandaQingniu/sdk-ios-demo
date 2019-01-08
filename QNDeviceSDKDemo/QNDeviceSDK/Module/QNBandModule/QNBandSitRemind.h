//
//  QNBandSitRemind.h
//  QNBandModule_iOS
//
//  Created by donyau on 2018/10/9.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    BOOL monFlag;
    BOOL tusFlag;
    BOOL wedFlag;
    BOOL thuFlag;
    BOOL firFlag;
    BOOL satFlag;
    BOOL sunFlag;
} QNLongSitWeek;

@interface QNBandSitRemind : NSObject

@property (nonatomic, assign) BOOL openFlag;

@property (nonatomic, assign) NSUInteger startHour;

@property (nonatomic, assign) NSUInteger startMinture;

@property (nonatomic, assign) NSUInteger endHour;

@property (nonatomic, assign) NSUInteger endMinture;
/** 15 mins ~ 180 mins*/
@property (nonatomic, assign) NSUInteger timeInterval;
/* 重复周期 */
@property (nonatomic, assign) QNLongSitWeek weekRepeat;

@end

NS_ASSUME_NONNULL_END
