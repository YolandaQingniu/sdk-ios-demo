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
@property (weak, nonatomic) IBOutlet UISwitch *handRecogizerSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *heartRateModeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *findPhoneSwitch;

@end

@implementation BandListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44 + 10;
    self.handRecogizerSwitch.on = [BandMessage sharedBandMessage].handRecognize;
    self.heartRateModeSwitch.on = [BandMessage sharedBandMessage].heartRateObserver;
    self.findPhoneSwitch.on = [BandMessage sharedBandMessage].findPhone;
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在恢复出厂设置...";
    [[BLETool sharedBLETool].bandManager rebootCallback:^(NSError *error) {
        if (error) {
            hud.label.text = @"恢复出厂设置失败";
        }else {
            BandMessage *message = [BandMessage sharedBandMessage];
            NSString *bleName = message.blueToothName;
            NSString *modeId = message.modeId;
            NSString *uuid = message.uuidString;
            NSString *mac = message.mac;
            [message cleanBandMessage];
            message.blueToothName = bleName;
            message.modeId = modeId;
            message.uuidString = uuid;
            message.mac = mac;
            hud.label.text = @"恢复出厂设置成功";
        }
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (IBAction)handRecognizeSwitch:(UISwitch *)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步...";
    [[BLETool sharedBLETool].bandManager  syncHandRecognizeModeWithOpenFlag:sender.on callback:^(NSError *error) {
        if (error) {
            hud.label.text = @"同步失败...";
            sender.on = !sender.on;
        }else {
            hud.label.text = @"同步成功";
            [BandMessage sharedBandMessage].handRecognize = sender.isOn;
        }
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (IBAction)heartRateObserverSwitch:(UISwitch *)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步...";
    [[BLETool sharedBLETool].bandManager  syncHeartRateObserverModeWithAutoFlag:sender.on callback:^(NSError *error) {
        if (error) {
            hud.label.text = @"同步失败...";
            sender.on = !sender.on;
        }else {
            hud.label.text = @"同步成功";
            [BandMessage sharedBandMessage].heartRateObserver = sender.isOn;
        }
        [hud hideAnimated:YES afterDelay:1];
    }];
    
}

- (IBAction)findPhoneSwitch:(UISwitch *)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步...";
    [[BLETool sharedBLETool].bandManager syncFindPhoneWithOpenFlag:sender.on callback:^(NSError *error) {
        if (error) {
            hud.label.text = @"同步失败...";
            sender.on = !sender.on;
        }else {
            hud.label.text = @"同步成功";
            [BandMessage sharedBandMessage].findPhone = sender.isOn;
        }
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (IBAction)cameraSwitch:(UISwitch *)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在进入拍照模式...";
    BOOL openFlag = sender.on;
    [[BLETool sharedBLETool].bandManager syncCameraModeWithEnterFlag:openFlag callback:^(NSError *error) {
        if (error) {
            hud.label.text = @"正在进入拍照模式失败...";
            sender.on = !openFlag;
        }else {
            hud.label.text = @"正在进入拍照模式成功";
        }
        [hud hideAnimated:YES afterDelay:1];
    }];
}

@end
