//
//  QNBandThirdRemind.h
//  QNBandModule_iOS
//
//  Created by donyau on 2018/10/9.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNBandThirdRemind : NSObject
/** 来电提醒 */
@property (nonatomic, assign) BOOL callRemind;
/** 来电提醒延时时间 */
@property (nonatomic, assign) NSUInteger callDelay;
@property (nonatomic, assign) BOOL sms;
@property (nonatomic, assign) BOOL faceBook;
@property (nonatomic, assign) BOOL WeChat;
@property (nonatomic, assign) BOOL QQ;
@property (nonatomic, assign) BOOL twitter;
@property (nonatomic, assign) BOOL whatesapp;
@property (nonatomic, assign) BOOL linkedIn;
@property (nonatomic, assign) BOOL instagram;
@property (nonatomic, assign) BOOL faceBookMessenger;
@property (nonatomic, assign) BOOL calendar;
@property (nonatomic, assign) BOOL email;
@property (nonatomic, assign) BOOL skype;
@property (nonatomic, assign) BOOL pokeman;
@end

NS_ASSUME_NONNULL_END
