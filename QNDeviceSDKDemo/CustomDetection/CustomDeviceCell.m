//
//  CustomDeviceCell.m
//  QNDeviceSDKDemo
//
//  Created by qiudongquan on 2020/10/22.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "CustomDeviceCell.h"
#import "Masonry.h"

@interface CustomDeviceCell ()

@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *modeId;
@property(nonatomic, strong) UILabel *rssiLabel;
@property(nonatomic, strong) UILabel *macLabel;
@end

@implementation CustomDeviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.leading.mas_equalTo(10);
            make.height.mas_equalTo(40);
        }];
        
        self.modeId = [[UILabel alloc] init];
        [self.contentView addSubview:self.modeId];
        [self.modeId mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.nameLabel.mas_trailing).offset(10);
            make.top.bottom.equalTo(self.nameLabel);
        }];
        
        self.rssiLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.rssiLabel];
        [self.rssiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.modeId);
            make.leading.equalTo(self.modeId.mas_trailing).offset(10);
        }];
        
        self.macLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.macLabel];
        [self.macLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.rssiLabel);
            make.trailing.equalTo(self.contentView).offset(-10);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.contentView);
            make.top.equalTo(self.macLabel.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lineView.mas_bottom);
            make.width.equalTo(self);
        }];
        
    }
    return self;
}

- (void)setDevice:(QNBleDevice *)device {
    _device = device;
    self.nameLabel.text = device.name;
    self.modeId.text = device.modeId;
    self.rssiLabel.text = [NSString stringWithFormat:@"%@", device.RSSI];
    self.macLabel.text = device.mac;
}

@end
