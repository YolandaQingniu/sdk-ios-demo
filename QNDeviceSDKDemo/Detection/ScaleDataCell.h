//
//  ScaleDataCell.h
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/19.
//  Copyright © 2018年 Yolanda. All rights reserved.
//  测量数据cell

#import <UIKit/UIKit.h>
#import "QNDeviceSDK.h"

@interface ScaleDataCell : UITableViewCell

@property (nonatomic, assign) QNUnit unit;

@property (nonatomic, strong) QNScaleItemData *itemData;

@property (nonatomic, strong) QNUser *user;

@property (nonatomic, assign) CGFloat currentWeight;

@property (nonatomic, assign) BOOL isEightElectrodesData;
@end
