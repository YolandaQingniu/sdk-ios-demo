//
//  HeightSetFunctionVC.m
//  QNDeviceSDKDemo
//
//  Created by yolanda on 2025/9/8.
//  Copyright © 2025 Yolanda. All rights reserved.
//

#import "HeightSetFunctionVC.h"
#import "Masonry.h"

@interface HeightSetFunctionVC ()
@property (nonatomic, strong) UISegmentedControl *weightUnitSegment;
@property (nonatomic, strong) UISegmentedControl *heightUnitSegment;
@property (nonatomic, strong) UISegmentedControl *languageSegment;
@property (nonatomic, strong) UISegmentedControl *mapSegment;
@end

@implementation HeightSetFunctionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *buttonItem1 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(makeSureHandle:)];
    self.navigationItem.rightBarButtonItems = @[buttonItem1];
    
    
    // 设置体重单位：01：kg；02：lb；04：斤；08：St:lb (0xFF时该项不生效)
    self.weightUnitSegment = [[UISegmentedControl alloc] initWithItems:@[@"kg", @"LB", @"斤", @"STLB", @"不设置"]];
    
    // 设置身高单位：01-cm;02-ft:in;04-in；08-ft(0xFF时该项不生效)
    self.heightUnitSegment = [[UISegmentedControl alloc] initWithItems:@[@"cm", @"ft:in", @"in", @"ft", @"不设置"]];
    
    // 设置语音播报：1-中文语音播报；2-英文语音播报；3-阿拉伯语播报(0xFF时该项不生效)
    self.languageSegment = [[UISegmentedControl alloc] initWithItems:@[@"中文播报", @"英文播报", @"阿拉伯语播报", @"不设置"]];
    
    // 使用场景切换：1-家庭模式；2-商用共享模式(0xFF时该项不生效)
    self.mapSegment = [[UISegmentedControl alloc] initWithItems:@[@"家庭模式", @"商用共享模式", @"扫码枪模式",@"不设置"]];
    
    // 设置体重单位
    UILabel *unitLabel = [[UILabel alloc] init];
    unitLabel.text = @"设置体重单位：";
    unitLabel.font = [UIFont systemFontOfSize:14];
    self.weightUnitSegment.selectedSegmentIndex = 0;
    
    // 设置身高单位
    UILabel *heightUnitLabel = [[UILabel alloc] init];
    heightUnitLabel.text = @"设置身高单位：";
    heightUnitLabel.font = [UIFont systemFontOfSize:14];
    self.heightUnitSegment.selectedSegmentIndex = 0;
    
    // 设置语音语种
    UILabel *languageLabel = [[UILabel alloc] init];
    languageLabel.text = @"设置语音语种：";
    languageLabel.font = [UIFont systemFontOfSize:14];
    self.languageSegment.selectedSegmentIndex = 0;
    
    // 设置用户模式
    UILabel *mapLabel = [[UILabel alloc] init];
    mapLabel.text = @"设置用户模式：";
    mapLabel.font = [UIFont systemFontOfSize:14];
    self.mapSegment.selectedSegmentIndex = 0;
    
    [self.view addSubview:unitLabel];
    [self.view addSubview:self.weightUnitSegment];
    
    [self.view addSubview:heightUnitLabel];
    [self.view addSubview:self.heightUnitSegment];
    
    [self.view addSubview:languageLabel];
    [self.view addSubview:self.languageSegment];
    
    [self.view addSubview:mapLabel];
    [self.view addSubview:self.mapSegment];
    
    CGFloat segmentWidth = 250;
    
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.equalTo(@20);
    }];
    
    [self.weightUnitSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(unitLabel);
        make.left.equalTo(unitLabel.mas_right).offset(0);
        make.width.equalTo(@(segmentWidth));
    }];
    
    [heightUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(unitLabel.mas_bottom).offset(20);
        make.left.equalTo(unitLabel);
    }];
    
    [self.heightUnitSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(heightUnitLabel);
        make.left.equalTo(self.weightUnitSegment);
        make.width.equalTo(@(segmentWidth));
        make.height.equalTo(@30);
    }];
    
    [languageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(heightUnitLabel.mas_bottom).offset(20);
        make.left.equalTo(heightUnitLabel);
    }];
    
    [self.languageSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(languageLabel);
        make.left.equalTo(self.weightUnitSegment);
        make.width.equalTo(@(segmentWidth));
    }];
    
    [mapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(languageLabel.mas_bottom).offset(20);
        make.left.equalTo(languageLabel);
    }];
    
    [self.mapSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mapLabel);
        make.left.equalTo(self.weightUnitSegment);
        make.width.equalTo(@(segmentWidth));
    }];
}

- (void)makeSureHandle:(UIBarButtonItem *)buttonItem {
    if (self.submitCallback) {
        self.submitCallback(self.weightUnitSegment.selectedSegmentIndex, self.heightUnitSegment.selectedSegmentIndex, self.languageSegment.selectedSegmentIndex, self.mapSegment.selectedSegmentIndex);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
