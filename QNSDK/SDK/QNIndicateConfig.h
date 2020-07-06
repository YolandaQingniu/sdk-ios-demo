//
//  QNIndicateConfig.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/7/1.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNIndicateConfig : NSObject
/// 控制秤端骨量的显示
@property(nonatomic, assign) BOOL showBone;
/// 控制秤端肌肉量的显示
@property(nonatomic, assign) BOOL showMuscle;
/// 控制秤端体水分的显示
@property(nonatomic, assign) BOOL showWater;
@end

NS_ASSUME_NONNULL_END
