//
//  SlimScaleSetFunctionVC.m
//  QNDeviceSDKDemo
//
//  Created by yolanda on 2025/11/3.
//  Copyright © 2025 Yolanda. All rights reserved.
//

#import "SlimScaleSetFunctionVC.h"
#import "QNDeviceSDK.h"
#import "Masonry.h"

@interface SlimScaleSetFunctionVC () <QNBleConnectionChangeListener, QNUserScaleDataListener, QNScaleDataListener>

@property (nonatomic, strong) QNBleApi *bleApi;

// UI控件
@property (nonatomic, strong) NSArray<NSString *> *btnTitles;
@property (nonatomic, strong) NSMutableArray<UIButton *> *btns;
@property (nonatomic, strong) UILabel *deviceLabel;
@property (nonatomic, strong) UILabel *deviceStateLabel;
@property (nonatomic, strong) UITextView *resultTextView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *userIndexBtns;

// 减重秤配置相关控件
@property (nonatomic, strong) UISegmentedControl *alarmOperationSegment;
@property (nonatomic, strong) NSArray<NSString *> *weeksTitles;
@property (nonatomic, strong) NSMutableArray<UIButton *> *weekButtons;
@property (nonatomic, strong) UITextField *hourTextField;
@property (nonatomic, strong) UITextField *minuteTextField;
@property (nonatomic, strong) UISegmentedControl *volumeSegment;

// 闹钟提醒提示音配置 上秤测量提示音配置  测量完成提示音配置 完成目标提示音配置
// 请完成闹钟提醒提示音配置 上秤测量提示音配置  测量完成提示音配置 完成目标提示音配置
// 每个配置均包含


// 用户减重配置相关控件
@property (nonatomic, strong) UITextField *userIndexTextField;
@property (nonatomic, strong) UITextField *targetWeightTextField;
@property (nonatomic, strong) UITextField *currentWeightTextField;

// 曲线数据相关控件
@property (nonatomic, strong) UITextField *curveUserIndexTextField;
@property (nonatomic, strong) UISwitch *todayFlagSwitch;

@end

@implementation SlimScaleSetFunctionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bleApi = [QNBleApi sharedBleApi];
    self.bleApi.dataListener = self;
    self.bleApi.connectionChangeListener = self;
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    NSLog(@"*************************** SlimScaleSetFunctionVC 已完全释放  ******************");
}

#pragma mark - Lazy Loading

- (NSArray<NSString *> *)btnTitles {
    if (!_btnTitles) {
        _btnTitles = @[@"注册用户", @"访问用户", @"删除用户坑位", @"设置减重秤配置", @"设置用户减重配置", @"设置用户曲线数据", @"恢复出厂设置"];
    }
    return _btnTitles;
}

- (NSMutableArray<UIButton *> *)btns {
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray<UIButton *> *)userIndexBtns {
    if (!_userIndexBtns) {
        _userIndexBtns = [NSMutableArray array];
    }
    return _userIndexBtns;
}

- (NSArray<NSString *> *)weeksTitles {
    if (!_weeksTitles) {
        _weeksTitles = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    }
    return _weeksTitles;
}

- (NSMutableArray<UIButton *> *)weekButtons {
    if (!_weekButtons) {
        _weekButtons = [NSMutableArray array];
    }
    return _weekButtons;
}

#pragma mark - QNBleConnectionChangeListener

- (void)onConnecting:(QNBleDevice *)device {
    self.resultTextView.text = [NSString stringWithFormat:@"设备：%@正在连接", device.bluetoothName];
}

- (void)onConnected:(QNBleDevice *)device {
    self.resultTextView.text = [NSString stringWithFormat:@"设备：%@已连接", device.bluetoothName];
}

- (void)onServiceSearchComplete:(QNBleDevice *)device {
    self.resultTextView.text = [NSString stringWithFormat:@"设备：%@发现服务成功", device.bluetoothName];
}

