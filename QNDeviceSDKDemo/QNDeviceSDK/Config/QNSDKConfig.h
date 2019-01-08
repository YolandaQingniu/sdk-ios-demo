//
//  QNSDKConfig.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/4/26.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QNScaleItemData.h"

@interface QNDeviceMessage : NSObject

@property (nonatomic, strong) NSString *model;

@property (nonatomic, assign) NSInteger method;

@property (nonatomic, strong) NSString *internalModel;

@property (nonatomic, assign) NSInteger bodyIndexFlag;

@end


@interface QNSDKConfig : NSObject

@property (nonatomic, strong) NSString *appid;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) NSInteger serverType;

@property (nonatomic, strong) NSMutableArray *packages;

@property (nonatomic, assign) BOOL connectOtherFlag;

@property (nonatomic, strong) NSString *defaultModel;

@property (nonatomic, assign) NSInteger defaultMethod;

@property (nonatomic, assign) NSInteger defaultIndexFlag;

@property (nonatomic, assign) NSInteger updateTimeStamp;


@property (nonatomic, strong) NSMutableArray<QNDeviceMessage *> *models;


+ (QNSDKConfig *)sdkConfigDic:(NSDictionary *)dic;

@end


