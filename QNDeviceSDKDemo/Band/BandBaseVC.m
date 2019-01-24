//
//  BandBaseVC.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2019/1/21.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandBaseVC.h"

@interface BandBaseVC ()

@end

@implementation BandBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([BLETool sharedBLETool].bandDevice == nil && [BandMessage sharedBandMessage].mac.length > 0) {
        [[BLETool sharedBLETool] scanDevice];
    }
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
