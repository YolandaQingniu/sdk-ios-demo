//
//  HeightSetFunctionVC.m
//  QNDeviceSDKDemo
//
//  Created by yolanda on 2025/9/8.
//  Copyright © 2025 Yolanda. All rights reserved.
//


#import "HeightSetFunctionVC.h"
#import "Masonry.h"

@interface HeightSetFunctionVC ()<QNScaleDataListener, QNLogProtocol>

@property (nonatomic, strong) QNBleApi *bleApi;
@property (nonatomic, strong) NSArray<NSString *> *btnTitle;

@property (nonatomic, strong) UILabel *deviceStateLabel;
@property (nonatomic, strong) NSMutableArray<UIButton *> *btns;
@property (nonatomic, strong) UITextView *resultTextView;

@property (nonatomic, strong) UISegmentedControl *weightUnitSegment;
@property (nonatomic, strong) UISegmentedControl *heightUnitSegment;
@property (nonatomic, strong) UISegmentedControl *languageSegment;
@property (nonatomic, strong) UISegmentedControl *volumeSegment;

@end

@implementation HeightSetFunctionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bleApi = [QNBleApi sharedBleApi];
    self.bleApi.dataListener = self;
    self.bleApi.logListener = self;
    
    self.btnTitle = @[@"设置秤端信息", @"开始配网", @"读取秤端信息", @"恢复出厂设置", @"清除Wifi配置", @"扫描周围Wifi", @"获取Wifi配置"];
    self.btns = [NSMutableArray array];
    
    [self createUI];
}

#pragma mark - QNLogProtocol
- (void)onLog:(NSString *)log {
    NSLog(@"%@",log);
}

#pragma mark - QNScaleDataListener

- (void)onGetBarCode:(NSString *)barCode {
    self.resultTextView.text = [NSString stringWithFormat:@"条形码：%@", barCode ?: @""];
}

- (void)onSetHeightScaleConfigState:(BOOL)isLanguageSuccess
                isWeightUnitSuccess:(BOOL)isWeightUnitSuccess
                isHeightUnitSuccess:(BOOL)isHeightUnitSuccess
                    isVolumeSuccess:(BOOL)isVolumeSuccess
                             device:(QNBleDevice *)device {
    self.resultTextView.text = [NSString stringWithFormat:@"设置语言：%@ 设置体重单位：%@ 设置身高单位：%@ 设置音量：%@",
                                isLanguageSuccess ? @"成功" : @"失败",
                                isWeightUnitSuccess ? @"成功" : @"失败",
                                isHeightUnitSuccess ? @"成功" : @"失败",
                                isVolumeSuccess ? @"成功" : @"失败"];
}

- (void)onGetHeightScaleConfig:(QNHeightDeviceFunction *)function device:(QNBleDevice *)device {
    NSMutableString *configInfo = [NSMutableString stringWithString:@"获取身高秤配置信息：\n"];
    
    if (function) {
        [configInfo appendFormat:@"体重单位：%ld\n", (long)function.weightUnit];
        [configInfo appendFormat:@"身高单位：%ld\n", (long)function.heightUnit];
        [configInfo appendFormat:@"语言设置：%ld\n", (long)function.voiceLanguage];
        [configInfo appendFormat:@"音量设置：%ld\n", (long)function.volume];
    } else {
        [configInfo appendString:@"获取配置失败"];
    }
    
    self.resultTextView.text = configInfo;
}

- (void)onResetHeightScaleState:(BOOL)state device:(QNBleDevice *)device {
    NSString *resetResult = state ? @"成功" : @"失败";
    self.resultTextView.text = [NSString stringWithFormat:@"恢复出厂设置：%@", resetResult];
}

- (void)onGetHeightScaleWifiConfig:(BOOL)state ssid:(NSString *)ssid device:(QNBleDevice *)device {
    NSMutableString *wifiInfo = [NSMutableString stringWithFormat:@"获取WiFi配置：%@\n", state ? @"成功" : @"失败"];
    
    if (ssid) {
        [wifiInfo appendFormat:@"当前连接的WiFi：%@", ssid];
    } else {
        [wifiInfo appendString:@"身高秤未进行WiFi配网或获取wifi失败"];
    }
    
    self.resultTextView.text = wifiInfo;
}

