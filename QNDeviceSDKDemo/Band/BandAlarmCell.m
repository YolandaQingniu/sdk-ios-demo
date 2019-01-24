//
//  BandAlarmCell.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2019/1/18.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandAlarmCell.h"

@interface BandAlarmCell ()
@property (weak, nonatomic) IBOutlet UILabel *alarmIdLabel;
@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;
@property (weak, nonatomic) IBOutlet UIButton *hourBtn;
@property (weak, nonatomic) IBOutlet UIButton *mintureBtn;
@property (weak, nonatomic) IBOutlet UIButton *sunBtn;
@property (weak, nonatomic) IBOutlet UIButton *monBtn;
@property (weak, nonatomic) IBOutlet UIButton *tuesBtn;
@property (weak, nonatomic) IBOutlet UIButton *webBtn;
@property (weak, nonatomic) IBOutlet UIButton *thurBtn;
@property (weak, nonatomic) IBOutlet UIButton *friBtn;
@property (weak, nonatomic) IBOutlet UIButton *satBtn;
@end

@implementation BandAlarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setAlarm:(QNAlarm *)alarm {
    _alarm = alarm;
    self.openSwitch.on = alarm.openFlag;
    self.alarmIdLabel.text = [NSString stringWithFormat:@"%2d",alarm.alarmId];
    [self.hourBtn setTitle:[NSString stringWithFormat:@"%d",alarm.hour] forState:UIControlStateNormal];
    [self.mintureBtn setTitle:[NSString stringWithFormat:@"%d",alarm.minture] forState:UIControlStateNormal];
    self.sunBtn.selected = alarm.week.sun;
    self.monBtn.selected = alarm.week.mon;
    self.tuesBtn.selected = alarm.week.tues;
    self.webBtn.selected = alarm.week.wed;
    self.thurBtn.selected = alarm.week.thur;
    self.friBtn.selected = alarm.week.fri;
    self.satBtn.selected = alarm.week.sat;
}

- (IBAction)selectedAlarmSwitch:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(updateAlarm:)]) {
        [self.delegate updateAlarm:[self currentAlarm]];
    }
}

- (IBAction)selectedAlarmHour:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(selectedAlarmHourNum:)]) {
        [self.delegate selectedAlarmHourNum:[self currentAlarm]];
    }
}

- (IBAction)selectedAlarmMinture:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(selectedAlarmMintureNum:)]) {
        [self.delegate selectedAlarmMintureNum:[self currentAlarm]];
    }
}

- (IBAction)selectedweek:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(updateAlarm:)]) {
        [self.delegate updateAlarm:[self currentAlarm]];
    }
}
- (IBAction)deleteAlarm:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteAlarm:)]) {
        [self.delegate deleteAlarm:[self currentAlarm]];
    }
}

- (QNAlarm *)currentAlarm {
    QNAlarm *alarm = [[QNAlarm alloc] init];
    alarm.alarmId = self.alarm.alarmId;
    alarm.hour = [self.hourBtn.titleLabel.text intValue];
    alarm.minture = [self.mintureBtn.titleLabel.text intValue];
    alarm.openFlag = self.openSwitch.on;
    QNWeek *week = [[QNWeek alloc] init];
    week.sun = self.sunBtn.selected;
    week.mon = self.monBtn.selected;
    week.tues = self.tuesBtn.selected;
    week.wed = self.webBtn.selected;
    week.thur = self.thurBtn.selected;
    week.fri = self.friBtn.selected;
    week.sat = self.satBtn.selected;
    alarm.week = week;
    return alarm;
}
@end
