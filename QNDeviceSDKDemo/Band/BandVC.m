//
//  BandVC.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandVC.h"
#import "BandListVC.h"
#import "BandHealthDataView.h"

@interface BandVC ()<BLEToolDelegate>
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
    [BLETool sharedBLETool].delegate = self;
    if ([BLETool sharedBLETool].bandDevice == nil) {
        self.stateLabel.text = @"未连接";
    }else {
        self.stateLabel.text = @"已连接";
    }
    
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
        UIViewController *vc = [self.navigationController.childViewControllers objectAtIndex:self.navigationController.childViewControllers.count - 3];
        [self.navigationController popToViewController:vc animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)synTodayHealthData:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步今日数据...";
    [[BLETool sharedBLETool].bandManager syncTodayHealthDataCallback:^(QNHealthData *healthData, NSError *error) {
        NSLog(@"%@",healthData.description);
        BandHealthDataView *vc = [[BandHealthDataView alloc] init];
        vc.healthDatas = @[healthData];
        [self.navigationController pushViewController:vc animated:YES];
        hud.label.text = @"同步今日数据完成";
        [hud hideAnimated:YES afterDelay:0.2];
    }];
}

- (IBAction)synHistoryHealthData:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步历史数据...";
    [[BLETool sharedBLETool].bandManager syncHistoryHealthDataCallback:^(NSArray<QNHealthData *> *healthDatas, NSError *error) {
        hud.label.text = @"历史数据同步完成";
        BandHealthDataView *vc = [[BandHealthDataView alloc] init];
        vc.healthDatas = healthDatas;
        [self.navigationController pushViewController:vc animated:YES];
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (IBAction)turnToBandListVc:(id)sender {
    BandListVC *bandListVc = [[BandListVC alloc] init];
    [self.navigationController pushViewController:bandListVc animated:YES];
}

- (IBAction)cancelBind:(id)sender {
    if ([BLETool sharedBLETool].bandDevice == nil) {
        [[BandMessage sharedBandMessage] cleanBandMessage];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在解绑中...";
    [[[[FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        [[BLETool sharedBLETool].bandManager syncTodayHealthDataCallback:^(QNHealthData *healthData, NSError *error) {
            fulfill(nil);
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
            [[BLETool sharedBLETool].bandManager syncHistoryHealthDataCallback:^(NSArray<QNHealthData *> *healthDatas, NSError *error) {
                fulfill(nil);
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
            [[BLETool sharedBLETool].bandManager cancelBindCallback:^(NSError *error) {
                fulfill(nil);
            }];
        }];
    }] always:^{
        [[BandMessage sharedBandMessage] cleanBandMessage];
        [[BLETool sharedBLETool] disconnectBand];
        hud.label.text = @"解绑完成";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:0];
            [self back];
        });
    }];
}

#pragma mark -
- (void)qnDeviceStateChange:(QNDeviceState)state device:(QNBleDevice *)device {
    if ([device.mac isEqualToString:[BLETool sharedBLETool].bandDevice.mac] == NO) return;
    if (state == QNDeviceStateDisconnected || state == QNDeviceStateLinkLoss || state == QNDeviceStateLinkLoss) {
        self.stateLabel.text = @"未连接";
    }else if (state == QNDeviceStateConnecting) {
        self.stateLabel.text = @"正在连接";
    }else {
        self.stateLabel.text = @"已连接";
    }
}

@end
