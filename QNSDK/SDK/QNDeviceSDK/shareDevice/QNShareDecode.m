//
//  QNDecode.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/1/24.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "QNShareDecode.h"
#import "NSError+QNAPI.h"

@implementation QNDecodeResult

@end

#define QNCodeStrCodeFirst @"c"
#define QNCodeStrCodeSecond @"code"

#define QNCodeTimeStamp @"timestamp"

@implementation QNShareDecode

+ (NSDictionary *)parameterWithURL:(NSString *)urlStr {
    
    NSMutableDictionary<NSString *,NSString *> *parm = [[NSMutableDictionary alloc] init];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:urlStr];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    return parm;
}

+ (QNDecodeResult *)decodeWithCodeStr:(NSString *)codeStr validTime:(long)validTime{
    
    QNDecodeResult *result = [[QNDecodeResult alloc] init];
    
    if ([codeStr isKindOfClass:[NSString class]] == NO) {
        result.error = [NSError errorCode:QNBleErrorCoder];
        return result;
    };
    
    NSDictionary *params = [self parameterWithURL:codeStr];
    
    NSString *targetHexCode = nil;
    if ([params.allKeys containsObject:QNCodeStrCodeFirst]) {
        targetHexCode = [params valueForKey:QNCodeStrCodeFirst];
    }else if ([params.allKeys containsObject:QNCodeStrCodeSecond]) {
        targetHexCode = [params valueForKey:QNCodeStrCodeSecond];
    }
    
    NSURL *codeUrl = [NSURL URLWithString:codeStr];
    if (targetHexCode == nil && [codeUrl.host containsString:@"yolanda.hk"]) {
        targetHexCode = [NSURL URLWithString:codeStr].lastPathComponent;
    }
    
    if (targetHexCode == nil) {
        targetHexCode = codeStr;
    }
    
    if (targetHexCode.length != 24) {
        result.error = [NSError errorCode:QNBleErrorCoder];
        return result;
    };
    
    NSTimeInterval measureTimeStamp = 0;
    if ([params.allKeys containsObject:QNCodeTimeStamp]) {
        measureTimeStamp = [[params valueForKey:QNCodeTimeStamp] doubleValue];
    }
    
    NSTimeInterval currentTimeStamp = [[NSDate date] timeIntervalSince1970];
    if (measureTimeStamp > 0.0001 && validTime > 0) {
        if (currentTimeStamp - measureTimeStamp > validTime) {
            result.error = [NSError errorCode:QNBleErrorCoderInvalid];
            return result;
        }
    }
    
    //测量时间
    result.measureTime = measureTimeStamp > 0 ? measureTimeStamp : currentTimeStamp;

    Byte a1tmp[4], a2tmp[4], a3tmp[4];
    [self byteArray:[self moveWithTmp:[self strUInt32:[targetHexCode substringWithRange:NSMakeRange(0, 8)]]] bytes:a1tmp];
    [self byteArray:[self moveWithTmp:[self strUInt32:[targetHexCode substringWithRange:NSMakeRange(8, 8)]]] bytes:a2tmp];
    [self byteArray:[self moveWithTmp:[self strUInt32:[targetHexCode substringWithRange:NSMakeRange(16, 8)]]] bytes:a3tmp];

    Byte x[4] = {0x43, 0x4A, 0x58, 0x4C};
    Byte y[4] = {0x57, 0x46, 0x53, 0x4D};
    
    for (int i = 0; i < 4; i ++) {
        a1tmp[i] = a1tmp[i] ^ x[i];
        a2tmp[i] = a2tmp[i] ^ y[i];
        a3tmp[i] = a3tmp[i] ^ x[i];
    }
    
    Byte a1[4] = {a1tmp[1],a1tmp[3],a1tmp[0],a1tmp[2]};
    Byte a2[4] = {a2tmp[1],a2tmp[2],a2tmp[3],a2tmp[0]};
    Byte a3[4] = {a3tmp[1],a3tmp[3],a3tmp[0],a3tmp[2]};

    result.sn = [NSString stringWithFormat:@"%02X%02X%02X",a1[1],a1[2],a1[3]];
    result.weight = ((a2[0] << 8) + a2[1]) / 100.0;
    int resistance = (a2[2] << 8) + a2[3];
    int resistance500 = (a3[1] << 8) + a3[2];

    result.resistance = (resistance * 2 + resistance500 * 3) / 13;
    result.secResistance = (resistance * 9 - resistance500 * 6) / 39;
    return result;
}

+ (UInt32)strUInt32:(NSString *)str {
    unsigned int tmp = 0;
    [[NSScanner scannerWithString:str] scanHexInt:&tmp];
    return tmp;
}

+ (void)byteArray:(UInt32)num bytes:(Byte[])bytes{
    bytes[0] = (num >> 24) & 0xFF;
    bytes[1] = (num >> 16) & 0xFF;
    bytes[2] = (num >> 8) & 0xFF;
    bytes[3] = (num >> 0) & 0xFF;
}


+ (UInt32)moveWithTmp:(UInt32)tmp {
    UInt32 t1 = tmp >> 17;
    UInt32 t2 = tmp << 15;
    return t1 | t2;
}

@end
