//
//  QNBleKitchenDevice.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/10/22.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBleKitchenDevice : NSObject
/** mac地址 */
@property (nonatomic, readonly, strong) NSString *mac;
/** name */
@property (nonatomic, readonly, strong) NSString *name;
/** name */
@property (nonatomic, readonly, strong) NSString *modeId;
/** 信号强度 */
@property (nonatomic, readonly, strong) NSNumber *RSSI;
/** 秤体当前显示的单位（G、ml、oz、lb:oz） */
@property(nonatomic, readonly, assign) QNUnit unit;
/** 当前重量，单位g */
@property(nonatomic, readonly, assign) double weight;
/** 是否已经去皮 */
@property(nonatomic, readonly, assign) BOOL isPeel;
/** 是否负重量 */
@property(nonatomic, readonly, assign) BOOL isNegative;
/** 是否超载 */
@property(nonatomic, readonly, assign) BOOL isOverload;
@end

NS_ASSUME_NONNULL_END
