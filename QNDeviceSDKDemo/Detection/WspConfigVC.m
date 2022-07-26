//
//  WspConfigVC.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2020/3/10.
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
@property (weak, nonatomic) IBOutlet UITextField *userIndexField;
@property (weak, nonatomic) IBOutlet UITextField *userSecretField;

@property(nonatomic, strong) QNUserScaleConfig *userConfig;

@property(nonatomic, strong) NSMutableArray *userList;
@property (weak, nonatomic) IBOutlet UISwitch *isVisitorSwitch;

@end

@implementation WspConfigVC

- (NSMutableArray *)userList {
    if (_userList == nil) {
        _userList = [NSMutableArray array];
    }
    return _userList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userConfig = [[QNUserScaleConfig alloc] init];
    self.ssidLabel.text = [WiFiTool currentWifiName];
    //一下三处根据自身服务配置
    self.dataUrlField.text = @"http://wsp-lite.yolanda.hk:80/yolanda/wsp?code=";
    self.otaUrlField.text = @"https://ota.yolanda.hk";
    self.encryptionField.text = @"yolandakitnewhdr";
    self.userSecretField.text = @"1000";
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.userIndexField resignFirstResponder];
    [self.userSecretField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    [self.dataUrlField resignFirstResponder];
    [self.otaUrlField resignFirstResponder];
    [self.encryptionField resignFirstResponder];
}

- (IBAction)selectUserIndex:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    NSNumber *index = [NSNumber numberWithInteger:sender.tag - 100];
    if ([self.userList containsObject:index]) {
        [self.userList removeObject:index];
    } else {
        [self.userList addObject:index];
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
        wifiConfig.serveUrl = self.dataUrlField.text;
        self.userConfig.wifiConfig = wifiConfig;
        self.userConfig.otaUrl = self.otaUrlField.text;
        self.userConfig.encryption = self.encryptionField.text;
    }
    
    NSMutableArray *users = [NSMutableArray array];
    for (NSNumber *index in self.userList) {
        QNUser *user = [[QNUser alloc] init];
        user.index = [index intValue];
        [users addObject:user];
    }
    if (users.count > 0) {
        self.userConfig.userlist = users;
    }
    self.userConfig.isVisitor = self.isVisitorSwitch.isOn;
    int index = 0;
    int secret = 0;
    //此处只为展示使用，secret的值为服务器下发
    if (self.userIndexField.text.length) {
        index = [self.userIndexField.text intValue];
    }
    
    if (self.userSecretField.text.length) {
        secret = [self.userSecretField.text intValue];
    }
    
    if ([self.delegate respondsToSelector:@selector(selectUserConfig:userIndex:userSecret:device:)]) {
        [self.delegate selectUserConfig:self.userConfig userIndex:index userSecret:secret device:self.bleDevice];
    }
    
    if ([self.delegate respondsToSelector:@selector(dismissWspConfigVC)]) {
        [self.delegate dismissWspConfigVC];
    }
}

@end