- (void)onClearHeightScaleWifiConfigState:(BOOL)state device:(QNBleDevice *)device {
    NSString *clearResult = state ? @"成功" : @"失败";
    self.resultTextView.text = [NSString stringWithFormat:@"清除WiFi配置：%@", clearResult];
}

- (void)onScanHeightScaleWifiSsidResult:(NSString *)ssid rssi:(int32_t)rssi device:(QNBleDevice *)device {
    NSString *currentText = self.resultTextView.text ?: @"";
    NSString *newWifiInfo = [NSString stringWithFormat:@"发现WiFi：%@ 信号强度：%ddBm\n", ssid ?: @"未知", rssi];
    
    if ([currentText containsString:@"扫描到的WiFi列表："]) {
        self.resultTextView.text = [currentText stringByAppendingString:newWifiInfo];
    } else {
        self.resultTextView.text = [@"扫描到的WiFi列表：\n" stringByAppendingString:newWifiInfo];
    }
}

- (void)onScanHeightScaleWifiSsidFinish:(int32_t)state device:(QNBleDevice *)device {
    NSString *currentText = self.resultTextView.text ?: @"";
    NSString *finishInfo = [NSString stringWithFormat:@"\n扫描完成：%@", state == 1 ? @"成功" : @"失败"];
    self.resultTextView.text = [currentText stringByAppendingString:finishInfo];
}

- (void)onScaleStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state {
    switch (state) {
        case QNScaleStateConnected:
            self.deviceStateLabel.text = @"设备已连接";
            break;
        case QNScaleStateDisconnected:
            self.deviceStateLabel.text = @"设备未连接";
            break;
        case QNScaleStateRealTime:
            self.deviceStateLabel.text = @"正在测量体重";
            break;
        case QNScaleStateBodyFat:
            self.deviceStateLabel.text = @"正在测量生物阻抗";
            break;
        case QNScaleStateMeasureCompleted:
            self.deviceStateLabel.text = @"完成测量";
            break;
        case QNScaleStateHeightScaleMeasureFail:
            self.deviceStateLabel.text = @"测量失败";
            break;
        case QNScaleStateWiFiBleStartNetwork:
            self.deviceStateLabel.text = @"开始wifi配网";
            self.resultTextView.text = @"开始wifi配网";
            break;
        case QNScaleStateWiFiBleNetworkSuccess:
            self.deviceStateLabel.text = @"wifi配网成功";
            self.resultTextView.text = @"wifi配网成功";
            break;
        case QNScaleStateWiFiBleNetworkFail:
            self.deviceStateLabel.text = @"wifi配网失败";
            self.resultTextView.text = @"wifi配网失败";
            break;
        default:
            break;
    }
}


- (void)onGetBleVer:(QNBleDevice *)device bleVer:(int32_t)bleVer {
    
}

- (void)onGetElectric:(NSUInteger)electric device:(QNBleDevice *)device { 
    
}


- (void)onGetScaleData:(QNBleDevice *)device data:(QNScaleData *)scaleData { 
    
}


- (void)onGetStoredScale:(QNBleDevice *)device data:(NSArray<QNScaleStoreData *> *)storedDataList { 
    
}


- (void)onGetUnsteadyWeight:(QNBleDevice *)device weight:(double)weight { 
    
}


- (void)onScaleEventChange:(QNBleDevice *)device scaleEvent:(QNScaleEvent)scaleEvent { 
    
}