- (void)onDisconnecting:(QNBleDevice *)device {
    self.resultTextView.text = [NSString stringWithFormat:@"设备：%@正在断开连接", device.bluetoothName];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onDisconnected:(QNBleDevice *)device {
    self.resultTextView.text = [NSString stringWithFormat:@"设备：%@已断开连接", device.bluetoothName];
}

- (void)onConnectError:(QNBleDevice *)device error:(NSError *)error {
    // Handle connection error
}

#pragma mark - QNUserScaleDataListener & QNScaleDataListener

- (void)onGetElectric:(NSUInteger)electric device:(QNBleDevice *)device {
    // Handle electric data
}

- (void)onGetUnsteadyWeight:(QNBleDevice *)device weight:(double)weight {
    self.resultTextView.text = [NSString stringWithFormat:@"实时体重:%.1f", weight];
}

- (void)onGetScaleData:(QNBleDevice *)device data:(QNScaleData *)scaleData {
    self.resultTextView.text = [NSString stringWithFormat:@"获取测量数据 体重：%.1f 身高：%f bmi：%.1f 50阻抗：%ld 500阻抗：%ld",
                                scaleData.weight, scaleData.height, [scaleData getItemValue:QNScaleTypeBMI], scaleData.resistance50, (long)scaleData.resistance500];
}

- (void)onGetStoredScale:(QNBleDevice *)device data:(NSArray<QNScaleStoreData *> *)storedDataList {
    for (QNScaleStoreData *storedData in storedDataList) {
        if (![self.resultTextView.text hasPrefix:@"获取历史数据"]) {
            self.resultTextView.text = [NSString stringWithFormat:@"获取历史数据 体重：%.1f 身高：%f 50阻抗：%ld 500阻抗：%ld",
                                      storedData.weight, storedData.height, storedData.resistance50, storedData.resistance500];
        } else {
            self.resultTextView.text = [NSString stringWithFormat:@"%@\n\n获取历史数据 体重：%.1f 身高：%f 50阻抗：%ld 500阻抗：%ld",
                                      self.resultTextView.text, storedData.weight, storedData.height, storedData.resistance50, storedData.resistance500];
        }
    }
}

- (void)onScaleStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state {
    NSLog(@"设置状态已更新");
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case QNScaleStateDisconnected:
                self.resultTextView.text = @"设备未连接";
                self.deviceStateLabel.text = @"设备状态：未连接";
                break;
            case QNScaleStateConnected:
                self.resultTextView.text = @"设备已连接";
                self.deviceStateLabel.text = @"设备状态：已连接";
                break;
            case QNScaleStateLinkLoss:
                self.resultTextView.text = @"设备断开连接";
                self.deviceStateLabel.text = @"设备状态：断开连接";
                [self disconnectCurrentDevice];
                break;
            default:
                break;
        }
    });
}

- (void)onScaleEventChange:(QNBleDevice *)device scaleEvent:(QNScaleEvent)scaleEvent {
    NSString *message = @"";
    
    switch (scaleEvent) {
        case QNScaleEventWiFiBleStartNetwork:
            message = @"WiFi蓝牙双模设备开始配网";
            break;
        case QNScaleEventWiFiBleNetworkSuccess:
            message = @"WiFi蓝牙双模设备联网成功";
            break;
        case QNScaleEventWiFiBleNetworkFail:
            message = @"WiFi蓝牙双模设备联网失败";
            break;
        case QNScaleEventRegistUserSuccess:
            message = @"注册用户成功";
            break;
        case QNScaleEventRegistUserFail:
            message = @"注册用户失败";
            break;
        case QNScaleEventVisitUserSuccess:
            message = @"访问用户成功";
            break;
        case QNScaleEventVisitUserFail:
            message = @"访问用户失败";
            break;
        case QNScaleEventDeleteUserSuccess:
            message = @"删除用户成功";
            break;
        case QNScaleEventDeleteUserFail:
            message = @"删除用户失败";
            break;
        case QNScaleEventSyncUserInfoSuccess:
            message = @"同步用户信息成功";
            break;
        case QNScaleEventSyncUserInfoFail:
            message = @"同步用户信息失败";
            break;
        case QNScaleEventUpdateIdentifyWeightSuccess:
            message = @"更新用户识别体重成功";
            break;
        case QNScaleEventUpdateIdentifyWeightFail:
            message = @"更新用户识别体重失败";
            break;
        case QNScaleEventUpdateScaleConfigSuccess:
            message = @"更新秤端设置成功";
            break;
        case QNScaleEventUpdateScaleConfigFail:
            message = @"更新秤端设置失败";
            break;
        case QNScaleEventUpdateUserCurveWeightDataSuccess:
            message = @"更新用户曲线体重数据成功";
            break;
        case QNScaleEventUpdateUserCurveWeightDataFail:
            message = @"更新用户曲线体重数据失败";
            break;
        case QNScaleEventUpdateUserSlimConfigSuccess:
            message = @"更新用户减重配置成功";
            break;
        case QNScaleEventUpdateUserSlimConfigFail:
            message = @"更新用户减重配置失败";
            break;
        case QNScaleEventRestoreFactorySettingsSuccess:
            message = @"恢复出厂设置成功";
            break;
        case QNScaleEventRestoreFactorySettingsFail:
            message = @"恢复出厂设置失败";
            break;
        default:
            message = [NSString stringWithFormat:@"未知事件: %ld", (long)scaleEvent];
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.deviceStateLabel.text = [NSString stringWithFormat:@"秤事件：%@", message];
    });
}

