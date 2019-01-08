//
//  BandVC.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandVC.h"
#import "BandListVC.h"

@interface BandVC ()<QNBleConnectionChangeListener>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;
@property (weak, nonatomic) IBOutlet UILabel *electric;
@property (weak, nonatomic) IBOutlet UILabel *modeIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *firmwareLabel;
@property (weak, nonatomic) IBOutlet UILabel *hardwareLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;


@end

@implementation BandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.bandDevice == nil) {
        self.stateLabel.text = @"未连接";
    }else {
        self.stateLabel.text = @"已连接";
    }
    
    [QNBleApi sharedBleApi].connectionChangeListener = self;
    
    self.topConstraint.constant = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44 + 10;
    self.macLabel.text = [BandMessage sharedBandMessage].mac;
    self.electric.text = [NSString stringWithFormat:@"%d",[BandMessage sharedBandMessage].battery];
    self.modeIdLabel.text = [BandMessage sharedBandMessage].modeId;
    self.firmwareLabel.text = [NSString stringWithFormat:@"%d",[BandMessage sharedBandMessage].firmwareVer];
    self.hardwareLabel.text = [NSString stringWithFormat:@"%d",[BandMessage sharedBandMessage].hardwareVer];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)back {
    if (self.comeStyle == BandComeScan) {
        UIViewController *vc = [self.navigationController.childViewControllers objectAtIndex:self.navigationController.childViewControllers.count - 2];
        [self.navigationController popToViewController:vc animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)synTodayHealthData:(id)sender {
    [[[QNBleApi sharedBleApi] getBandManager] syncTodayHealthDataCallback:^(QNHealthData *healthData, NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.contentMode = MBProgressHUDModeText;
        hud.label.text = @"今日数据同步完成";
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (IBAction)synHistoryHealthData:(id)sender {
    [[[QNBleApi sharedBleApi] getBandManager] syncHistoryHealthDataCallback:^(NSArray<QNHealthData *> *healthDatas, NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.contentMode = MBProgressHUDModeText;
        hud.label.text = @"历史数据同步完成";
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (IBAction)turnToBandListVc:(id)sender {
    BandListVC *bandListVc = [[BandListVC alloc] init];
    [self.navigationController pushViewController:bandListVc animated:YES];
}

- (IBAction)cancelBind:(id)sender {
    if (self.bandDevice == nil) {
        [[BandMessage sharedBandMessage] cleanBandMessage];
        return;
    }
    
    
    
    
}

- (void)onDeviceStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state {
    [super onDeviceStateChange:device scaleState:state];

    if ([device.mac isEqualToString:self.bandDevice.mac] == NO) return;
    if (state == QNScaleStateDisconnected || state == QNScaleStateLinkLoss || state == QNScaleStateLinkLoss) {
        self.stateLabel.text = @"未连接";
    }else {
        self.stateLabel.text = @"已连接";
    }
}

@end