#pragma mark - UI Creation
- (void)createUI {
    self.title = @"连接设备";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backHandle)];
    
    // Device State Label
    self.deviceStateLabel = [[UILabel alloc] init];
    self.deviceStateLabel.numberOfLines = 0;
    self.deviceStateLabel.text = @"";
    
    // Result Text View
    self.resultTextView = [[UITextView alloc] init];
    self.resultTextView.backgroundColor = [UIColor lightGrayColor];
    self.resultTextView.font = [UIFont systemFontOfSize:13.0];
    self.resultTextView.layer.cornerRadius = 10;
    self.resultTextView.clipsToBounds = YES;
    self.resultTextView.textAlignment = NSTextAlignmentLeft;
    self.resultTextView.scrollEnabled = YES;
    self.resultTextView.editable = NO;
    
    // Add to view
    [self.view addSubview:self.deviceStateLabel];
    [self.view addSubview:self.resultTextView];
    
    // Constraints
    [self.deviceStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset([self statusBarHeight] + [self navHeight] + 15.0);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
    }];
    
    UIButton *lastBtn = [self setupActionBtnWithTopView:self.deviceStateLabel];
    UISegmentedControl *lastSegmentControl = [self setupSettingDeviceConfigViewWithTopView:lastBtn];
    
    [self.resultTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastSegmentControl.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
        make.height.equalTo(@150);
    }];
}

- (UIButton *)setupActionBtnWithTopView:(UIView *)topView {
    CGFloat padding = 15.0;
    CGFloat eachWidth = ([UIScreen mainScreen].bounds.size.width - 6 * padding) / 5.0;
    CGFloat eachHeight = 45.0;
    UIButton *lastBtn = [[UIButton alloc] init];
    
    // Create buttons
    [self.btns removeAllObjects];
    for (int i = 0; i < self.btnTitle.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.btnTitle[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor systemBlueColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            btn.titleLabel.font = [UIFont systemFontOfSize:8];
        }
        
        btn.layer.cornerRadius = 5;
        btn.tag = i;
        [btn addTarget:self action:@selector(indexButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btns addObject:btn];
        [self.view addSubview:btn];
    }
    
    // Layout buttons
    for (int i = 0; i < self.btns.count; i++) {
        CGFloat top = 20.0 + (i / 5) * (eachHeight + 20.0);
        CGFloat leading = (i % 5) * (eachWidth + padding) + padding;
        
        [self.btns[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).offset(top);
            make.leading.equalTo(self.view).offset(leading);
            make.width.equalTo(@(eachWidth));
            make.height.equalTo(@(eachHeight));
        }];
        
        if (i == self.btns.count - 1) {
            lastBtn = self.btns[i];
        }
    }
    
    return lastBtn;
}

- (UISegmentedControl *)setupSettingDeviceConfigViewWithTopView:(UIView *)topView {
    // Weight Unit
    UILabel *unitLabel = [[UILabel alloc] init];
    unitLabel.text = @"设置体重单位：";
    unitLabel.font = [UIFont systemFontOfSize:14];
    
    self.weightUnitSegment = [[UISegmentedControl alloc] initWithItems:@[@"kg", @"LB", @"斤", @"STLB", @"不设置"]];
    self.weightUnitSegment.selectedSegmentIndex = 0;
    
    // Height Unit
    UILabel *heightUnitLabel = [[UILabel alloc] init];
    heightUnitLabel.text = @"设置身高单位：";
    heightUnitLabel.font = [UIFont systemFontOfSize:14];
    
    self.heightUnitSegment = [[UISegmentedControl alloc] initWithItems:@[@"cm", @"ft:in", @"in", @"ft", @"不设置"]];
    self.heightUnitSegment.selectedSegmentIndex = 0;
    
    // Language
    UILabel *languageLabel = [[UILabel alloc] init];
    languageLabel.text = @"设置语音语种：";
    languageLabel.font = [UIFont systemFontOfSize:14];
    
    self.languageSegment = [[UISegmentedControl alloc] initWithItems:@[@"中文播报", @"英文播报", @"阿拉伯语播报", @"不设置"]];
    self.languageSegment.selectedSegmentIndex = 0;
    
    // Volume
    UILabel *volumeLabel = [[UILabel alloc] init];
    volumeLabel.text = @"设置音量：";
    volumeLabel.font = [UIFont systemFontOfSize:14];
    
    self.volumeSegment = [[UISegmentedControl alloc] initWithItems:@[@"静音", @"1档音量", @"2档音量", @"3档音量", @"不设置"]];
    self.volumeSegment.selectedSegmentIndex = 4;
    
    // Add to view
    [self.view addSubview:unitLabel];
    [self.view addSubview:self.weightUnitSegment];
    [self.view addSubview:heightUnitLabel];
    [self.view addSubview:self.heightUnitSegment];
    [self.view addSubview:languageLabel];
    [self.view addSubview:self.languageSegment];
    [self.view addSubview:volumeLabel];
    [self.view addSubview:self.volumeSegment];
    
    // Constraints
    CGFloat segmentWidth = 450;
    /// 如果是iPhone手机，根据屏幕的长度来决定segmentWidth
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        // 减去左边距20 + 标签宽度约110 + 间距10，剩余宽度作为segment宽度
        segmentWidth = screenWidth - 20 - 110 - 10;
        // 设置最小宽度，确保segment能正常显示
        if (segmentWidth < 200) {
            segmentWidth = 200;
        }
    }
    
    
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
    }];
    
    [self.weightUnitSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(unitLabel);
        make.left.equalTo(unitLabel.mas_right).offset(0);
        make.width.equalTo(@(segmentWidth));
    }];
    
    [heightUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(unitLabel.mas_bottom).offset(20);
        make.left.equalTo(unitLabel);
    }];
    
    [self.heightUnitSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(heightUnitLabel);
        make.left.equalTo(self.weightUnitSegment);
        make.width.equalTo(@(segmentWidth));
        make.height.equalTo(@30);
    }];
    
    [languageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(heightUnitLabel.mas_bottom).offset(20);
        make.left.equalTo(heightUnitLabel);
    }];
    
    [self.languageSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(languageLabel);
        make.left.equalTo(self.weightUnitSegment);
        make.width.equalTo(@(segmentWidth));
    }];
    
    [volumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(languageLabel.mas_bottom).offset(20);
        make.left.equalTo(languageLabel);
    }];
    
    [self.volumeSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(volumeLabel);
        make.left.equalTo(self.weightUnitSegment);
        make.width.equalTo(@(segmentWidth));
    }];
    
    return self.volumeSegment;
}

