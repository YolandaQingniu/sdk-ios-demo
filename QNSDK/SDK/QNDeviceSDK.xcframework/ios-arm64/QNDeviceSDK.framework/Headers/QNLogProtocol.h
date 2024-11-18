//
//  QNLogProtocol.h
//  QNDeviceSDK
//
//  Created by com.qn.device on 2019/7/1.
//  Copyright © 2019 com.qn.device. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QNLogProtocol <NSObject>

- (void)onLog:(NSString *)log;

@end

NS_ASSUME_NONNULL_END
