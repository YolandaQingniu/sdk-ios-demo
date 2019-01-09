//
//  BandSitRemindVC.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandSitRemindVC.h"
#import "PickerView.h"

typedef NS_ENUM(NSUInteger, BandSitPickerType) {
    BandSitPickerInterval = 0,
    BandSitPickerStartHour,
    BandSitPickerStartMinture,
    BandSitPickerEndHour,
    BandSitPickerEndMinture,
};

@interface BandSitRemindVC ()<PickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;
@property (weak, nonatomic) IBOutlet UIButton *intervalBtn;
@property (weak, nonatomic) IBOutlet UIButton *startHourBtn;
@property (weak, nonatomic) IBOutlet UIButton *startMintureBtn;
@property (weak, nonatomic) IBOutlet UIButton *endHourBtn;
@property (weak, nonatomic) IBOutlet UIButton *endMintureBtn;
@property (weak, nonatomic) IBOutlet UIButton *sunBtn;
@property (weak, nonatomic) IBOutlet UIButton *monBtn;
@property (weak, nonatomic) IBOutlet UIButton *tuesBtn;
@property (weak, nonatomic) IBOutlet UIButton *webBtn;
@property (weak, nonatomic) IBOutlet UIButton *thurBtn;
@property (weak, nonatomic) IBOutlet UIButton *firBtn;
@property (weak, nonatomic) IBOutlet UIButton *satBtn;
@property (nonatomic, weak) PickerView *pickerView;
@property (nonatomic, assign) BandSitPickerType pickType;
@end

@implementation BandSitRemindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44 + 10;
    [self update];
}

- (void)update {
    QNSitRemind *sitRemind = [BandMessage sharedBandMessage].sitRemind;
    self.openSwitch.on = sitRemind.openFlag;
    [self.intervalBtn setTitle:[NSString stringWithFormat:@"%d",sitRemind.timeInterval] forState:UIControlStateNormal];
    [self.startHourBtn setTitle:[NSString stringWithFormat:@"%d",sitRemind.startHour] forState:UIControlStateNormal];
    [self.startMintureBtn setTitle:[NSString stringWithFormat:@"%d",sitRemind.startMinture] forState:UIControlStateNormal];
    [self.endHourBtn setTitle:[NSString stringWithFormat:@"%d",sitRemind.endHour] forState:UIControlStateNormal];
    [self.endMintureBtn setTitle:[NSString stringWithFormat:@"%d",sitRemind.endMinture] forState:UIControlStateNormal];
    self.sunBtn.selected = sitRemind.week.sun;
    self.monBtn.selected = sitRemind.week.mon;
    self.tuesBtn.selected = sitRemind.week.tues;
    self.webBtn.selected = sitRemind.week.wed;
    self.thurBtn.selected = sitRemind.week.thur;
    self.firBtn.selected = sitRemind.week.fri;
    self.satBtn.selected = sitRemind.week.sat;
}

- (IBAction)openSelected:(UISwitch *)sender {
    [self syncSitRemind];
}

- (IBAction)intervalSelected:(UIButton *)sender {
    self.pickType = BandSitPickerInterval;
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeNumber;
    [pickerView defaultNum:[self.intervalBtn.titleLabel.text intValue] maxNum:180 minNum:15 intervalNum:1];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (IBAction)startHourSelected:(UIButton *)sender {
    self.pickType = BandSitPickerStartHour;
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeNumber;
    [pickerView defaultNum:[self.startHourBtn.titleLabel.text intValue] maxNum:23 minNum:0 intervalNum:1];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (IBAction)startMintureSelected:(UIButton *)sender {
    self.pickType = BandSitPickerStartMinture;
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeNumber;
    [pickerView defaultNum:[self.startMintureBtn.titleLabel.text intValue] maxNum:59 minNum:0 intervalNum:1];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (IBAction)endHourSelected:(UIButton *)sender {
    self.pickType = BandSitPickerEndHour;
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeNumber;
    [pickerView defaultNum:[self.endHourBtn.titleLabel.text intValue] maxNum:23 minNum:0 intervalNum:1];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (IBAction)endMintureSelected:(UIButton *)sender {
    self.pickType = BandSitPickerEndMinture;
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeNumber;
    [pickerView defaultNum:[self.endMintureBtn.titleLabel.text intValue] maxNum:59 minNum:0 intervalNum:1];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (void)confirmNumber:(NSInteger)num {
    if (self.pickType == BandSitPickerInterval) {
        [self.intervalBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
    }else if (self.pickType == BandSitPickerStartHour) {
        [self.startHourBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
    }else if (self.pickType == BandSitPickerStartMinture) {
        [self.startMintureBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
    }else if (self.pickType == BandSitPickerEndHour) {
        [self.endHourBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
    }else if (self.pickType == BandSitPickerEndMinture) {
        [self.endMintureBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
    }
    [self syncSitRemind];
}

- (void)dismissPickView {
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

- (IBAction)weekSelected:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self syncSitRemind];
}


- (void)syncSitRemind {
    QNSitRemind *sitRemind = [[QNSitRemind alloc] init];
    sitRemind.openFlag = self.openSwitch.on;
    sitRemind.timeInterval = [self.intervalBtn.titleLabel.text intValue];
    sitRemind.startHour = [self.startHourBtn.titleLabel.text intValue];
    sitRemind.startMinture = [self.startMintureBtn.titleLabel.text intValue];
    sitRemind.endHour = [self.endHourBtn.titleLabel.text intValue];
    sitRemind.endMinture = [self.endMintureBtn.titleLabel.text intValue];
    QNWeek *week = [[QNWeek alloc] init];
    week.sun = self.sunBtn.selected;
    week.mon = self.monBtn.selected;
    week.tues = self.tuesBtn.selected;
    week.wed = self.webBtn.selected;
    week.thur = self.thurBtn.selected;
    week.fri = self.firBtn.selected;
    week.sat = self.satBtn.selected;

    sitRemind.week = week;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步...";
    [[[QNBleApi sharedBleApi] getBandManager] syncSitRemind:sitRemind callback:^(NSError *error) {
        if (error) {
            hud.label.text = @"同步失败...";
            [self update];
        }else {
            hud.label.text = @"同步成功";
            [BandMessage sharedBandMessage].sitRemind = sitRemind;
        }
        [hud hideAnimated:YES afterDelay:1];
    }];
}



@end