#pragma mark - Button Actions
- (void)indexButtonAction:(UIButton *)sender {
    NSInteger index = sender.tag;
    
    if (index == 0) {
        self.resultTextView.text = @"设置秤端信息";
        [self setHeightScaleFunction];
    } else if (index == 1) {
        self.deviceStateLabel.text = @"开始配网";
        [self wifiPairAction];
    } else if (index == 2) {
        self.resultTextView.text = @"读取秤端信息";
        [self.bleApi getHeightScaleConfig:^(NSError *error) {
            if (error) {
                self.resultTextView.text = [NSString stringWithFormat:@"调用失败：%@", error.localizedDescription];
            } else {
                NSLog(@"调用成功");
            }
        }];
    } else if (index == 3) {
        self.resultTextView.text = @"恢复出厂设置";
        [self.bleApi resetHeightScale:^(NSError *error) {
            if (error) {
                self.resultTextView.text = [NSString stringWithFormat:@"调用失败：%@", error.localizedDescription];
            } else {
                NSLog(@"调用成功");
            }
        }];
    } else if (index == 4) {
        self.resultTextView.text = @"清除Wifi配置";
        [self.bleApi clearHeightScaleWifiConfig:^(NSError *error) {
            if (error) {
                self.resultTextView.text = [NSString stringWithFormat:@"调用失败：%@", error.localizedDescription];
            } else {
                NSLog(@"调用成功");
            }
        }];
    } else if (index == 5) {
        self.resultTextView.text = nil;
        [self.bleApi scanHeightScaleWifiSsid:^(NSError *error) {
            if (error) {
                self.resultTextView.text = [NSString stringWithFormat:@"调用失败：%@", error.localizedDescription];
            } else {
                NSLog(@"调用成功");
            }
        }];
    } else if (index == 6) {
        self.resultTextView.text = @"获取Wifi配置";
        [self.bleApi getHeightScaleWifiConfig:^(NSError *error) {
            if (error) {
                self.resultTextView.text = [NSString stringWithFormat:@"调用失败：%@", error.localizedDescription];
            } else {
                NSLog(@"调用成功");
            }
        }];
    }
}

