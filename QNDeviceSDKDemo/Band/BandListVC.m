//
//  BandListVC.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandListVC.h"
#import "BandThirdRemindVC.h"
#import "BandUserVC.h"
#import "BandThirdRemindVC.h"
#import "BandMetricsVC.h"
#import "BandAlarmVC.h"
#import "BandSitRemindVC.h"

@interface BandListVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation BandListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44 + 10;
}

- (IBAction)turnToAlarmVc:(UIButton *)sender {
    BandAlarmVC *alarmVc = [[BandAlarmVC alloc] init];
    [self.navigationController pushViewController:alarmVc animated:YES];
}

- (IBAction)turnThirdRemindVc:(UIButton *)sender {
    BandThirdRemindVC *thirdRemindVc = [[BandThirdRemindVC alloc] init];
    [self.navigationController pushViewController:thirdRemindVc animated:YES];
}

- (IBAction)turnToSitRemindVc:(UIButton *)sender {
    BandSitRemindVC *sitRemindVc = [[BandSitRemindVC alloc] init];
    [self.navigationController pushViewController:sitRemindVc animated:YES];
}

- (IBAction)turnToUseAndGoalVc:(UIButton *)sender {
    BandUserVC *userVc = [[BandUserVC alloc] init];
    [self.navigationController pushViewController:userVc animated:YES];
}

- (IBAction)turnToMetricsVc:(UIButton *)sender {
    BandMetricsVC *metricsVc = [[BandMetricsVC alloc] init];
    [self.navigationController pushViewController:metricsVc animated:YES];
}

- (IBAction)reboot:(UIButton *)sender {
    [[[QNBleApi sharedBleApi] getBandManager] rebootCallback:^(NSError *error) {
        
    }];
}

- (IBAction)lossRemindSwitch:(UISwitch *)sender {
    
}

- (IBAction)handRecognizeSwitch:(UISwitch *)sender {
    [[[QNBleApi sharedBleApi] getBandManager] syncHandRecognizeModeWithOpenFlag:sender.isOn callback:^(NSError *error) {
        if (error == nil) {
            [BandMessage sharedBandMessage].handRecognize = sender.isOn;
        }
    }];
}

- (IBAction)heartRateObserverSwitch:(UISwitch *)sender {
    
    [[[QNBleApi sharedBleApi] getBandManager] syncHeartRateObserverModeWithAutoFlag:sender.isOn callback:^(NSError *error) {
        if (error == nil) {
            [BandMessage sharedBandMessage].heartRateObserver = sender.isOn;
        }
    }];
    
}

- (IBAction)findPhoneSwitch:(UISwitch *)sender {
    [[[QNBleApi sharedBleApi] getBandManager] syncFindPhoneWithOpenFlag:sender.isOn callback:^(NSError *error) {
        if (error == nil) {
            [BandMessage sharedBandMessage].findPhone = sender.isOn;
        }
    }];
}

- (IBAction)cameraSwitch:(UISwitch *)sender {
    [[[QNBleApi sharedBleApi] getBandManager] syncCameraModeWithEnterFlag:sender.isOn callback:^(NSError *error) {
        
    }];
}

@end
