//
//  QNBandClear.h
//  QNBandModule_iOS
//
//  Created by donyau on 2018/10/9.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNBandClear : NSObject
/** 默认为 Yes */
@property (nonatomic, assign) BOOL alarm;
/** 默认为 Yes */
@property (nonatomic, assign) BOOL goal;
/** 默认为 Yes */
@property (nonatomic, assign) BOOL unit;
/** 默认为 Yes */
@property (nonatomic, assign) BOOL sitRemind;
/** 默认为 Yes */
@property (nonatomic, assign) BOOL lossRemind;
/** 默认为 Yes */
@property (nonatomic, assign) BOOL wearMode;
/** 默认为 Yes */
@property (nonatomic, assign) BOOL heartRateOpen;
/** 默认为 Yes */
@property (nonatomic, assign) BOOL handRecoginzeOpen;
/** 默认为 Yes */
@property (nonatomic, assign) BOOL screenMode;
/** 默认为 默认为 NO */
@property (nonatomic, assign) BOOL bindState;
/** 不可设置 默认为 NO */
@property (nonatomic, assign, readonly) BOOL flash;
/** 默认为 Yes */
@property (nonatomic, assign) BOOL thirdRemindState;

@end

NS_ASSUME_NONNULL_END
