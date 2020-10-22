//
//  QNConnectConfig.h
//  QNDeviceTest
//
//  Created by donyau on 2018/9/17.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNConnectConfig : NSObject
//默认15s超时
@property (nonatomic, assign) double connectOverTime;
@property (nonatomic, assign) BOOL notifyOnConnection;
@property (nonatomic, assign) BOOL notifyOnDisconnection;
@property (nonatomic, assign) BOOL notifyOnNotification;
@end

NS_ASSUME_NONNULL_END
