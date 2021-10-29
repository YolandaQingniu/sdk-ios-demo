//
//  QNBleKitchenConfig.h
//  QNDeviceSDK
//
//  Created by sumeng on 2021/9/8.
//  Copyright © 2021 Yolanda. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import "QNConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBleKitchenConfig : NSObject

/** 端显示的单位*/
@property (nonatomic, assign) QNUnit unit;

/** 设置称端去皮是否去皮*/
@property (nonatomic, assign) BOOL isPeel;
@end

NS_ASSUME_NONNULL_END
