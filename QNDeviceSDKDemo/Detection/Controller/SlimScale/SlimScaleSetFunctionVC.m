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

// 添加访问或注册用户的UI控件
// 包含用户坑位 （1 - 8）  生日  身高  性别 是否是运动员  密钥
@property (nonatomic, strong) UISegmentedControl *userIndexSegment;  // 用户坑位选择 (1-8)
@property (nonatomic, strong) UIDatePicker *birthdayPicker;          // 生日选择器
@property (nonatomic, strong) UITextField *heightTextField;          // 身高输入框
@property (nonatomic, strong) UISegmentedControl *genderSegment;     // 性别选择 (男/女)
@property (nonatomic, strong) UISwitch *athleteSwitch;               // 是否是运动员开关
// 密钥（默认1000） , 新增密钥的输入（ 访问用户时需要输入密钥 ）
@property (nonatomic, strong) UITextField *secretTextField;          // 密钥输入框

/********** 减重秤配置相关控件 ******/
@property (nonatomic, strong) UISegmentedControl *alarmOperationSegment;
@property (nonatomic, strong) NSArray<NSString *> *weeksTitles;
@property (nonatomic, strong) NSMutableArray<UIButton *> *weekButtons;
@property (nonatomic, strong) UITextField *hourTextField;
@property (nonatomic, strong) UITextField *minuteTextField;
@property (nonatomic, strong) UISegmentedControl *volumeSegment;
// 提示音配置相关控件
// 闹钟提醒提示音配置
@property (nonatomic, strong) UISegmentedControl *alarmSoundSourceSegment;
@property (nonatomic, strong) UISegmentedControl *alarmSoundOperationSegment;
// 上秤测量提示音配置
@property (nonatomic, strong) UISegmentedControl *measureSoundSourceSegment;
@property (nonatomic, strong) UISegmentedControl *measureSoundOperationSegment;
// 测量完成提示音配置
@property (nonatomic, strong) UISegmentedControl *completeSoundSourceSegment;
@property (nonatomic, strong) UISegmentedControl *completeSoundOperationSegment;
// 完成目标提示音配置
@property (nonatomic, strong) UISegmentedControl *goalSoundSourceSegment;
@property (nonatomic, strong) UISegmentedControl *goalSoundOperationSegment;

/********** 用户减重配置相关控件 ******/
@property (nonatomic, strong) UITextField *userIndexTextField;
@property (nonatomic, strong) UITextField *targetWeightTextField;
@property (nonatomic, strong) UITextField *currentWeightTextField;


/********** 曲线数据相关控件 ******/
@property (nonatomic, strong) UITextField *curveUserIndexTextField;
@property (nonatomic, strong) UISwitch *todayFlagSwitch;
@property (nonatomic, strong) NSMutableArray<UITextField *> *weightCurveTextFields; // 14个体重曲线输入框
@property (nonatomic, strong) UIButton *generateWeightCurveButton;                  // 一键生成按钮

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