- (void)onGetBleVer:(QNBleDevice *)device bleVer:(int32_t)bleVer {
    self.deviceLabel.text = [NSString stringWithFormat:@"设备:%@ 型号标识:%@ MAC:%@ 软件版本:%d scaleVer:%d bleVer:%d", 
                            device.bluetoothName ?: @"", device.modeId ?: @"", device.mac ?: @"", device.softwareVer, device.hardwareVer, bleVer];
    self.resultTextView.text = [NSString stringWithFormat:@"蓝牙版本：%d", bleVer];
}

- (void)deviceRestoreFactorySettings:(BOOL)state device:(QNBleDevice *)device user:(QNUser *)user {
    self.resultTextView.text = state ? @"恢复出厂设置成功" : @"恢复出厂设置失败";
    self.deviceStateLabel.text = state ? @"恢复出厂设置成功" : @"恢复出厂设置失败";
}

- (void)updateUserCurveDataResult:(BOOL)success device:(QNBleDevice *)device userIndex:(int)userIndex {
    self.resultTextView.text = success ? @"更新用户体重曲线数据成功" : @"更新用户体重曲线数据失败";
    self.deviceStateLabel.text = success ? @"更新用户体重曲线数据成功" : @"更新用户体重曲线数据失败";
}

- (void)updateSlimDeviceConfigResult:(BOOL)success device:(QNBleDevice *)device {
    self.resultTextView.text = success ? @"减重秤的配置更新成功" : @"减重秤的配置更新失败";
    self.deviceStateLabel.text = success ? @"减重秤的配置更新成功" : @"减重秤的配置更新失败";
}

- (void)updateUserSlimConfigResult:(BOOL)success device:(QNBleDevice *)device userIndex:(int)userIndex {
    self.resultTextView.text = success ? @"用户减重配置更新成功" : @"用户减重配置更新失败";
    self.deviceStateLabel.text = success ? @"用户减重配置更新成功" : @"用户减重配置更新失败";
}

#pragma mark - Event Handlers

- (void)backHandle {
    [self disconnectCurrentDevice];
}

- (void)clickButtonAction:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self registerUser];
            break;
        case 1:
            [self vistorUser];
            break;
        case 2:
            [self deleteUsers];
            break;
        case 3:
            [self setSlimScaleConfig];
            break;
        case 4:
            [self setUserSlimConfig];
            break;
        case 5:
            [self setUserCurveData];
            break;
        case 6:
            [self restoreSettings];
            break;
        default:
            break;
    }
}

- (void)selectUserIndexs:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)weekButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    sender.backgroundColor = sender.selected ? [UIColor systemBlueColor] : [UIColor lightGrayColor];
}

#pragma mark - Business Logic

- (void)registerUser {
    QNUser *user = [[QNUser alloc] init];
    user.athleteType = YLAthleteDefault;
    user.gender = @"female";
    user.height = 164;
    user.birthday = [NSDate dateWithTimeIntervalSince1970:1114948155];
    
    __weak typeof(self) weakSelf = self;
    [self.bleApi switchUserScaleUser:user callback:^(NSError * _Nullable error) {
        if (error) {
            weakSelf.resultTextView.text = error.localizedDescription;
        }
    }];
}

