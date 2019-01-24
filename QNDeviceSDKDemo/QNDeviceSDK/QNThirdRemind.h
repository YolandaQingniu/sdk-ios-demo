//
//  QNThirdRemind.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/1/3.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNThirdRemind : NSObject
/** 来电提醒 */
@property (nonatomic, assign) BOOL call;
/** 来电提醒延迟时间，至少3s */
@property (nonatomic, assign) int callDelay;
/** sms提醒 */
@property (nonatomic, assign) BOOL sms;
/** faceBook提醒 */
@property (nonatomic, assign) BOOL faceBook;
/** 微信提醒 */
@property (nonatomic, assign) BOOL WeChat;
/** QQ提醒 */
@property (nonatomic, assign) BOOL QQ;
/** twitter提醒 */
@property (nonatomic, assign) BOOL twitter;
/** whatesapp提醒 */
@property (nonatomic, assign) BOOL whatesapp;
/** linkedIn提醒 */
@property (nonatomic, assign) BOOL linkedIn;
/** instagram提醒 */
@property (nonatomic, assign) BOOL instagram;
/** faceBookMessenger提醒 */
@property (nonatomic, assign) BOOL faceBookMessenger;
/** calendar提醒 */
@property (nonatomic, assign) BOOL calendar;
/** email提醒 */
@property (nonatomic, assign) BOOL email;
/** skype提醒 */
@property (nonatomic, assign) BOOL skype;
/** pokeman提醒 */
@property (nonatomic, assign) BOOL pokeman;
@end

NS_ASSUME_NONNULL_END
