//
//  QNBandManager+QNAddition.h
//  QNDeviceSDK
//
//  Created by donyau on 2019/1/3.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "QNBandManager.h"
#import "QNBandModule.h"
#import "QNCentralModule.h"
#import "QNDebug.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBandManager (QNAddition)

/** 设备管理 */
@property (nonatomic, strong) QNWristManager *wristManager;

- (instancetype)initWithCentralManager:(QNCentralManager *)centralManager delegate:(id<QNBandDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
