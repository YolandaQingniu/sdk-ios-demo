//
//  QNCategory.h
//  QNCentralModule_iOS
//
//  Created by donyau on 2018/11/5.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

#define setAssociatedObject(key,value) objc_setAssociatedObject(self, &key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#define getAssociatedObject(key) objc_getAssociatedObject(self, &key);

@interface NSTimer (QNTimer)
+ (NSTimer *)qnCentralScheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;
@end

@interface NSObject (QNKVO)
- (void)qnAddObserverBlockForKeyPath:(NSString*)keyPath block:(void (^)(id _Nonnull obj, _Nullable id oldVal, _Nullable id newVal))block;
- (void)qnRemoveObserverBlocksForKeyPath:(NSString*)keyPath;
@end

NS_ASSUME_NONNULL_END
