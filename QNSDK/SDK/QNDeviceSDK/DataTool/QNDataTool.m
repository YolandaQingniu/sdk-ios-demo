//
//  QNDataTool.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/4/26.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNDataTool.h"
#import "NSError+QNAPI.h"

static QNDataTool *dataTool = nil;

@interface QNDataTool ()

@end

@implementation QNDataTool

+ (QNDataTool *)sharedDataTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataTool = [QNDataTool alloc];
    });
    return dataTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataTool = [[super allocWithZone:zone] init];
    });
    return dataTool;
}

- (instancetype)init {
    if (self = [super init]) {
        self.fileManager = [NSFileManager defaultManager];
        self.sdkFilePath =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:QNSDKInfoFileName];
        if ([self.fileManager fileExistsAtPath:self.sdkFilePath] == NO) {
            [self.fileManager createDirectoryAtPath:self.sdkFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

#pragma mark -
- (NSString *)dictionaryToJson:(NSDictionary *)dictionary {
    if (dictionary == nil) {
        return nil;
    }
    NSData *jsonData = nil;
    @try {
        NSError *error = nil;
        jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    } @catch (NSException *exception) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)jsonTodictionary:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        return nil;
    }
    return dic;
}

#pragma mark -
- (NSString *)toString:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        return str;
    }else{
        return nil;
    }
}

- (NSInteger)toInteger:(id)obj {
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj integerValue];
    }else if ([obj isKindOfClass:[NSString class]]) {
        return [obj integerValue];
    }else{
        return 0;
    }
}

- (double)toDouble:(id)obj {
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj doubleValue];
    }else if ([obj isKindOfClass:[NSString class]]) {
        return [obj doubleValue];
    }else{
        return 0;
    }
}

#pragma mark -
- (double)convertWeightWithTargetUnit:(double)weight unit:(QNUnit)unit {
    if (unit == QNUnitLB || unit == QNUnitST) {
        return ((int)(((weight * 100) * 11023 + 50000)/100000) << 1 ) / 10.0;
    } else if (unit == QNUnitJIN) {
        return weight * 2;
    } else if (unit == QNUnitOZ || unit == QNUnitLBOZ) {
        int num =  (((weight * 3527) + 5000) / 10000) / 10.0 * 10 / 1;
        return num / 10.0;
    } else if (unit == QNUnitML) {
        return weight;
    } else {
        return weight;
    }
}
@end
