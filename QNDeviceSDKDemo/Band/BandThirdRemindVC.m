//
//  BandThirdRemindVC.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandThirdRemindVC.h"

@interface BandThirdRemindVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UISwitch *callRemindSwitch;
@property (weak, nonatomic) IBOutlet UITextField *callDelayTextField;
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

@end

@implementation BandThirdRemindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44 + 10;

}





@end
