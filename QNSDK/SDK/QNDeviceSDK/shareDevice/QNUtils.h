//
//  QNUtils.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2019/1/27.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNUser.h"
#import "QNScaleData.h"

NS_ASSUME_NONNULL_BEGIN


@interface QNShareData : NSObject

@property (nullable, nonatomic, strong, readonly) NSString *sn;

@property (nullable, nonatomic, strong, readonly) QNScaleData *scaleData;

@end


@interface QNUtils : NSObject

+ (nullable QNShareData *)decodeShareDataWithCode:(NSString *)qnCode user:(QNUser *)user callblock:(QNResultCallback)callblock;

+ (nullable QNShareData *)decodeShareDataWithCode:(NSString *)qnCode user:(QNUser *)user validTime:(long)validTime callblock:(QNResultCallback)callblock;


@end

NS_ASSUME_NONNULL_END
