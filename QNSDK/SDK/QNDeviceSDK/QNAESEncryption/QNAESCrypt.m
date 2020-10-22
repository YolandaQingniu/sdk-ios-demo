//
//  QNAESCrypt.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#define gkey @"yolandakitnewhdr"
#define gIv @"0000000000000000" 

#import "QNAESCrypt.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+QNBase64.h"
#import "NSString+QNBase64.h"

@implementation QNAESCrypt

+ (NSString *)AES128Encrypt:(NSString *)plainText {
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [gkey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    // int diff = 0;
    int newSize = 0;
    
    if(diff > 0)
    {
        newSize = (int)dataLength + diff;
    }
    
    char dataPtr[newSize];
    memcpy(dataPtr, [data bytes], [data length]);
    for(int i = 0; i < diff; i++)
    {
        dataPtr[i + dataLength] = 0x00;
    }
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode | kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        NSString *string2 = @"";
        
        const uint8_t *bytes = resultData.bytes;
        for (int i = 0; i < resultData.length; i++)
        {
            string2=[string2 stringByAppendingFormat:@"%02x", bytes[i]];
        }
        return string2;
    }
    free(buffer);
    return nil;
}


+ (NSString *)AES128Decrypt:(NSString *)encryptText {
    if (encryptText.length % 2 != 0) {
        return nil;
    }
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [gkey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [self stringTodata:encryptText];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode | kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        NSString *s = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        //切除/0
        return  [s stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    }
    free(buffer);
    return nil;
}


+ (NSData *)stringTodata:(NSString *) hexString{
    hexString = [hexString lowercaseString];
    int l= (int)[hexString length] /2;
    // 将16进制数据转化成Byte数组
    int j=0;
    Byte bytes[l];
    for(int i=0;i<[hexString length];i++)
    {
        // 两位16进制数转化后的10进制数
        int int_ch;
        //两位16进制数中的第一位(高位*16)
        unichar hex_char1 = [hexString characterAtIndex:i];
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        
        i++;
        ///两位16进制数中的第二位(低位)
        unichar hex_char2 = [hexString characterAtIndex:i];
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        int_ch = int_ch1+int_ch2;
        //将转化后的数放入Byte数组里
        bytes[j] = int_ch;
        j++;
    }
    return [[NSData alloc] initWithBytes:bytes length:l];
}


#pragma mark 256加密
+ (NSString *)encrypt:(NSString *)message password:(NSString *)password {
    NSData *encryptedData = [[message dataUsingEncoding:NSUTF8StringEncoding] qnAES256EncryptedDataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] qnSHA256Hash] error:nil];
    NSString *base64EncodedString = [NSString qnBase64StringFromData:encryptedData length:[encryptedData length]];
    return base64EncodedString;
}

#pragma mark 256解密
+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password {
    if (base64EncodedString.length % 2 != 0) {
        return nil;
    }
    NSData *encryptedData = [NSData qnBase64DataFromString:base64EncodedString];
    NSData *decryptedData = [encryptedData qndecryptedAES256DataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] qnSHA256Hash] error:nil];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}


@end