- (void)setHeightScaleFunction {
    QNHeightDeviceFunction *setFunction = [[QNHeightDeviceFunction alloc] init];
    
    // Weight Unit
    switch (self.weightUnitSegment.selectedSegmentIndex) {
        case 0: setFunction.weightUnit = QNUnitKG; break;
        case 1: setFunction.weightUnit = QNUnitLB; break;
        case 2: setFunction.weightUnit = QNUnitJIN; break;
        case 3: setFunction.weightUnit = QNUnitStLb; break;
        default: break;
    }
    
    // Height Unit
    switch (self.heightUnitSegment.selectedSegmentIndex) {
        case 0: setFunction.heightUnit = QNHeightUnitCM; break;
        case 1: setFunction.heightUnit = QNHeightUnitFtIn; break;
        case 2: setFunction.heightUnit = QNHeightUnitIn; break;
        case 3: setFunction.heightUnit = QNHeightUnitFt; break;
        default: break;
    }
    
    // Language
    switch (self.languageSegment.selectedSegmentIndex) {
        case 0: setFunction.voiceLanguage = QNLanguageZH; break;
        case 1: setFunction.voiceLanguage = QNLanguageEN; break;
        case 2: setFunction.voiceLanguage = QNLanguageArabic; break;
        default: break;
    }
    
    // Volume
    switch (self.volumeSegment.selectedSegmentIndex) {
        case 0: setFunction.volume = QNVolumeZero; break;
        case 1: setFunction.volume = QNVolumeOne; break;
        case 2: setFunction.volume = QNVolumeTwo; break;
        case 3: setFunction.volume = QNVolumeThree; break;
        default: break;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.bleApi setHeightScaleConfig:setFunction callback:^(NSError *error) {
        if (error) {
            weakSelf.resultTextView.text = [NSString stringWithFormat:@"调用失败：%@", error.localizedDescription];
        } else {
            NSLog(@"调用成功");
        }
    }];
}

- (void)wifiPairAction {
    NSString *wifiName = @"King";
    NSString *pwd = @"987654321";
    NSString *serviceUrl = @"https://sit-wspmock.yolanda.hk/aios/measurements/get_cp30b_data?";
    NSString *encryption = @"yolandakitnewhdr";
    NSString *otaUrl = @"https://ota.yolanda.hk";
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"设备配网"
                                                                     message:@"如不需要配网，请点击取消"
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = wifiName;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.placeholder = @"若该WiFi无密码则无需输入";
        textField.text = pwd;
    }];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = serviceUrl;
        textField.placeholder = @"serverURL";
        textField.textAlignment = NSTextAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = encryption;
        textField.placeholder = @"请输入encryption";
        textField.textAlignment = NSTextAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = otaUrl;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.placeholder = @"otaURL";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *pairAction = [UIAlertAction actionWithTitle:@"Wifi配网"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
        NSString *wifiName = alertVC.textFields[0].text;
        NSString *wifiPwd = alertVC.textFields[1].text;
        NSString *serverUrl = alertVC.textFields[2].text;
        NSString *encryption = alertVC.textFields[3].text;
        NSString *otaUrl = alertVC.textFields[4].text;
        
        QNWiFiConfig *scaleWifiConfig = [[QNWiFiConfig alloc] init];
        scaleWifiConfig.ssid = wifiName;
        scaleWifiConfig.pwd = wifiPwd;
        scaleWifiConfig.serveUrl = serverUrl;
        scaleWifiConfig.encryptionKey = encryption;
        scaleWifiConfig.fotaUrl = otaUrl;
        
        [weakSelf.bleApi startPairHeightScaleWifi:scaleWifiConfig callback:^(NSError *error) {
            if (error) {
                weakSelf.resultTextView.text = [NSString stringWithFormat:@"调用失败：%@", error.localizedDescription];
            } else {
                NSLog(@"调用配网成功");
            }
        }];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:pairAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)backHandle {
    if (self.connectedDevice) {
        [self.bleApi disconnectDevice:self.connectedDevice callback:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper Methods
- (CGFloat)statusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

- (CGFloat)navHeight {
    return self.navigationController.navigationBar.frame.size.height;
}


#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"%s dealloc",__func__);
}


@end
