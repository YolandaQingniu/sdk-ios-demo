//
//  NSString+QNBase64.h
//  QNDeviceSDK
//
//  Created by com.qn.device on 2018/3/7.
//  Copyright © 2018年 com.qn.device. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YLBase64)

+ (NSString *)qnBase64StringFromData:(NSData *)data length:(NSUInteger)length;

@end