- (void)vistorUser {
    QNUser *user = [[QNUser alloc] init];
    user.athleteType = YLAthleteDefault;
    user.gender = @"male";
    user.height = 170;
    user.birthday = [NSDate dateWithTimeIntervalSince1970:814948155];
    user.index = 2;
    user.secret = 1000;
    
    __weak typeof(self) weakSelf = self;
    [self.bleApi switchUserScaleUser:user callback:^(NSError * _Nullable error) {
        if (error) {
            weakSelf.resultTextView.text = error.localizedDescription;
        }
    }];
}

- (void)deleteUsers {
    NSMutableArray<NSNumber *> *userIndexs = [NSMutableArray array];
    for (NSInteger i = 0; i < self.userIndexBtns.count; i++) {
        UIButton *subBtn = self.userIndexBtns[i];
        if (subBtn.selected) {
            [userIndexs addObject:@(i + 1)];
        }
    }
    
    if (userIndexs.count == 0) {
        self.resultTextView.text = @"请先选择要删除的用户坑位";
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.bleApi deleteScaleUsers:userIndexs callback:^(NSError * _Nullable error) {
        if (error) {
            weakSelf.resultTextView.text = error.localizedDescription;
        }
    }];
}

- (void)setSlimScaleConfig {
    QNSlimDeviceConfig *config = [[QNSlimDeviceConfig alloc] init];
    
    // 根据UI控件设置闹钟操作
    NSString *log = @"更新秤端设置 ";
    switch (self.alarmOperationSegment.selectedSegmentIndex) {
        case 0:
            config.alarmOperation = QNSlimAlarmOperationNoModify;
            log = [NSString stringWithFormat:@"%@ 【不更改】",log];
            break;
        case 1:
            config.alarmOperation = QNSlimAlarmOperationCloseAll;
            log = [NSString stringWithFormat:@"%@ 【关闭所有闹钟】",log];
            break;
        case 2:
            config.alarmOperation = QNSlimAlarmOperationSetDays;
            
            // 设置闹钟生效日期
            QNSlimAlarmWeekDays weekDays = 0;
            for (NSInteger i = 0; i < self.weekButtons.count; i++) {
                UIButton *button = self.weekButtons[i];
                if (button.selected) {
                    switch (i) {
                        case 0:
                            weekDays |= QNSlimAlarmWeekDayMonday;
                            log = [NSString stringWithFormat:@"%@ 星期一",log];
                            break;
                        case 1:
                            weekDays |= QNSlimAlarmWeekDayTuesday;
                            log = [NSString stringWithFormat:@"%@ 星期二",log];
                            break;
                        case 2:
                            weekDays |= QNSlimAlarmWeekDayWednesday;
                            log = [NSString stringWithFormat:@"%@ 星期三",log];
                            break;
                        case 3:
                            weekDays |= QNSlimAlarmWeekDayThursday;
                            log = [NSString stringWithFormat:@"%@ 星期四",log];
                            break;
                        case 4:
                            weekDays |= QNSlimAlarmWeekDayFriday;
                            log = [NSString stringWithFormat:@"%@ 星期五",log];
                            break;
                        case 5:
                            weekDays |= QNSlimAlarmWeekDaySaturday;
                            log = [NSString stringWithFormat:@"%@ 星期六",log];
                            break;
                        case 6:
                            weekDays |= QNSlimAlarmWeekDaySunday;
                            log = [NSString stringWithFormat:@"%@ 星期日",log];
                            break;
                        default: break;
                    }
                }
            }
            config.alarmWeekDays = weekDays;
            
            // 设置闹钟时间
            NSInteger hour = [self.hourTextField.text integerValue];
            if (hour >= 0 && hour <= 23) {
                config.alarmHour = (int32_t)hour;
            } else {
                config.alarmHour = 8; // 默认8点
            }
            log = [NSString stringWithFormat:@"%@ 时:%d", log, config.alarmHour];
            
            NSInteger minute = [self.minuteTextField.text integerValue];
            if (minute >= 0 && minute <= 59) {
                config.alarmMinute = (int32_t)minute;
            } else {
                config.alarmMinute = 0; // 默认0分
            }
            log = [NSString stringWithFormat:@"%@ 分:%d", log, config.alarmMinute];
            
            break;
        default:
            config.alarmOperation = QNSlimAlarmOperationNoModify;
            break;
    }
    
    // 设置音量
    switch (self.volumeSegment.selectedSegmentIndex) {
        case 0:
            config.voiceVolume = QNSlimVoiceVolumeNoModify;
            log = [NSString stringWithFormat:@"%@ 音量:不设置", log];
            break;
        case 1:
            config.voiceVolume = QNSlimVoiceVolumeLevel1;
            log = [NSString stringWithFormat:@"%@ 音量:1档", log];
            break;
        case 2:
            config.voiceVolume = QNSlimVoiceVolumeLevel2;
            log = [NSString stringWithFormat:@"%@ 音量:2档", log];
            break;
        case 3:
            config.voiceVolume = QNSlimVoiceVolumeLevel3;
            log = [NSString stringWithFormat:@"%@ 音量:3档", log];
            break;
        case 4:
            config.voiceVolume = QNSlimVoiceVolumeLevel4;
            log = [NSString stringWithFormat:@"%@ 音量:4档", log];
            break;
        default:
            config.voiceVolume = QNSlimVoiceVolumeNoModify;
            break;
    }
    
    ///  闹钟提醒提示音配置 上秤测量提示音配置  测量完成提示音配置 完成目标提示音配置
    
    
    __weak typeof(self) weakSelf = self;
    [self.bleApi updateSlimDeviceConfig:config callback:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                weakSelf.resultTextView.text = [NSString stringWithFormat:@"减重秤配置更新失败: %@", error.localizedDescription];
            }
        });
    }];
}

