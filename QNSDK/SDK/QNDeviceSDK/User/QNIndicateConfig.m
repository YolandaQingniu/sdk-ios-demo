//
//  QNIndicateConfig.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2020/7/1.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "QNIndicateConfig.h"

@implementation QNIndicateConfig

- (instancetype)init {
    if (self = [super init]) {
        self.showUserName = YES;
        self.showBmi = YES;
        self.showBone = YES;
        self.showFat = YES;
        self.showMuscle = YES;
        self.showWater = YES;
        self.showHeartRate = YES;
        self.showWeather = YES;
    }
    return self;
}

@end