- (NSMutableArray<UITextField *> *)weightCurveTextFields {
    if (!_weightCurveTextFields) {
        _weightCurveTextFields = [NSMutableArray array];
    }
    return _weightCurveTextFields;
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

- (void)userIndexChanged:(UISegmentedControl *)sender {
    // 当用户坑位改变时，自动更新密钥的默认值
    NSInteger userIndex = sender.selectedSegmentIndex + 1; // 坑位从1开始
    NSInteger defaultSecret = 1000 + userIndex;
    self.secretTextField.text = [NSString stringWithFormat:@"%ld", (long)defaultSecret];
}

- (void)generateWeightCurveButtonTapped:(UIButton *)sender {
    // 获取第一个输入框的值作为基准
    if (self.weightCurveTextFields.count == 0) return;
    
    UITextField *firstTextField = self.weightCurveTextFields[0];
    double baseWeight = [firstTextField.text doubleValue];
    
    // 如果第一个输入框为空或值为0，使用默认值60.0
    if (baseWeight <= 0) {
        baseWeight = 60.0;
        firstTextField.text = @"60.0";
    }
    
    // 为后续13个输入框生成递增的体重值（每次+0.1kg）
    for (NSInteger i = 1; i < self.weightCurveTextFields.count; i++) {
        double weight = baseWeight + (i * 0.1);
        UITextField *textField = self.weightCurveTextFields[i];
        textField.text = [NSString stringWithFormat:@"%.1f", weight];
    }
}

#pragma mark - Business Logic

- (void)registerUser {
    // 验证用户输入
    if (![self validateUserInput]) {
        return;
    }
    
    QNUser *user = [[QNUser alloc] init];
    
    // 从UI控件获取运动员类型
    user.athleteType = self.athleteSwitch.on ? YLAthleteSport : YLAthleteDefault;
    
    // 从UI控件获取性别 (0=女, 1=男)
    user.gender = self.genderSegment.selectedSegmentIndex == 0 ? @"female" : @"male";
    
    // 从UI控件获取身高
    int height = [self.heightTextField.text intValue];
    user.height = height > 0 ? height : 170; // 默认170cm
    
    // 从UI控件获取生日
    user.birthday = self.birthdayPicker.date;
    
    // 用户坑位从UI控件获取 (1-8)
    user.index = (int)self.userIndexSegment.selectedSegmentIndex + 1;
    
    // 从UI控件获取密钥
    int secret = [self.secretTextField.text intValue];
    user.secret = secret > 0 ? secret : 1000; // 默认1000
    
    __weak typeof(self) weakSelf = self;
    [self.bleApi switchUserScaleUser:user callback:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                weakSelf.resultTextView.text = [NSString stringWithFormat:@"注册用户失败: %@", error.localizedDescription];
            } else {
                weakSelf.resultTextView.text = [NSString stringWithFormat:@"注册用户成功 - 坑位:%d 性别:%@ 身高:%dcm 运动员:%@ 密钥:%d",
                                              user.index, user.gender, user.height, user.athleteType == YLAthleteSport ? @"是" : @"否", user.secret];
            }
        });
    }];
}