- (void)setUserSlimConfig {
    QNSlimUserSlimConfig *config = [[QNSlimUserSlimConfig alloc] init];
    
    // 设置减重天数计算规则（默认自动递增）
    config.slimDayCountRule = QNSlimDayCountRuleAutoIncrement;
    
    // 设置减重进度天数（默认1天）
    config.slimDays = 1;
    
    // 设置体重曲线数据选择规则（默认使用最新体重）
    config.curveWeightSelection = QNSlimCurveWeightSelectionLastOfDay;
    
    // 从UI控件获取目标体重
    double targetWeight = [self.targetWeightTextField.text doubleValue];
    if (targetWeight > 0) {
        config.targetWeight = targetWeight;
    } else {
        config.targetWeight = 60.0; // 默认目标体重60kg
    }
    
    // 从UI控件获取当前体重
    double currentWeight = [self.currentWeightTextField.text doubleValue];
    if (currentWeight > 0) {
        config.initialWeight = currentWeight;
    } else {
        config.initialWeight = 70.0; // 默认初始体重70kg
    }
    
    int32_t userIndex = 1;
    
    __weak typeof(self) weakSelf = self;
    [self.bleApi updateUserSlimConfig:config userIndex:userIndex callback:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                weakSelf.resultTextView.text = [NSString stringWithFormat:@"用户减重配置更新失败: %@", error.localizedDescription];
                weakSelf.deviceStateLabel.text = [NSString stringWithFormat:@"用户减重配置更新失败: %@", error.localizedDescription];
            }
        });
    }];
}

- (void)setUserCurveData {
    QNSlimUserCurveData *curveData = [[QNSlimUserCurveData alloc] init];
    
    // 设置曲线体重数据数组（模拟14天的体重数据）
    double baseWeight = 70.0;
    NSMutableArray<NSNumber *> *weightArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 14; i++) {
        // 模拟体重逐渐下降的趋势
        double weight = baseWeight - i * 0.2 + (arc4random_uniform(100) / 100.0 - 0.5);
        [weightArray addObject:@(weight)];
    }
    curveData.curveWeightArr = weightArray;
    
    // 从UI控件获取今日标志
    curveData.todayFlag = self.todayFlagSwitch.on;
    
    // 从UI控件获取用户索引
    NSInteger userIndex = [self.curveUserIndexTextField.text integerValue];
    if (userIndex < 1 || userIndex > 8) {
        userIndex = 1;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.bleApi updateUserCurveData:curveData userIndex:(int32_t)userIndex callback:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                weakSelf.resultTextView.text = [NSString stringWithFormat:@"用户体重曲线数据更新失败: %@", error.localizedDescription];
                weakSelf.deviceStateLabel.text = [NSString stringWithFormat:@"用户体重曲线数据更新失败: %@", error.localizedDescription];
            }
        });
    }];
}

