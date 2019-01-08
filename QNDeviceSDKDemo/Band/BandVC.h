//
//  BandVC.h
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BandComeStyle) {
    BandComeConfig = 0,
    BandComeScan,
};

@interface BandVC : BandBaseVC

@property (nonatomic, assign) BandComeStyle comeStyle;

@end

NS_ASSUME_NONNULL_END
