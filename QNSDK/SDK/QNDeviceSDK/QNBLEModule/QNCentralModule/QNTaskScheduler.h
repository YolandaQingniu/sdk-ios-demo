//
//  QNTaskScheduler.h
//  Pods
//
//  Created by qiudongquan on 2019/8/21.
//

#import <Foundation/Foundation.h>
@class QNTaskScheduler;

NS_ASSUME_NONNULL_BEGIN

typedef void(^QNTaskExecutCallback)(QNTaskScheduler *task);
typedef NSError* _Nullable (^QNTaskExecutCheckCallback)(QNTaskScheduler *task);

typedef void(^QNTaskCompleteCallback)(QNTaskScheduler *task, __nullable id responseData, NSError * _Nullable err);


@interface QNTaskScheduler : NSOperation

@property(nonatomic, strong, readonly) id data;

- (instancetype)initWithData:(_Nullable id)data timeInterval:(NSTimeInterval)timeInterval executCheckCallback:(_Nullable QNTaskExecutCheckCallback)executCheckCallback executCallback:(_Nullable QNTaskExecutCallback)executCallback completeCallback:(_Nullable QNTaskCompleteCallback)completeCallback;

- (void)cancelResponseTimer;

- (void)extendTaskSchedulerTimerWithInterval:(NSTimeInterval)timeInterval;

- (void)updateResponseData:(nullable id)data;

- (void)completeTaskWithResponseData:(nullable id)data err:(nullable NSError *)err;


@end

NS_ASSUME_NONNULL_END