- (void)vistorUser {
    // 验证用户输入
    if (![self validateUserInput]) {
        return;
    }
    
    QNUser *user = [[QNUser alloc] init];
    
    // 从UI控件获取运动员类型
    user.athleteType = self.athleteSwitch.on ? YLAthleteSport : YLAthleteDefault;
    
    // 从UI控件获取性别 (0=女, 1=男)
    user.gender = self.genderSegment.selectedSegmentIndex == 0 ? @"female" : @"male";
    
    // 从UI控件获取身高
    int height = [self.heightTextField.text intValue];
    user.height = height > 0 ? height : 170; // 默认170cm
    
    // 从UI控件获取生日
    user.birthday = self.birthdayPicker.date;
    
    // 用户坑位从UI控件获取 (1-8)
    user.index = (int)self.userIndexSegment.selectedSegmentIndex + 1;
    
    // 从UI控件获取密钥 (访问用户时需要输入正确的密钥)
    int secret = [self.secretTextField.text intValue];
    user.secret = secret > 0 ? secret : 1000; // 默认1000
    
    __weak typeof(self) weakSelf = self;
    [self.bleApi switchUserScaleUser:user callback:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                weakSelf.resultTextView.text = [NSString stringWithFormat:@"访问用户失败: %@", error.localizedDescription];
            } else {
                weakSelf.resultTextView.text = [NSString stringWithFormat:@"访问用户成功 - 坑位:%d 性别:%@ 身高:%dcm 运动员:%@ 密钥:%d", 
                                                user.index, user.gender, user.height, user.athleteType == YLAthleteSport ? @"是" : @"否", user.secret];
            }
        });
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
    
    // 设置闹钟提醒提示音配置
    if (self.alarmSoundSourceSegment && self.alarmSoundOperationSegment) {
        QNSlimVoiceConfig *alarmVoice = [[QNSlimVoiceConfig alloc] init];
        alarmVoice.voiceSource = (QNSlimVoiceSource)self.alarmSoundSourceSegment.selectedSegmentIndex; // 0=不修改, 1-8=音源1-8
        alarmVoice.voiceOperation = (QNSlimVoiceOperation)self.alarmSoundOperationSegment.selectedSegmentIndex; // 0=不修改, 1=关闭, 2=打开
        config.alarmVoice = alarmVoice;
        
        NSString *sourceText = alarmVoice.voiceSource == QNSlimVoiceSourceNoModify ? @"不修改" : [NSString stringWithFormat:@"音源%ld", (long)alarmVoice.voiceSource];
        NSString *operationText = @"";
        switch (alarmVoice.voiceOperation) {
            case QNSlimVoiceOperationNoModify: operationText = @"不修改"; break;
            case QNSlimVoiceOperationClose: operationText = @"关闭"; break;
            case QNSlimVoiceOperationOpen: operationText = @"打开"; break;
        }
        log = [NSString stringWithFormat:@"%@ 闹钟提示音源:%@ 操作:%@", log, sourceText, operationText];
    }
    
    // 设置上秤测量提示音配置
    if (self.measureSoundSourceSegment && self.measureSoundOperationSegment) {
        QNSlimVoiceConfig *measureVoice = [[QNSlimVoiceConfig alloc] init];
        measureVoice.voiceSource = (QNSlimVoiceSource)self.measureSoundSourceSegment.selectedSegmentIndex;
        measureVoice.voiceOperation = (QNSlimVoiceOperation)self.measureSoundOperationSegment.selectedSegmentIndex;
        config.measureStartVoice = measureVoice;
        
        NSString *sourceText = measureVoice.voiceSource == QNSlimVoiceSourceNoModify ? @"不修改" : [NSString stringWithFormat:@"音源%ld", (long)measureVoice.voiceSource];
        NSString *operationText = @"";
        switch (measureVoice.voiceOperation) {
            case QNSlimVoiceOperationNoModify: operationText = @"不修改"; break;
            case QNSlimVoiceOperationClose: operationText = @"关闭"; break;
            case QNSlimVoiceOperationOpen: operationText = @"打开"; break;
        }
        log = [NSString stringWithFormat:@"%@ 测量提示音源:%@ 操作:%@", log, sourceText, operationText];
    }
    
    // 设置测量完成提示音配置
    if (self.completeSoundSourceSegment && self.completeSoundOperationSegment) {
        QNSlimVoiceConfig *completeVoice = [[QNSlimVoiceConfig alloc] init];
        completeVoice.voiceSource = (QNSlimVoiceSource)self.completeSoundSourceSegment.selectedSegmentIndex;
        completeVoice.voiceOperation = (QNSlimVoiceOperation)self.completeSoundOperationSegment.selectedSegmentIndex;
        config.measureFinishVoice = completeVoice;
        
        NSString *sourceText = completeVoice.voiceSource == QNSlimVoiceSourceNoModify ? @"不修改" : [NSString stringWithFormat:@"音源%ld", (long)completeVoice.voiceSource];
        NSString *operationText = @"";
        switch (completeVoice.voiceOperation) {
            case QNSlimVoiceOperationNoModify: operationText = @"不修改"; break;
            case QNSlimVoiceOperationClose: operationText = @"关闭"; break;
            case QNSlimVoiceOperationOpen: operationText = @"打开"; break;
        }
        log = [NSString stringWithFormat:@"%@ 完成提示音源:%@ 操作:%@", log, sourceText, operationText];
    }
    
    // 设置完成目标提示音配置
    if (self.goalSoundSourceSegment && self.goalSoundOperationSegment) {
        QNSlimVoiceConfig *goalVoice = [[QNSlimVoiceConfig alloc] init];
        goalVoice.voiceSource = (QNSlimVoiceSource)self.goalSoundSourceSegment.selectedSegmentIndex;
        goalVoice.voiceOperation = (QNSlimVoiceOperation)self.goalSoundOperationSegment.selectedSegmentIndex;
        config.completeGoalVoice = goalVoice;
        
        NSString *sourceText = goalVoice.voiceSource == QNSlimVoiceSourceNoModify ? @"不修改" : [NSString stringWithFormat:@"音源%ld", (long)goalVoice.voiceSource];
        NSString *operationText = @"";
        switch (goalVoice.voiceOperation) {
            case QNSlimVoiceOperationNoModify: operationText = @"不修改"; break;
            case QNSlimVoiceOperationClose: operationText = @"关闭"; break;
            case QNSlimVoiceOperationOpen: operationText = @"打开"; break;
        }
        log = [NSString stringWithFormat:@"%@ 目标提示音源:%@ 操作:%@", log, sourceText, operationText];
    }
    
    NSLog(@"%@",log);
    
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
    
    // 从14个输入框获取体重数据
    NSMutableArray<NSNumber *> *weightArray = [NSMutableArray array];
    
    // 验证输入框数量
    if (self.weightCurveTextFields.count != 14) {
        [self showAlert:@"错误" message:@"体重曲线输入框数量不正确"];
        return;
    }
    
    // 从输入框获取体重数据
    for (NSInteger i = 0; i < self.weightCurveTextFields.count; i++) {
        UITextField *textField = self.weightCurveTextFields[i];
        double weight = [textField.text doubleValue];
        
        // 验证体重数据有效性
        if (weight <= 0 || weight > 300) {
            [self showAlert:@"输入错误" message:[NSString stringWithFormat:@"第%ld天的体重数据无效，请输入0-300kg之间的数值", (long)(i + 1)]];
            return;
        }
        
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
            } else {
                // 显示成功信息和体重数据范围
                double minWeight = [weightArray.firstObject doubleValue];
                double maxWeight = [weightArray.lastObject doubleValue];
                weakSelf.resultTextView.text = [NSString stringWithFormat:@"用户%ld体重曲线数据更新成功 - 14天数据范围: %.1f-%.1fkg", 
                                              (long)userIndex, minWeight, maxWeight];
                weakSelf.deviceStateLabel.text = @"体重曲线数据更新成功";
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
    
    // 用户注册/访问配置区域
    UILabel *userRegisterTitleLabel = [[UILabel alloc] init];
    userRegisterTitleLabel.text = @"用户注册/访问配置";
    userRegisterTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    [contentView addSubview:userRegisterTitleLabel];
    
    [userRegisterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    currentY += 40;
    
    // 用户坑位选择 (1-8)
    UILabel *userIndexLabel = [[UILabel alloc] init];
    userIndexLabel.text = @"用户坑位:";
    userIndexLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:userIndexLabel];
    
    self.userIndexSegment = [[UISegmentedControl alloc] initWithItems:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"]];
    self.userIndexSegment.selectedSegmentIndex = 0; // 默认选择坑位1
    [self.userIndexSegment addTarget:self action:@selector(userIndexChanged:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:self.userIndexSegment];
    
    [userIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
        make.width.equalTo(@80);
    }];
    
    [self.userIndexSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(userIndexLabel.mas_trailing).offset(10);
        make.trailing.equalTo(contentView).offset(-20);
    }];
    currentY += 50;
    
    // 身高输入
    UILabel *heightLabel = [[UILabel alloc] init];
    heightLabel.text = @"身高(cm):";
    heightLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:heightLabel];
    
    self.heightTextField = [[UITextField alloc] init];
    self.heightTextField.placeholder = @"请输入身高(如:170)";
    self.heightTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.heightTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.heightTextField.text = @"170";
    [contentView addSubview:self.heightTextField];
    
    [heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
        make.width.equalTo(@80);
    }];
    
    [self.heightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(heightLabel.mas_trailing).offset(10);
        make.width.equalTo(@150);
    }];
    currentY += 50;
    
    // 性别选择
    UILabel *genderLabel = [[UILabel alloc] init];
    genderLabel.text = @"性别:";
    genderLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:genderLabel];
    
    self.genderSegment = [[UISegmentedControl alloc] initWithItems:@[@"女", @"男"]];
    self.genderSegment.selectedSegmentIndex = 1; // 默认选择男
    [contentView addSubview:self.genderSegment];
    
    [genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
        make.width.equalTo(@80);
    }];
    
    [self.genderSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(genderLabel.mas_trailing).offset(10);
        make.width.equalTo(@150);
    }];
    currentY += 50;
    
    // 生日选择
    UILabel *birthdayLabel = [[UILabel alloc] init];
    birthdayLabel.text = @"生日:";
    birthdayLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:birthdayLabel];
    
    self.birthdayPicker = [[UIDatePicker alloc] init];
    self.birthdayPicker.datePickerMode = UIDatePickerModeDate;
    self.birthdayPicker.preferredDatePickerStyle = UIDatePickerStyleCompact;
    // 设置默认日期为1990年1月1日
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = 1995;
    components.month = 1;
    components.day = 1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *defaultDate = [calendar dateFromComponents:components];
    self.birthdayPicker.date = defaultDate;
    [contentView addSubview:self.birthdayPicker];
    
    [birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
        make.width.equalTo(@80);
    }];
    
    [self.birthdayPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(birthdayLabel.mas_trailing).offset(10);
        make.width.equalTo(@200);
    }];
    currentY += 50;
    
    
    // 是否是运动员
    UILabel *athleteLabel = [[UILabel alloc] init];
    athleteLabel.text = @"是否是运动员:";
    athleteLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:athleteLabel];
    
    self.athleteSwitch = [[UISwitch alloc] init];
    self.athleteSwitch.on = NO; // 默认不是运动员
    [contentView addSubview:self.athleteSwitch];
    
    [athleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
        make.width.equalTo(@120);
    }];
    
    [self.athleteSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(athleteLabel);
        make.leading.equalTo(athleteLabel.mas_trailing).offset(10);
    }];
    currentY += 50;
    
    // 密钥输入
    UILabel *secretLabel = [[UILabel alloc] init];
    secretLabel.text = @"密钥:";
    secretLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:secretLabel];
    
    self.secretTextField = [[UITextField alloc] init];
    self.secretTextField.placeholder = @"访问用户需要正确密钥";
    self.secretTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.secretTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.secretTextField.text = @"1000"; // 默认密钥1000
    [contentView addSubview:self.secretTextField];
    
    [secretLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
        make.width.equalTo(@80);
    }];
    
    [self.secretTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(secretLabel.mas_trailing).offset(10);
        make.width.equalTo(@150);
    }];
    currentY += 70;
    
    
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
    
    self.alarmOperationSegment = [[UISegmentedControl alloc] initWithItems:@[@"不设置", @"关闭所有闹钟", @"打开并设置闹钟"]];
    self.alarmOperationSegment.selectedSegmentIndex = 2;
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
    weekLabel.text = @"生效星期:";
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
        if(index == 0) {
            [self weekButtonTapped:btn];
        }
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
    self.volumeSegment.selectedSegmentIndex = 4;
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
    currentY += 50;
    
    // 提示音配置区域
    UILabel *soundConfigTitleLabel = [[UILabel alloc] init];
    soundConfigTitleLabel.text = @"提示音配置";
    soundConfigTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    [contentView addSubview:soundConfigTitleLabel];
    
    [soundConfigTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    currentY += 40;
    
    // 闹钟提醒提示音配置
    UILabel *alarmSoundLabel = [[UILabel alloc] init];
    alarmSoundLabel.text = @"闹钟提醒提示音:";
    alarmSoundLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:alarmSoundLabel];
    
    [alarmSoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
        make.width.equalTo(@120);
    }];
    currentY += 30;
    
    // 音源选择
    UILabel *alarmSourceLabel = [[UILabel alloc] init];
    alarmSourceLabel.text = @"音源:";
    alarmSourceLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:alarmSourceLabel];
    
    self.alarmSoundSourceSegment = [[UISegmentedControl alloc] initWithItems:@[@"不修改", @"音源1", @"音源2", @"音源3", @"音源4", @"音源5", @"音源6", @"音源7", @"音源8"]];
    self.alarmSoundSourceSegment.selectedSegmentIndex = 1;
    [contentView addSubview:self.alarmSoundSourceSegment];
    
    [alarmSourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(40);
        make.width.equalTo(@40);
    }];
    
    [self.alarmSoundSourceSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(alarmSourceLabel.mas_trailing).offset(10);
        make.trailing.equalTo(contentView).offset(-20);
    }];
    currentY += 40;
    
    // 操作选择
    UILabel *alarmOperationLabel = [[UILabel alloc] init];
    alarmOperationLabel.text = @"操作:";
    alarmOperationLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:alarmOperationLabel];
    
    self.alarmSoundOperationSegment = [[UISegmentedControl alloc] initWithItems:@[@"不修改", @"关闭", @"打开"]];
    self.alarmSoundOperationSegment.selectedSegmentIndex = 2;
    [contentView addSubview:self.alarmSoundOperationSegment];
    
    [alarmOperationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(40);
        make.width.equalTo(@40);
    }];
    
    [self.alarmSoundOperationSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(alarmOperationLabel.mas_trailing).offset(10);
        make.width.equalTo(@200);
    }];
    currentY += 50;
    
    // 上秤测量提示音配置
    UILabel *measureSoundLabel = [[UILabel alloc] init];
    measureSoundLabel.text = @"上秤测量提示音:";
    measureSoundLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:measureSoundLabel];
    
    [measureSoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
        make.width.equalTo(@120);
    }];
    currentY += 30;
    
    // 音源选择
    UILabel *measureSourceLabel = [[UILabel alloc] init];
    measureSourceLabel.text = @"音源:";
    measureSourceLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:measureSourceLabel];
    
    self.measureSoundSourceSegment = [[UISegmentedControl alloc] initWithItems:@[@"不修改", @"音源1", @"音源2", @"音源3", @"音源4", @"音源5", @"音源6", @"音源7", @"音源8"]];
    self.measureSoundSourceSegment.selectedSegmentIndex = 2;
    [contentView addSubview:self.measureSoundSourceSegment];
    
    [measureSourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(40);
        make.width.equalTo(@40);
    }];
    
    [self.measureSoundSourceSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(measureSourceLabel.mas_trailing).offset(10);
        make.trailing.equalTo(contentView).offset(-20);
    }];
    currentY += 40;
    
    // 操作选择
    UILabel *measureOperationLabel = [[UILabel alloc] init];
    measureOperationLabel.text = @"操作:";
    measureOperationLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:measureOperationLabel];
    
    self.measureSoundOperationSegment = [[UISegmentedControl alloc] initWithItems:@[@"不修改", @"关闭", @"打开"]];
    self.measureSoundOperationSegment.selectedSegmentIndex = 2;
    [contentView addSubview:self.measureSoundOperationSegment];
    
    [measureOperationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(40);
        make.width.equalTo(@40);
    }];
    
    [self.measureSoundOperationSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(measureOperationLabel.mas_trailing).offset(10);
        make.width.equalTo(@200);
    }];
    currentY += 50;
    
    // 测量完成提示音配置
    UILabel *completeSoundLabel = [[UILabel alloc] init];
    completeSoundLabel.text = @"测量完成提示音:";
    completeSoundLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:completeSoundLabel];
    
    [completeSoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
        make.width.equalTo(@120);
    }];
    currentY += 30;
    
    // 音源选择
    UILabel *completeSourceLabel = [[UILabel alloc] init];
    completeSourceLabel.text = @"音源:";
    completeSourceLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:completeSourceLabel];
    
    self.completeSoundSourceSegment = [[UISegmentedControl alloc] initWithItems:@[@"不修改", @"音源1", @"音源2", @"音源3", @"音源4", @"音源5", @"音源6", @"音源7", @"音源8"]];
    self.completeSoundSourceSegment.selectedSegmentIndex = 3;
    [contentView addSubview:self.completeSoundSourceSegment];
    
    [completeSourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(40);
        make.width.equalTo(@40);
    }];
    
    [self.completeSoundSourceSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(completeSourceLabel.mas_trailing).offset(10);
        make.trailing.equalTo(contentView).offset(-20);
    }];
    currentY += 40;
    
    // 操作选择
    UILabel *completeOperationLabel = [[UILabel alloc] init];
    completeOperationLabel.text = @"操作:";
    completeOperationLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:completeOperationLabel];
    
    self.completeSoundOperationSegment = [[UISegmentedControl alloc] initWithItems:@[@"不修改", @"关闭", @"打开"]];
    self.completeSoundOperationSegment.selectedSegmentIndex = 2;
    [contentView addSubview:self.completeSoundOperationSegment];
    
    [completeOperationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(40);
        make.width.equalTo(@40);
    }];
    
    [self.completeSoundOperationSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(completeOperationLabel.mas_trailing).offset(10);
        make.width.equalTo(@200);
    }];
    currentY += 50;
    
    // 完成目标提示音配置
    UILabel *goalSoundLabel = [[UILabel alloc] init];
    goalSoundLabel.text = @"完成目标提示音:";
    goalSoundLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:goalSoundLabel];
    
    [goalSoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
        make.width.equalTo(@120);
    }];
    currentY += 30;
    
    // 音源选择
    UILabel *goalSourceLabel = [[UILabel alloc] init];
    goalSourceLabel.text = @"音源:";
    goalSourceLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:goalSourceLabel];
    
    self.goalSoundSourceSegment = [[UISegmentedControl alloc] initWithItems:@[@"不修改", @"音源1", @"音源2", @"音源3", @"音源4", @"音源5", @"音源6", @"音源7", @"音源8"]];
    self.goalSoundSourceSegment.selectedSegmentIndex = 3;
    [contentView addSubview:self.goalSoundSourceSegment];
    
    [goalSourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(40);
        make.width.equalTo(@40);
    }];
    
    [self.goalSoundSourceSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(goalSourceLabel.mas_trailing).offset(10);
        make.trailing.equalTo(contentView).offset(-20);
    }];
    currentY += 40;
    
    // 操作选择
    UILabel *goalOperationLabel = [[UILabel alloc] init];
    goalOperationLabel.text = @"操作:";
    goalOperationLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:goalOperationLabel];
    
    self.goalSoundOperationSegment = [[UISegmentedControl alloc] initWithItems:@[@"不修改", @"关闭", @"打开"]];
    self.goalSoundOperationSegment.selectedSegmentIndex = 2;
    [contentView addSubview:self.goalSoundOperationSegment];
    
    [goalOperationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(40);
        make.width.equalTo(@40);
    }];
    
    [self.goalSoundOperationSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(goalOperationLabel.mas_trailing).offset(10);
        make.width.equalTo(@200);
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
    UILabel *visitUserIndexLabel = [[UILabel alloc] init];
    visitUserIndexLabel.text = @"用户索引(1-8):";
    visitUserIndexLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:visitUserIndexLabel];
    
    self.userIndexTextField = [[UITextField alloc] init];
    self.userIndexTextField.placeholder = @"1-8";
    self.userIndexTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.userIndexTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.userIndexTextField.text = @"1";
    [contentView addSubview:self.userIndexTextField];
    
    [visitUserIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    
    [self.userIndexTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(visitUserIndexLabel.mas_trailing).offset(10);
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
    self.targetWeightTextField.text = @"65.0";
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
    
    // 14个体重曲线输入框
    UILabel *weightCurveLabel = [[UILabel alloc] init];
    weightCurveLabel.text = @"体重曲线数据(14天):";
    weightCurveLabel.font = [UIFont boldSystemFontOfSize:14];
    [contentView addSubview:weightCurveLabel];
    
    [weightCurveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
    }];
    currentY += 30;
    
    // 一键生成按钮
    self.generateWeightCurveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.generateWeightCurveButton setTitle:@"一键生成" forState:UIControlStateNormal];
    self.generateWeightCurveButton.backgroundColor = [UIColor systemBlueColor];
    [self.generateWeightCurveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.generateWeightCurveButton.layer.cornerRadius = 5;
    self.generateWeightCurveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.generateWeightCurveButton addTarget:self action:@selector(generateWeightCurveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.generateWeightCurveButton];
    
    [self.generateWeightCurveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(currentY);
        make.leading.equalTo(contentView).offset(20);
        make.width.equalTo(@100);
        make.height.equalTo(@35);
    }];
    currentY += 50;
    
    // 创建14个体重输入框，分两行排布
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat textFieldWidth = (screenWidth - 60) / 7; // 每行7个，减去边距
    CGFloat textFieldHeight = 35;
    
    [self.weightCurveTextFields removeAllObjects];
    
    for (NSInteger i = 0; i < 14; i++) {
        UITextField *textField = [[UITextField alloc] init];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.font = [UIFont systemFontOfSize:12];
        textField.textAlignment = NSTextAlignmentCenter;
        
        // 第一个输入框默认值为60.0
        if (i == 0) {
            textField.text = @"60.0";
        }
        
        textField.placeholder = [NSString stringWithFormat:@"第%ld天", (long)(i + 1)];
        [contentView addSubview:textField];
        [self.weightCurveTextFields addObject:textField];
        
        // 计算位置：前7个为第一行，后7个为第二行
        NSInteger row = i / 7;
        NSInteger col = i % 7;
        CGFloat x = 20 + col * textFieldWidth;
        CGFloat y = currentY + row * (textFieldHeight + 10);
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(y);
            make.leading.equalTo(contentView).offset(x);
            make.width.equalTo(@(textFieldWidth - 5)); // 减去间距
            make.height.equalTo(@(textFieldHeight));
        }];
    }
    
    currentY += (textFieldHeight + 10) * 2 + 20; // 两行的高度加上间距
    
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

- (BOOL)validateUserInput {
    // 验证身高输入
    int height = [self.heightTextField.text intValue];
    if (height <= 0 || height > 300) {
        [self showAlert:@"输入错误" message:@"请输入有效的身高(1-300cm)"];
        return NO;
    }
    
    // 验证密钥输入
    int secret = [self.secretTextField.text intValue];
    if (secret <= 0 || secret > 9999) {
        [self showAlert:@"输入错误" message:@"请输入有效的密钥(大于0或者是小于等于9999的整数)"];
        return NO;
    }
    
    return YES;
}

- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
 
