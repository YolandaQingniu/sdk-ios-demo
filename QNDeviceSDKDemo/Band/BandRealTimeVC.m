//
//  BandRealTimeVC.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2019/3/8.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandRealTimeVC.h"

@interface BandRealTimeVC ()
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation BandRealTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44 + 10;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    self.timer = timer;
}

- (void)refreshData {
    __weak typeof(self) weakSelf = self;
    [[BLETool sharedBLETool].bandManager syncRealTimeHeartRateCallback:^(id obj, NSError *error) {
        NSNumber *heartRateNum = (NSNumber *)obj;
        weakSelf.heartRateLabel.text =  [NSString stringWithFormat:@"%d",[heartRateNum intValue]];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
