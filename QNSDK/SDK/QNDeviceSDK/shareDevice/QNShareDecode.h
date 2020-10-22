//
//  QNDecode.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/1/24.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNDecodeResult : NSObject

@property (nullable, nonatomic, strong) NSString *sn;

@property (nonatomic, assign) double weight;

@property (nonatomic, assign) int resistance;

@property (nonatomic, assign) int secResistance;

@property (nonatomic, assign) NSTimeInterval measureTime;

@property (nullable, nonatomic, strong) NSError *error;

@end

@interface QNShareDecode : NSObject

+ (QNDecodeResult *)decodeWithCodeStr:(NSString *)codeStr validTime:(long)validTime;

@end

NS_ASSUME_NONNULL_END
