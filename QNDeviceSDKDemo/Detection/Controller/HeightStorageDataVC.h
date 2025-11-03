//
//  HeightStorageDataVC.h
//  QNDeviceSDKDemo
//
//  Created by yolanda on 2025/9/8.
//  Copyright © 2025 Yolanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNScaleStoreData.h"
#import "QNBleApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface HeightStorageDataVC : UIViewController

@property (nonatomic, copy) NSArray <QNScaleStoreData*>*storageList;

@property (nonatomic, assign) QNDeviceType  deviceType;

@end

NS_ASSUME_NONNULL_END
