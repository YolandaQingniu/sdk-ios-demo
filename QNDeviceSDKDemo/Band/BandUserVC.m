//
//  BandUserVC.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandUserVC.h"

@interface BandUserVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation BandUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44 + 10;
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
