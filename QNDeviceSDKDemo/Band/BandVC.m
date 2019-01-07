//
//  BandVC.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandVC.h"
#import "BandListVC.h"

@interface BandVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;
@property (weak, nonatomic) IBOutlet UILabel *electric;
@property (weak, nonatomic) IBOutlet UILabel *modeIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *firmwareLabel;
@property (weak, nonatomic) IBOutlet UILabel *hardwareLabel;


@end

@implementation BandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44 + 10;
}

- (IBAction)synTodayHealthData:(id)sender {
    
}

- (IBAction)synHistoryHealthData:(id)sender {
}

- (IBAction)turnToBandListVc:(id)sender {
    BandListVC *bandListVc = [[BandListVC alloc] init];
    [self.navigationController pushViewController:bandListVc animated:YES];
}

- (IBAction)cancelBind:(id)sender {
}

@end
