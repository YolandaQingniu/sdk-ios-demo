//
//  CustomDeviceCell.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2020/10/22.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "CustomDeviceCell.h"
#import "Masonry.h"
#import "QNBleDevice+Addition.h"

@interface CustomDeviceCell ()

@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *modeIdLabel;
@property(nonatomic, strong) UILabel *rssiLabel;
@property(nonatomic, strong) UILabel *macLabel;
@property(nonatomic, strong) UIButton *disconnectedBtn;
@end

@implementation CustomDeviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.leading.mas_equalTo(10);
            make.height.mas_equalTo(40);
        }];
        
        self.modeIdLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.modeIdLabel];
        [self.modeIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.nameLabel.mas_trailing).offset(10);
            make.top.bottom.equalTo(self.nameLabel);
        }];
        
        self.rssiLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.rssiLabel];
        [self.rssiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.modeIdLabel);
            make.leading.equalTo(self.modeIdLabel.mas_trailing).offset(10);
        }];
        
        self.macLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.macLabel];
        [self.macLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.rssiLabel);
            make.leading.equalTo(self.rssiLabel.mas_trailing).offset(10);
        }];
        
        self.disconnectedBtn = [[UIButton alloc] init];
        self.disconnectedBtn.layer.cornerRadius = 3.0;
        self.disconnectedBtn.layer.borderColor = [UIColor redColor].CGColor;
        self.disconnectedBtn.layer.borderWidth = 1.0;
        self.disconnectedBtn.hidden = YES;
        [self.disconnectedBtn addTarget:self action:@selector(disconnectDevice) forControlEvents:UIControlEventTouchUpInside];
        [self.disconnectedBtn setTitle:@"断开" forState:UIControlStateNormal];
        [self.disconnectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.disconnectedBtn];
        [self.disconnectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-10);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(50);
            make.leading.equalTo(self.macLabel.mas_trailing).offset(10);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.contentView);
            make.top.equalTo(self.nameLabel.mas_bottom);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)disconnectDevice {
    if ([self.delegate respondsToSelector:@selector(disconnectDevice:)]) {
        [self.delegate disconnectDevice:self.device];
    }
}

- (void)setDevice:(QNBleDevice *)device {
    _device = device;
    self.disconnectedBtn.hidden = !(device.peripheral.state == CBPeripheralStateConnected || device.peripheral.state == CBPeripheralStateConnecting);
    self.nameLabel.text = device.name;
    self.modeIdLabel
    .text = device.modeId;
    self.rssiLabel.text = [NSString stringWithFormat:@"%@", device.RSSI];
    self.macLabel.text = device.mac;
}

@end
