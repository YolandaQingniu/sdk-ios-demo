//
//  QNAuthDevice.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/2/24.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNAuthDevice : NSObject

@property (nonatomic, strong) NSString *model;

@property (nonatomic, assign) NSInteger method;

@property (nonatomic, strong) NSString *internalModel;

@property (nonatomic, assign) NSInteger bodyIndexFlag;

@property (nonatomic, assign) NSInteger otherTargetFlag;

@end

NS_ASSUME_NONNULL_END
