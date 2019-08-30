//
//  QNPScaleConfig.h
//  QNPScaleModule
//
//  Created by donyau on 2019/1/7.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNPScaleEnum.h"
#import "QNPProduct.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNPScaleConfig : NSObject
/** 秤的单位(默认KG) */
@property (nonatomic, assign) QNPScaleUnitMode unitMode;
/** 是否读取存储数据(默认读取) */
@property (nonatomic, assign) BOOL readStorageDataFlag;

@property(nonatomic, strong) QNPProduct *product;
/** 是否一直写入，直到修改型号成功 */
@property(nonatomic, assign) BOOL fixModelUntilSuccess;

@end

NS_ASSUME_NONNULL_END
