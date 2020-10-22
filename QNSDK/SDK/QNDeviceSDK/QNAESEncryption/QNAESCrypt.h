//
//  QNAESCrypt.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QNBase64)

+ (NSString *)qnBase64StringFromData:(NSData *)data length:(NSUInteger)length;

@end


@interface QNAESCrypt : NSObject

//加密
+ (NSString *)AES128Encrypt:(NSString *)plainText;

//解密
+ (NSString *)AES128Decrypt:(NSString *)encryptText;

//256加密
+ (NSString *)encrypt:(NSString *)message password:(NSString *)password;

//256解密
+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password;

@end