- (void)restoreSettings {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认恢复出厂设置" 
                                                                   message:@"此操作将清除设备上的所有用户数据和配置，是否继续？" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf performRestoreSettings];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)performRestoreSettings {
    __weak typeof(self) weakSelf = self;
    [self.bleApi restoreFactorySettingsCallback:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                weakSelf.resultTextView.text = [NSString stringWithFormat:@"恢复出厂设置失败: %@", error.localizedDescription];
                weakSelf.deviceStateLabel.text = [NSString stringWithFormat:@"恢复出厂设置失败: %@", error.localizedDescription];
            }
        });
    }];
}

- (void)disconnectCurrentDevice {
    if (self.connectedDevice) {
        __weak typeof(self) weakSelf = self;
        [self.bleApi disconnectDevice:self.connectedDevice callback:^(NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"断开连接失败: %@", error.localizedDescription);
                } else {
                    NSLog(@"设备已断开连接");
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UI Setup

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"连接设备";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain 
                                                                            target:self 
                                                                            action:@selector(backHandle)];
    
    // 初始化UI控件
    [self setupLabelsAndTextView];
    [self setupActionButtons];
    [self setupUserIndexButtons];
    [self setupConfigUI];
}

- (void)setupLabelsAndTextView {
    // Device Label
    self.deviceLabel = [[UILabel alloc] init];
    self.deviceLabel.numberOfLines = 0;
    self.deviceLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.deviceLabel.text = @"";
    [self.view addSubview:self.deviceLabel];
    
    // Device State Label
    self.deviceStateLabel = [[UILabel alloc] init];
    self.deviceStateLabel.numberOfLines = 0;
    self.deviceStateLabel.text = @"";
    [self.view addSubview:self.deviceStateLabel];
    
    // Result Text View
    self.resultTextView = [[UITextView alloc] init];
    self.resultTextView.backgroundColor = [UIColor lightGrayColor];
    self.resultTextView.font = [UIFont systemFontOfSize:13.0];
    self.resultTextView.layer.cornerRadius = 10;
    self.resultTextView.clipsToBounds = YES;
    self.resultTextView.textAlignment = NSTextAlignmentLeft;
    self.resultTextView.scrollEnabled = YES;
    self.resultTextView.editable = NO;
    [self.view addSubview:self.resultTextView];
    
    // Constraints
    [self.deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset([self statusBarHeight] + [self navHeight] + 15.0);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
    }];
    
    [self.deviceStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deviceLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
    }];
    
    [self.resultTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deviceStateLabel.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
        make.height.equalTo(@150);
    }];
}

- (UIButton *)setupActionButtons {
    CGFloat padding = 15.0;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat eachWidth = (screenWidth - 6 * padding) / 5.0;
    CGFloat eachHeight = 45.0;
    UIButton *lastBtn = nil;
    
    [self.btns removeAllObjects];
    for (NSInteger index = 0; index < self.btnTitles.count; index++) {
        NSString *title = self.btnTitles[index];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor systemBlueColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = index;
        [self.btns addObject:btn];
        [self.view addSubview:btn];
        
        CGFloat top = 20.0 + (index / 5) * (eachHeight + 20.0);
        CGFloat leading = (index % 5) * (eachWidth + padding) + padding;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.resultTextView.mas_bottom).offset(top);
            make.leading.equalTo(self.view).offset(leading);
            make.width.equalTo(@(eachWidth));
            make.height.equalTo(@(eachHeight));
        }];
        
        if (index == self.btnTitles.count - 1) {
            lastBtn = btn;
        }
    }
    
    return lastBtn;
}

