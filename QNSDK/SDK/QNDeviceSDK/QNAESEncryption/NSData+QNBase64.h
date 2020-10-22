//
//  NSData+QNBase64.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

extern NSString * const QNCommonCryptoErrorDomain;

@interface NSData (QNBase64)

+ (NSData *)qnBase64DataFromString:(NSString *)string;

@end


@interface NSData (QNCommonDigest)
- (NSData *)qnSHA256Hash;
@end

@interface NSData (QNCommonCryptor)

- (NSData *)qnAES256EncryptedDataUsingKey: (id) key error: (NSError **) error;
- (NSData *)qndecryptedAES256DataUsingKey: (id) key error: (NSError **) error;
@end

@interface NSData (QNLowLevelCommonCryptor)

- (NSData *)qndataEncryptedUsingAlgorithm: (CCAlgorithm) algorithm
                                     key: (id) key        // data or string
                                   error: (CCCryptorStatus *) error;
- (NSData *)qndataEncryptedUsingAlgorithm: (CCAlgorithm) algorithm
                                     key: (id) key        // data or string
                                 options: (CCOptions) options
                                   error: (CCCryptorStatus *) error;
- (NSData *)qndataEncryptedUsingAlgorithm: (CCAlgorithm) algorithm
                                     key: (id) key        // data or string
                    initializationVector: (id) iv        // data or string
                                 options: (CCOptions) options
                                   error: (CCCryptorStatus *) error;
- (NSData *)qndecryptedDataUsingAlgorithm: (CCAlgorithm) algorithm
                                     key: (id) key        // data or string
                                   error: (CCCryptorStatus *) error;
- (NSData *)qndecryptedDataUsingAlgorithm: (CCAlgorithm) algorithm
                                     key: (id) key        // data or string
                                 options: (CCOptions) options
                                   error: (CCCryptorStatus *) error;
- (NSData *)qndecryptedDataUsingAlgorithm: (CCAlgorithm) algorithm
                                     key: (id) key        // data or string
                    initializationVector: (id) iv        // data or string
                                 options: (CCOptions) options
                                   error: (CCCryptorStatus *) error;

@end

@interface NSError (QNCommonCryptoErrorDomain)

+ (NSError *) errorWithCCCryptorStatus: (CCCryptorStatus) status;

@end
