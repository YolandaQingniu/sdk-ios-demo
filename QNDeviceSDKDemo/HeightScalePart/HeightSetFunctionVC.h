//
//  HeightSetFunctionVC.h
//  QNDeviceSDKDemo
//
//  Created by yolanda on 2025/9/8.
//  Copyright © 2025 Yolanda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SubmitCallback)(NSInteger set1,NSInteger set2,NSInteger set3,NSInteger set4);

@interface HeightSetFunctionVC : UIViewController
@property (nonatomic, copy) SubmitCallback submitCallback;
@end

NS_ASSUME_NONNULL_END
