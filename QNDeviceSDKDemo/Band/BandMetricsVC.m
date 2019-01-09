//
//  BandMetricsVC.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandMetricsVC.h"

@interface BandMetricsVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lengthSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *languageSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hourFormatSetControl;

@end

@implementation BandMetricsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44 + 10;
    
    [self update];
    
}

- (void)update {
    self.lengthSegControl.selectedSegmentIndex = [BandMessage sharedBandMessage].length == QNBandLengthModeMetric ? 0 : 1;
    self.languageSegControl.selectedSegmentIndex = [BandMessage sharedBandMessage].language == QNBandLanguageModeChina ? 0 : 1;
    self.hourFormatSetControl.selectedSegmentIndex = [BandMessage sharedBandMessage].hourFormat == QNBandFormatHourMode24? 0 : 1;
}

- (IBAction)lengthSelected:(UISegmentedControl *)sender {
    [self syncMetrics];
}

- (IBAction)languageSelected:(UISegmentedControl *)sender {
    [self syncMetrics];
}

- (IBAction)hourFormatSelected:(UISegmentedControl *)sender {
    [self syncMetrics];
}

- (void)syncMetrics {
    QNBandMetrics *metrics = [[QNBandMetrics alloc] init];
    metrics.language = self.languageSegControl.selectedSegmentIndex;
    metrics.length = self.lengthSegControl.selectedSegmentIndex;
    metrics.formatHour = self.hourFormatSetControl.selectedSegmentIndex;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步...";
    [[[QNBleApi sharedBleApi] getBandManager] syncMetrics:metrics callback:^(NSError *error) {
        if (error) {
            hud.label.text = @"同步失败...";
            [self update];
        }else {
            hud.label.text = @"同步成功";
            [BandMessage sharedBandMessage].length = metrics.length;
            [BandMessage sharedBandMessage].language = metrics.language;
            [BandMessage sharedBandMessage].hourFormat = metrics.formatHour;
        }
        [hud hideAnimated:YES afterDelay:1];
    }];
}



@end
