//
//  QNDebug.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNDebug.h"
#import "QNBleApi.h"

@interface QNDebug ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation QNDebug
static QNDebug *qnDebug = nil;
static BOOL _debugLog = NO;

+ (void)setDebug:(BOOL)debug {
    _debugLog = debug;
}

+ (BOOL)debug {
    return _debugLog;
}

+ (QNDebug *)sharedDebug {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        qnDebug = [QNDebug alloc];
    });
    return qnDebug;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        qnDebug = [[super allocWithZone:zone] init];
    });
    return qnDebug;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"HH:mm:ss SSS"];
    }
    return _dateFormatter;
}

- (NSString *)currentTime {
    NSDate *date = [NSDate date];
    NSString *time = [self.dateFormatter stringFromDate:date];
    return time;
}

- (void)log:(NSString *)meg {
    if ([[QNBleApi sharedBleApi].logListener respondsToSelector:@selector(onLog:)]) {
        [[QNBleApi sharedBleApi].logListener onLog:meg];
    }
    
    if (QNDebug.debug) {
        NSString *log = [NSString stringWithFormat:@"[** %@ %@ **] %@\n",[self currentTime],QNDEBUG_IDENTIFIER,meg];
        printf("%s", [log UTF8String]);
    }
}


@end