- (UIButton *)setupUserIndexButtons {
    UIButton *lastActionBtn = [self setupActionButtons];
    
    // Mode Label
    UILabel *modeLabel = [[UILabel alloc] init];
    modeLabel.text = @"选择要删除的用户:";
    modeLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:modeLabel];
    
    [modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastActionBtn.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(20);
    }];
    
    // User Index Buttons
    NSArray *options = @[@1, @2, @3, @4, @5, @6, @7, @8];
    UIButton *lastOptionBtn = nil;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat btnWidth = (screenWidth - 200) / options.count;
    CGFloat btnHeight = 30.0;
    
    for (NSInteger index = 0; index < options.count; index++) {
        NSNumber *number = options[index];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = index;
        [btn setTitle:[number stringValue] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self imageFromColor:[UIColor lightGrayColor] size:CGSizeMake(btnWidth, btnHeight)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self imageFromColor:[UIColor blueColor] size:CGSizeMake(btnWidth, btnHeight)] forState:UIControlStateSelected];
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        [btn addTarget:self action:@selector(selectUserIndexs:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [self.userIndexBtns addObject:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(modeLabel);
            make.leading.equalTo(modeLabel.mas_trailing).offset(10 + index * btnWidth);
            make.width.equalTo(@(btnWidth));
            make.height.equalTo(@(btnHeight));
        }];
        
        if (index == options.count - 1) {
            lastOptionBtn = btn;
        }
    }
    
    return lastOptionBtn;
}

