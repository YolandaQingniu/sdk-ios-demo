//
//  BandHealthDataView.h
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/19.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BandHealthDataView : UIViewController

@property (nonatomic, strong) NSArray<QNHealthData *> *healthDatas;

@end

NS_ASSUME_NONNULL_END
