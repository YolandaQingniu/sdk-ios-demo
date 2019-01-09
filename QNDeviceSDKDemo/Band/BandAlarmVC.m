//
//  BandAlarmVC.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandAlarmVC.h"
#import "PickerView.h"

typedef NS_ENUM(NSUInteger, BandAlarmPickerType) {
    BandAlarmPickerHour,
    BandAlarmPickerMinture,
};

@interface BandAlarmVC ()<PickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContstraint;
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
@property (nonatomic, weak) PickerView *pickerView;
@property (nonatomic, assign) BandAlarmPickerType pickType;
@end

@implementation BandAlarmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topContstraint.constant = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44 + 10;
    [self update];
}

- (void)update {
    NSArray<QNAlarm *> *alarms = [BandMessage sharedBandMessage].alarms;
    QNAlarm *alarm = alarms.firstObject;
    self.openSwitch.on = alarm.openFlag;
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

- (IBAction)openSelected:(UISwitch *)sender {
    [self syncAlarm];
}

- (IBAction)hourSelected:(UIButton *)sender {
    QNAlarm *alarm = [BandMessage sharedBandMessage].alarms.firstObject;

    self.pickType = BandAlarmPickerHour;
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeNumber;
    [pickerView defaultNum:alarm.hour maxNum:23 minNum:0 intervalNum:1];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (IBAction)mintureSelected:(UIButton *)sender {
    QNAlarm *alarm = [BandMessage sharedBandMessage].alarms.firstObject;

    self.pickType = BandAlarmPickerMinture;
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeNumber;
    [pickerView defaultNum:alarm.minture maxNum:59 minNum:0 intervalNum:1];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (void)confirmNumber:(NSInteger)num {
    if (self.pickType == BandAlarmPickerHour) {
        [self.hourBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
    }else {
        [self.mintureBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
    }
    [self syncAlarm];
}

- (void)dismissPickView {
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

- (IBAction)weekSelected:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self syncAlarm];
}


- (void)syncAlarm {
    QNAlarm *alarm = [BandMessage sharedBandMessage].alarms.firstObject;
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步...";
    [[[QNBleApi sharedBleApi] getBandManager] syncAlarm:alarm callback:^(NSError *error) {
        if (error) {
            hud.label.text = @"同步失败...";
            [self update];
        }else {
            hud.label.text = @"同步成功";
            NSMutableArray<QNAlarm *> *alarms = [BandMessage sharedBandMessage].alarms;
            for (QNAlarm *item in alarms) {
                if (item.alarmId == alarm.alarmId) {
                    [alarms removeObject:item];
                    break;
                }
            }
            [alarms addObject:alarm];
            [BandMessage sharedBandMessage].alarms = alarms;
        }
        [hud hideAnimated:YES afterDelay:1];
    }];
}



@end