- (void)setupConfigUI {
    UIButton *lastBtn = [self setupUserIndexButtons];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.layer.cornerRadius = 10;
    [self.view addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastBtn.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    CGFloat currentY = 20;
    
    // 减重秤配置区域
    UILabel *configTitleLabel = [[UILabel alloc] init];
    configTitleLabel.text = @"减重秤配置";
    configTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    [contentView addSubview:configTitleLabel];
    
    [configTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    currentY += 40;
    
    // 闹钟操作设置
    UILabel *alarmLabel = [[UILabel alloc] init];
    alarmLabel.text = @"闹钟设置:";
    alarmLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:alarmLabel];
    
    self.alarmOperationSegment = [[UISegmentedControl alloc] initWithItems:@[@"不设置", @"关闭所有", @"设置天数"]];
    [contentView addSubview:self.alarmOperationSegment];
    
    [alarmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    
    [self.alarmOperationSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(alarmLabel.mas_trailing).offset(10);
        make.trailing.equalTo(contentView).offset(-20);
    }];
    currentY += 50;
    
    // 星期选择
    UILabel *weekLabel = [[UILabel alloc] init];
    weekLabel.text = @"生效日期:";
    weekLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:weekLabel];
    
    UIStackView *weekStackView = [[UIStackView alloc] init];
    weekStackView.axis = UILayoutConstraintAxisHorizontal;
    weekStackView.distribution = UIStackViewDistributionFillEqually;
    weekStackView.spacing = 5;
    [contentView addSubview:weekStackView];
    
    for (NSInteger index = 0; index < self.weeksTitles.count; index++) {
        NSString *title = self.weeksTitles[index];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor lightGrayColor];
        btn.layer.cornerRadius = 5;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(weekButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = index;
        [self.weekButtons addObject:btn];
        [weekStackView addArrangedSubview:btn];
    }
    
    [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    
    [weekStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(weekLabel.mas_trailing).offset(10);
        make.trailing.equalTo(contentView).offset(-20);
        make.height.equalTo(@30);
    }];
    currentY += 50;
    
    // 时间设置
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"闹钟时间:";
    timeLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:timeLabel];
    
    self.hourTextField = [[UITextField alloc] init];
    self.hourTextField.placeholder = @"小时(0-23)";
    self.hourTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.hourTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.hourTextField.text = @"8";
    [contentView addSubview:self.hourTextField];
    
    self.minuteTextField = [[UITextField alloc] init];
    self.minuteTextField.placeholder = @"分钟(0-59)";
    self.minuteTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.minuteTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.minuteTextField.text = @"0";
    [contentView addSubview:self.minuteTextField];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    
    [self.hourTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(timeLabel.mas_trailing).offset(10);
        make.width.equalTo(@80);
    }];
    
    [self.minuteTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(self.hourTextField.mas_trailing).offset(10);
        make.width.equalTo(@80);
    }];
    currentY += 50;
    
    // 音量设置
    UILabel *volumeLabel = [[UILabel alloc] init];
    volumeLabel.text = @"音量设置:";
    volumeLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:volumeLabel];
    
    self.volumeSegment = [[UISegmentedControl alloc] initWithItems:@[@"不设置", @"1档", @"2档", @"3档", @"4档"]];
    [contentView addSubview:self.volumeSegment];
    
    [volumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    
    [self.volumeSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(volumeLabel.mas_trailing).offset(10);
        make.trailing.equalTo(contentView).offset(-20);
    }];
    currentY += 70;
    
    // 用户减重配置区域
    UILabel *userConfigTitleLabel = [[UILabel alloc] init];
    userConfigTitleLabel.text = @"用户减重配置";
    userConfigTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    [contentView addSubview:userConfigTitleLabel];
    
    [userConfigTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    currentY += 40;
    
    // 用户索引
    UILabel *userIndexLabel = [[UILabel alloc] init];
    userIndexLabel.text = @"用户索引(1-8):";
    userIndexLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:userIndexLabel];
    
    self.userIndexTextField = [[UITextField alloc] init];
    self.userIndexTextField.placeholder = @"1-8";
    self.userIndexTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.userIndexTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.userIndexTextField.text = @"1";
    [contentView addSubview:self.userIndexTextField];
    
    [userIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    
    [self.userIndexTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(userIndexLabel.mas_trailing).offset(10);
        make.width.equalTo(@100);
    }];
    currentY += 50;
    
    // 目标体重
    UILabel *targetWeightLabel = [[UILabel alloc] init];
    targetWeightLabel.text = @"目标体重(kg):";
    targetWeightLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:targetWeightLabel];
    
    self.targetWeightTextField = [[UITextField alloc] init];
    self.targetWeightTextField.placeholder = @"目标体重";
    self.targetWeightTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.targetWeightTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.targetWeightTextField.text = @"60.0";
    [contentView addSubview:self.targetWeightTextField];
    
    [targetWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    
    [self.targetWeightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(targetWeightLabel.mas_trailing).offset(10);
        make.width.equalTo(@100);
    }];
    currentY += 50;
    
    // 当前体重
    UILabel *currentWeightLabel = [[UILabel alloc] init];
    currentWeightLabel.text = @"初始体重(kg):";
    currentWeightLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:currentWeightLabel];
    
    self.currentWeightTextField = [[UITextField alloc] init];
    self.currentWeightTextField.placeholder = @"初始体重";
    self.currentWeightTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.currentWeightTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.currentWeightTextField.text = @"70.0";
    [contentView addSubview:self.currentWeightTextField];
    
    [currentWeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    
    [self.currentWeightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(currentWeightLabel.mas_trailing).offset(10);
        make.width.equalTo(@100);
    }];
    currentY += 70;
    
    // 曲线数据配置区域
    UILabel *curveConfigTitleLabel = [[UILabel alloc] init];
    curveConfigTitleLabel.text = @"曲线数据配置";
    curveConfigTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    [contentView addSubview:curveConfigTitleLabel];
    
    [curveConfigTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    currentY += 40;
    
    // 曲线用户索引
    UILabel *curveUserIndexLabel = [[UILabel alloc] init];
    curveUserIndexLabel.text = @"用户索引(1-8):";
    curveUserIndexLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:curveUserIndexLabel];
    
    self.curveUserIndexTextField = [[UITextField alloc] init];
    self.curveUserIndexTextField.placeholder = @"1-8";
    self.curveUserIndexTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.curveUserIndexTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.curveUserIndexTextField.text = @"1";
    [contentView addSubview:self.curveUserIndexTextField];
    
    [curveUserIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    
    [self.curveUserIndexTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(curveUserIndexLabel.mas_trailing).offset(10);
        make.width.equalTo(@100);
    }];
    currentY += 50;
    
    // 最后一条数据为今日数据标志
    UILabel *todayFlagLabel = [[UILabel alloc] init];
    todayFlagLabel.text = @"最后一条数据为今日数据标志:";
    todayFlagLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:todayFlagLabel];
    
    self.todayFlagSwitch = [[UISwitch alloc] init];
    self.todayFlagSwitch.on = YES;
    [contentView addSubview:self.todayFlagSwitch];
    
    [todayFlagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    
    [self.todayFlagSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(todayFlagLabel);
        make.leading.equalTo(todayFlagLabel.mas_trailing).offset(10);
    }];
    currentY += 50;
    
    // 设置内容视图高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(currentY));
    }];
}

#pragma mark - Helper Methods

- (CGFloat)statusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

- (CGFloat)navHeight {
    return self.navigationController.navigationBar.frame.size.height;
}

- (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image ?: [[UIImage alloc] init];
}

@end
