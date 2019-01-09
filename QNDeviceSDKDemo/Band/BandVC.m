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
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if (delegate.bandDevice == nil) {
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

- (void)dealloc {
    //该处只是demo为了方便才断开连接
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[QNBleApi sharedBleApi] disconnectDevice:delegate.bandDevice callback:^(NSError *error) {
        
    }];
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步今日数据...";
    [[[QNBleApi sharedBleApi] getBandManager] syncTodayHealthDataCallback:^(QNHealthData *healthData, NSError *error) {
        hud.label.text = @"同步今日数据完成";
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (IBAction)synHistoryHealthData:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步历史数据...";
    [[[QNBleApi sharedBleApi] getBandManager] syncHistoryHealthDataCallback:^(NSArray<QNHealthData *> *healthDatas, NSError *error) {
        hud.label.text = @"历史数据同步完成";
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (IBAction)turnToBandListVc:(id)sender {
    BandListVC *bandListVc = [[BandListVC alloc] init];
    [self.navigationController pushViewController:bandListVc animated:YES];
}

- (IBAction)cancelBind:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.bandDevice == nil) {
        [[BandMessage sharedBandMessage] cleanBandMessage];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在解绑中...";
    [[[[FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        [[[QNBleApi sharedBleApi] getBandManager] syncTodayHealthDataCallback:^(QNHealthData *healthData, NSError *error) {
            fulfill(nil);
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
            [[[QNBleApi sharedBleApi] getBandManager] syncHistoryHealthDataCallback:^(NSArray<QNHealthData *> *healthDatas, NSError *error) {
                fulfill(nil);
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
            [[[QNBleApi sharedBleApi] getBandManager] cancelBindCallback:^(NSError *error) {
                fulfill(nil);
            }];
        }];
    }] always:^{
        [[QNBleApi sharedBleApi] disconnectDevice:delegate.bandDevice callback:^(NSError *error) {
            
        }];
        [[BandMessage sharedBandMessage] cleanBandMessage];
        delegate.bandDevice = nil;
        hud.label.text = @"解绑完成";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:0];
            [self back];
        });
    }];
}

- (void)onDeviceStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state {
    [super onDeviceStateChange:device scaleState:state];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([device.mac isEqualToString:delegate.bandDevice.mac] == NO) return;
    if (state == QNScaleStateDisconnected || state == QNScaleStateLinkLoss || state == QNScaleStateLinkLoss) {
        self.stateLabel.text = @"未连接";
    }else if (state == QNScaleStateConnecting) {
        self.stateLabel.text = @"正在连接";
    }else {
        self.stateLabel.text = @"已连接";
    }
}

@end
