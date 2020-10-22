//
//  NSString+QNBase64.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QNBase64)

+ (NSString *)qnBase64StringFromData:(NSData *)data length:(NSUInteger)length;

@end
