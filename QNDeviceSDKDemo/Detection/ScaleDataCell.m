//
//  ScaleDataCell.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/19.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "ScaleDataCell.h"
@interface ScaleDataCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *value;

@end
@implementation ScaleDataCell

- (void)setItemData:(QNScaleItemData *)itemData {
    _itemData = itemData;
    [self updateCell];
}

- (void)setUnit:(QNUnit)unit {
    _unit = unit;
    [self updateCell];
}

- (void)updateCell {
    self.name.text = _itemData.name;
    double value = _itemData.value;
    if (self.unit != QNUnitKG && (self.itemData.type == QNScaleTypeWeight || self.itemData.type == QNScaleTypeBoneMass || self.itemData.type == QNScaleTypeLeanBodyWeight || self.itemData.type == QNScaleTypeMuscleMass)) {
        value = [[QNBleApi sharedBleApi] convertWeightWithTargetUnit:value unit:self.unit];
    }
    if (self.itemData.valueType == QNValueTypeInt) {
        self.value.text = [NSString stringWithFormat:@"%.0f",value];
    }else{
        if (self.itemData.type == QNScaleTypeWeight) {
            self.value.text = [NSString stringWithFormat:@"%.2f",value];
        }else{
            self.value.text = [NSString stringWithFormat:@"%.1f",value];
        }
    }
}

@end
