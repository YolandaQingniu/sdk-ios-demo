//
//  ScaleDataCell.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/19.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "ScaleDataCell.h"
#import "ScaleDataTargetTool.h"

@interface ScaleDataCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (weak, nonatomic) IBOutlet UILabel *levelNamesLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLevelLabel;

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
    
    BOOL unitFlag = self.itemData.type == QNScaleTypeWeight || self.itemData.type == QNScaleTypeBoneMass || self.itemData.type == QNScaleTypeLeanBodyWeight || self.itemData.type == QNScaleTypeMuscleMass;
    
    if (self.unit != QNUnitKG && unitFlag) {
        value = [[QNBleApi sharedBleApi] convertWeightWithTargetUnit:value unit:self.unit];
        if (self.unit == QNUnitST) {
            value = value / 14.0;
        }
    }
    if (self.itemData.valueType == QNValueTypeInt) {
        self.value.text = [NSString stringWithFormat:@"%.0f",value];
    }else{
        self.value.text = [NSString stringWithFormat:@"%.2f",value];
    }
    
    if (unitFlag) {
        NSString *unitStr = self.value.text;
        switch (self.unit) {
            case QNUnitLB: unitStr = [unitStr stringByAppendingString:@" lb"]; break;
            case QNUnitJIN: unitStr = [unitStr stringByAppendingString:@" 斤"]; break;
            case QNUnitST: unitStr = [unitStr stringByAppendingString:@" st"]; break;
            default:
                break;
        }
        self.value.text = unitStr;
    }
    
    ScaleDataTargetModel *model = [ScaleDataTargetTool getScaleDataTargetModelWithScaleData:self.itemData user:self.user currentWeight:self.currentWeight];

    if (self.itemData.value <= 0) {
        
        self.levelNamesLabel.text = @"无";
        self.currentLevelLabel.text = @"无";
        return;
    }
    
    if (model.levelNames.count > 0) {
        NSString *levelNames = [model.levelNames componentsJoinedByString:@","];
        self.levelNamesLabel.text = [NSString stringWithFormat:@"[%@]",levelNames];
    }else {
        self.levelNamesLabel.text = @"无";
    }
    
    if (model.currentLevel.length > 0) {
        self.currentLevelLabel.text = [NSString stringWithFormat:@"当前等级:%@",model.currentLevel];
    }else {
        self.currentLevelLabel.text = @"无";
    }
}

@end
