//
//  WspConfigVC.m
//  QNDeviceSDKDemo
//
//  Created by qiudongquan on 2020/3/10.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "WspConfigVC.h"
#import "WiFiTool.h"

@interface WspConfigVC ()
@property (weak, nonatomic) IBOutlet UILabel *ssidLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *dataUrlField;
@property (weak, nonatomic) IBOutlet UITextField *otaUrlField;
@property (weak, nonatomic) IBOutlet UITextField *encryptionField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *isPairWifiSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userEventSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *updateInfoSegControl;
@property (weak, nonatomic) IBOutlet UITextField *userIndexField;
@property (weak, nonatomic) IBOutlet UITextField *userSecretField;

@property(nonatomic, strong) QNWspConfig *wspConfig;

@property(nonatomic, strong) NSMutableArray<NSNumber *> *deleteUsers;

@end

@implementation WspConfigVC

- (NSMutableArray<NSNumber *> *)deleteUsers {
    if (_deleteUsers == nil) {
        _deleteUsers = [NSMutableArray<NSNumber *> array];
    }
    return _deleteUsers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wspConfig = [[QNWspConfig alloc] init];
    self.ssidLabel.text = [WiFiTool currentWifiName];
    //一下三处根据自身服务配置
    self.dataUrlField.text = @"http://wifi.test.hk:80/wsps?code=";
    self.otaUrlField.text = @"https://ota.test.hk";
    self.encryptionField.text = @"mUm3PKiL94Ebh1dh";
    self.userSecretField.text = @"999";
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.userIndexField resignFirstResponder];
    [self.userSecretField resignFirstResponder];
}

- (IBAction)selectUserIndex:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    NSNumber *index = [NSNumber numberWithInteger:sender.tag - 100];
    if ([self.deleteUsers containsObject:index]) {
        [self.deleteUsers removeObject:index];
    } else {
        [self.deleteUsers addObject:index];
    }
}

- (IBAction)selectUserEvent:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex != 0) {
        self.updateInfoSegControl.selectedSegmentIndex = 1;
    }
}

- (IBAction)dismissVC:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dismissWspConfigVC)]) {
        [self.delegate dismissWspConfigVC];
    }
}

- (IBAction)connectDevice:(id)sender {
    if (self.isPairWifiSegControl.selectedSegmentIndex == 1) {
        QNWiFiConfig *wifiConfig = [[QNWiFiConfig alloc] init];
        wifiConfig.ssid = [WiFiTool currentWifiName];
        wifiConfig.pwd = self.pwdField.text;
        self.wspConfig.wifiConfig = wifiConfig;
        
        self.wspConfig.dataUrl = self.dataUrlField.text;
        self.wspConfig.otaUrl = self.otaUrlField.text;
        self.wspConfig.encryption = self.encryptionField.text;
    }
    
    self.wspConfig.deleteUsers = self.deleteUsers;
    
    switch (self.userEventSegControl.selectedSegmentIndex) {
        case 1: {
            self.wspConfig.isRegist = YES;
            self.wspConfig.isVisitor = NO;
        }
            break;
        case 2: {
            self.wspConfig.isRegist = NO;
            self.wspConfig.isVisitor = YES;
        }
            break;
        default:
            self.wspConfig.isRegist = NO;
            self.wspConfig.isVisitor = NO;
            break;
    }
    
    self.wspConfig.isChange = self.updateInfoSegControl.selectedSegmentIndex == 1;
    
    int index = 0;
    int secret = 0;
    //此处只为展示使用，secret的值为服务器下发
    if (self.userIndexField.text.length) {
        index = [self.userIndexField.text intValue];
    }
    
    if (self.userSecretField.text.length) {
        secret = [self.userSecretField.text intValue];
    }
    
    
    
    if ([self.delegate respondsToSelector:@selector(selectWspConfig:userIndex:userSecret:device:)]) {
        [self.delegate selectWspConfig:self.wspConfig userIndex:index userSecret:secret device:self.bleDevice];
    }
    
    if ([self.delegate respondsToSelector:@selector(dismissWspConfigVC)]) {
        [self.delegate dismissWspConfigVC];
    }
}

@end
