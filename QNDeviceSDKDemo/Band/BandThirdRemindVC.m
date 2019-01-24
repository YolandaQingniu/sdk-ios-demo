//
//  BandThirdRemindVC.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandThirdRemindVC.h"
#import "PickerView.h"

@interface BandThirdRemindVC ()<PickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UISwitch *callRemindSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *smsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *fackbookSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *wechatSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *qqSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *whatsAppSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *linkedInSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *instagramSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *calendarSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *emailSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *skypeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pokemanSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *facebookMessageSwitch;
@property (weak, nonatomic) IBOutlet UIButton *callDelayBtn;

@property (nonatomic, weak) PickerView  *pickerView;

@end

@implementation BandThirdRemindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44 + 10;
    [self updateThirdRemindState];
}


- (IBAction)setCallDelay:(UIButton *)sender {
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeNumber;
    [pickerView defaultNum:[self.callDelayBtn.titleLabel.text intValue] maxNum:30 minNum:3 intervalNum:1];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (IBAction)switchStateChange:(UISwitch *)sender {
    [self syncThirdRemind];
}

- (void)confirmNumber:(NSInteger)num {
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
    [self.callDelayBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
    [self syncThirdRemind];
}

- (void)syncThirdRemind {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步...";
    QNThirdRemind *thirdRemind = [self buildThirdRemind];
    [[BLETool sharedBLETool].bandManager setThirdRemind:thirdRemind callback:^(NSError *error) {
        if (error) {
            hud.label.text = @"同步失败...";
            [self updateThirdRemindState];
        }else {
            hud.label.text = @"同步成功";
            [BandMessage sharedBandMessage].thirdRemind = thirdRemind;
        }
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (QNThirdRemind *)buildThirdRemind {
    QNThirdRemind *thirdRemind = [[QNThirdRemind alloc] init];
    thirdRemind.call = self.callRemindSwitch.isOn;
    thirdRemind.sms = self.smsSwitch.isOn;
    thirdRemind.faceBook = self.fackbookSwitch.isOn;
    thirdRemind.WeChat = self.wechatSwitch.isOn;
    thirdRemind.QQ = self.qqSwitch.isOn;
    thirdRemind.twitter = self.twitterSwitch.isOn;
    thirdRemind.whatesapp = self.whatsAppSwitch.isOn;
    thirdRemind.linkedIn = self.linkedInSwitch.isOn;
    thirdRemind.instagram = self.instagramSwitch.isOn;
    thirdRemind.faceBookMessenger = self.facebookMessageSwitch.isOn;
    thirdRemind.calendar = self.calendarSwitch.isOn;
    thirdRemind.email = self.emailSwitch.isOn;
    thirdRemind.skype = self.skypeSwitch.isOn;
    thirdRemind.pokeman = self.pokemanSwitch.isOn;
    thirdRemind.callDelay = [self.callDelayBtn.titleLabel.text intValue];
    return thirdRemind;
}

- (void)updateThirdRemindState {
    QNThirdRemind *thirdRemind = [BandMessage sharedBandMessage].thirdRemind;
    self.callRemindSwitch.on = thirdRemind.call;
    self.smsSwitch.on = thirdRemind.sms;
    self.fackbookSwitch.on = thirdRemind.faceBook;
    self.wechatSwitch.on = thirdRemind.WeChat;
    self.qqSwitch.on = thirdRemind.QQ;
    self.twitterSwitch.on = thirdRemind.twitter;
    self.whatsAppSwitch.on = thirdRemind.whatesapp;
    self.linkedInSwitch.on = thirdRemind.linkedIn;
    self.instagramSwitch.on = thirdRemind.instagram;
    self.facebookMessageSwitch.on = thirdRemind.faceBookMessenger;
    self.calendarSwitch.on = thirdRemind.calendar;
    self.emailSwitch.on = thirdRemind.email;
    self.skypeSwitch.on = thirdRemind.skype;
    self.pokemanSwitch.on = thirdRemind.pokeman;
    [self.callDelayBtn setTitle:[NSString stringWithFormat:@"%ld",(long)thirdRemind.callDelay] forState:UIControlStateNormal];
}

@end
