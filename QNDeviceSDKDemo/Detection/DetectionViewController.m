//
//  DetectionViewController.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/16.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

typedef enum{
    DeviceStyleNormal = 0,  //默认状态
    DeviceStyleScanning = 1,//正在扫描
    DeviceStyleLinging = 2,   //正在连接
    DeviceStyleLingSucceed = 3, //连接成功
    DeviceStyleMeasuringWeight = 4,//测量体重
    DeviceStyleMeasuringResistance = 5,//测量阻抗
    DeviceStyleMeasuringHeartRate = 6, //测量心率
    DeviceStyleMeasuringSucceed = 7,     //测量完成
    DeviceStyleMeasuringFail = 8,     //测量完成
    DeviceStyleDisconnect = 9,         //断开连接/称关机
    DeviceStyleWifiBleStartNetwork = 10,         //开始配网
    DeviceStyleWifiBleNetworkSuccess = 11,         //配网成功
    DeviceStyleWifiBleNetworkFail = 12,         //配网失败
}DeviceStyle;

#import "AppDelegate.h"
#import "DetectionViewController.h"
#import "EightElectrodesReportVC.h"
#import "DeviceTableViewCell.h"
#import "ScaleDataCell.h"
#import "WiFiTool.h"
#import "NSTimer+YYAdd.h"
#import <CoreLocation/CoreLocation.h>
#import "WspConfigVC.h"
#import "UIView+Toast.h"
#import "HeightStorageDataVC.h"
#import "HeightSetFunctionVC.h"
#import "NSDate+ChangeExtension.h"
#import "Masonry.h"
#import "SlimScaleSetFunctionVC.h"

@interface DetectionViewController ()<UITableViewDelegate,UITableViewDataSource,QNBleConnectionChangeListener,QNUserScaleDataListener,QNBleDeviceDiscoveryListener,QNBleStateListener,WspConfigVCDelegate,QNBleKitchenListener,QNScaleDataListener>
@property (weak, nonatomic) IBOutlet UILabel *appIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *unstableWeightLabel;  //时时体重
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *peelBtn; //去皮按键

@property (nonatomic, strong) UIButton *setHeightScaleBtn;

@property (nonatomic, assign) DeviceStyle currentStyle;
@property (nonatomic, strong) NSMutableDictionary *scanDveices;
@property (nonatomic, strong) NSMutableArray *scaleDataAry; //收到测量完成后数组
@property(nonatomic, strong) QNBleBroadcastDevice *connectBroadcastDevice; //当前连接的设备
@property(nonatomic, assign) int broadcastMesasureCompleteCount;
@property(nonatomic, strong) NSTimer *broadcastTimer;
@property (nonatomic, strong) QNBleApi *bleApi;

@property(nonatomic, strong) CLLocationManager *locationManager;

@property(nonatomic, weak) WspConfigVC *wspConfigVC;
@property(nonatomic, assign) BOOL isEightElectrodesData; //八电极测量数据标识

@property (nonatomic, strong, nullable) QNBleDevice *connectedBleDevice;

/// 当前测量数据
@property (nonatomic, strong) QNScaleData *scaleData;

@end

@implementation DetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测量";
    UIBarButtonItem *buttonItem1 = [[UIBarButtonItem alloc] initWithTitle:@"更新用户" style:UIBarButtonItemStylePlain target:self action:@selector(switchUserAction)];
    self.navigationItem.rightBarButtonItems = @[buttonItem1];
    self.appIdLabel.text = kAppid;
    self.peelBtn.hidden = YES;
    self.unstableWeightLabel.numberOfLines = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.currentStyle = DeviceStyleNormal;
    self.bleApi = [QNBleApi sharedBleApi];
    self.bleApi.discoveryListener = self;
    self.bleApi.connectionChangeListener = self;
    self.bleApi.dataListener = self;
    self.bleApi.bleStateListener = self;
    self.bleApi.bleKitchenListener = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.locationManager = [[CLLocationManager alloc] init];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    } else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请授权定位权限以便使用WIFI配网功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    
    [self.peelBtn addTarget:self action:@selector(clickPeelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bleApi.dataListener = self;
    self.bleApi.connectionChangeListener = self;
}

- (void)createUI {
    self.setHeightScaleBtn = [[UIButton alloc]init];
    [self.setHeightScaleBtn setTitle:@"测试功能" forState:UIControlStateNormal];
    [self.setHeightScaleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.setHeightScaleBtn addTarget:self action:@selector(clickSetHeightScaleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.setHeightScaleBtn sizeToFit];
    self.setHeightScaleBtn.hidden = YES;
    [self.view addSubview:self.setHeightScaleBtn];
    
    [self.setHeightScaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.appIdLabel);
        make.trailing.mas_equalTo(-5.0);
    }];
}


- (void)back {
    [self.bleApi disconnectDevice:nil callback:^(NSError *error) {
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickPeelBtn {
    QNBleKitchenConfig *config = [[QNBleKitchenConfig alloc] init];
    config.unit = QNUnitOZ;
    config.isPeel = YES;
    [self.bleApi setBleKitchenDeviceConfig:config];
}

- (void)clickSetHeightScaleAction {
    if (self.connectedBleDevice.deviceType == QNDeviceTypeHeightScale) {
        HeightSetFunctionVC *vc = [[HeightSetFunctionVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (self.connectedBleDevice.deviceType == QNDeviceTypeSlimScale) {
        SlimScaleSetFunctionVC *vc = [[SlimScaleSetFunctionVC alloc]init];
        vc.connectedDevice = self.connectedBleDevice;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 更新用户
- (void)switchUserAction {
    if (!self.connectedBleDevice) {
        [self.view makeToast:@"设备未连接，请先连接设备！" duration:2.5f position:CSToastPositionCenter];
        return;
    }
    QNUser *user = [[QNUser alloc]init];
    user.gender = @"female";
    user.birthday = [NSDate dateWithString:@"1995-01-01" format:@"yyyy-MM-dd"];
    NSString *userInfo = [NSString stringWithFormat:@"当前用户生日: %@ 性别: %@",[user.birthday convertStringWithFormatter:QNDateFormatter10], user.gender];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"更新用户信息"
                                                                     message:userInfo
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.bleApi switchHeightScaleUser:user callback:^(NSError *error) {
            if (error) {
                [self.view makeToast:error.localizedDescription duration:2.0f position:CSToastPositionCenter];
            }else{
                [self.view makeToast:@"设置成功" duration:2.0f position:CSToastPositionCenter];
            }
        }];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark 设置设备各个阶段状态
- (void)setCurrentStyle:(DeviceStyle)currentStyle {
    _currentStyle = currentStyle;
    switch (_currentStyle) {
        case DeviceStyleScanning: //正在扫描
            [self setScanningStyleUI];
            if (self.connectedBleDevice) {
                [self disconnectDevice];
            }
            [self startScanDevice];
            break;
        case DeviceStyleLinging: //正在连接
            [self setLingingStyleUI];
            break;
        case DeviceStyleLingSucceed: //连接成功
            [self setLingSucceedStyleUI];
            break;
        case DeviceStyleWifiBleStartNetwork: //开始配网
            [self setStartNetworkStyleUI];
            break;
        case DeviceStyleWifiBleNetworkSuccess: //配网成功
            [self setNetworkSuccessStyleUI];
            break;
        case DeviceStyleWifiBleNetworkFail: //配网失败
            [self setNetworkFailStyleUI];
            break;
        case DeviceStyleMeasuringWeight: //测量体重
            [self setMeasuringWeightStyleUI];
            break;
        case DeviceStyleMeasuringResistance: //测量阻抗
            [self setMeasuringSucceedStyleUI];
            break;
        case DeviceStyleMeasuringHeartRate: //测量心率
            [self setMeasuringSucceedStyleUI];
            break;
        case DeviceStyleMeasuringSucceed://测量完成
            [self setMeasuringResistanceStyleUI];
            break;
        case DeviceStyleMeasuringFail://测量完成
            [self setMeasuringFailStyleUI];
            break;
        case DeviceStyleDisconnect://断开连接/称关机
            [self setDisconnectStyleUI];
            [self disconnectDevice];
            break;
        default: //默认状态
            //            [self setNormalStyleUI];
            [self stopScanDevice];
            break;
    }
}
#pragma - UI处理
#pragma mark 正在扫描状态UI
- (void)setScanningStyleUI {
    [self.scanBtn setTitle:@"正在扫描" forState:UIControlStateNormal];
    self.headerView.hidden = NO;
    self.styleLabel.text = @"点击连接设备";
    self.unstableWeightLabel.text = @"";
    self.tableView.hidden = NO;
}

#pragma mark 正在连接状态UI
- (void)setLingingStyleUI {
    [self.scanBtn setTitle:@"断开连接" forState:UIControlStateNormal];
    self.styleLabel.text = @"正在连接";
    self.unstableWeightLabel.text = @"";
    self.tableView.hidden = YES;
    self.headerView.hidden = YES;
}

#pragma mark 连接成功状态UI
- (void)setLingSucceedStyleUI {
    [self.scanBtn setTitle:@"断开连接" forState:UIControlStateNormal];
    self.styleLabel.text = @"连接成功";
    self.unstableWeightLabel.text = @"0.0";
    self.tableView.hidden = YES;
    self.headerView.hidden = YES;
}

#pragma mark 正在配网
- (void)setStartNetworkStyleUI {
    self.styleLabel.text = @"正在配网...";
    self.unstableWeightLabel.text = nil;
}

#pragma mark 配网成功
- (void)setNetworkSuccessStyleUI {
    self.styleLabel.text = @"配网成功";
    self.unstableWeightLabel.text = nil;
}

#pragma mark 配网失败
- (void)setNetworkFailStyleUI {
    self.styleLabel.text = @"配网失败";
    self.unstableWeightLabel.text = nil;
}

#pragma mark 测量体重状态UI
- (void)setMeasuringWeightStyleUI {
    self.styleLabel.text = @"正在称量";
}

#pragma mark 测量阻抗状态UI
- (void)setMeasuringSucceedStyleUI {
    self.styleLabel.text = @"正在测阻抗";
}

#pragma mark 测量完成状态UI
- (void)setMeasuringResistanceStyleUI {
    self.styleLabel.text = @"测量完成";
    self.tableView.hidden = NO;
}

#pragma mark 测量失败
- (void)setMeasuringFailStyleUI {
    self.styleLabel.text = @"测量失败";
    self.tableView.hidden = YES;
}

#pragma mark 断开连接/称关机状态UI
- (void)setDisconnectStyleUI {
    [self.scanBtn setTitle:@"扫描" forState:UIControlStateNormal];
    self.styleLabel.text = @"连接已断开";
}

#pragma mark 默认状态UI
- (void)setNormalStyleUI {
    [self.scanBtn setTitle:@"扫描" forState:UIControlStateNormal];
    self.styleLabel.text = @"";
    self.unstableWeightLabel.text = @"";
    self.tableView.hidden = YES;
    self.headerView.hidden = NO;
}

#pragma mark - 蓝牙状态处理
#pragma mark 开始扫描附近设备
- (void)startScanDevice {
    [self.scanDveices removeAllObjects];
    [self.tableView reloadData];
    [_bleApi startBleDeviceDiscovery:^(NSError *error) {
        
    }];
}

#pragma mark 连接设备设备
- (void)connectDevice:(QNBleDevice *)device {
    [_bleApi stopBleDeviceDiscorvery:^(NSError *error) {
        
    }];
}

#pragma mark 断开设备
- (void)disconnectDevice {
    NSLog(@"************************ 已经发送断开连接 **************************");
    [_bleApi disconnectDevice:nil callback:^(NSError *error) {
        
    }];
    if (self.connectBroadcastDevice) {
        [self disconnectBroadcastDevice];
    }
}

#pragma mark 停止扫描附近设备
- (void)stopScanDevice {
    [_bleApi stopBleDeviceDiscorvery:^(NSError *error) {
        
    }];
}

#pragma mark - QNBleDeviceDiscorveryListener
- (void)onDeviceDiscover:(QNBleDevice *)device {//该方法会在发现设备后回调
    if (self.scanDveices[device.mac] == nil) {
        self.scanDveices[device.mac] = device;
        [self.tableView reloadData];
    }
}

- (void)onKitchenDeviceDiscover:(QNBleKitchenDevice *)device {
    if (self.scanDveices[device.mac] == nil) {
        self.scanDveices[device.mac] = device;
        [self.tableView reloadData];
    }
}

- (void)onBroadcastDeviceDiscover:(QNBleBroadcastDevice *)device {//该方法会回调扫描到的广播秤信息
    [self measuringBroadcastDevice:device];
    if (self.connectBroadcastDevice) { return; }
    if (self.scanDveices[device.mac] == nil) {
        self.scanDveices[device.mac] = device;
        [self.tableView reloadData];
    }
}

#pragma mark - QNBleConnectionChangeListener
- (void)onScaleStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state{//秤连接或测量状态变化
    if (state == QNScaleStateConnected) {//连接成功
        self.currentStyle = DeviceStyleLingSucceed;
        self.connectedBleDevice = device;
        if (device.deviceType == QNDeviceTypeHeightScale || device.deviceType == QNDeviceTypeSlimScale) {
            self.setHeightScaleBtn.hidden = NO;
        }else {
            self.setHeightScaleBtn.hidden = YES;
        }
    }else if (state == QNScaleStateWiFiBleStartNetwork){//开始配网
        self.currentStyle = DeviceStyleWifiBleStartNetwork;
    }else if (state == QNScaleStateWiFiBleNetworkSuccess){//配网成功
        self.currentStyle = DeviceStyleWifiBleNetworkSuccess;
    }else if (state == QNScaleStateWiFiBleNetworkFail){//配网失败
        self.currentStyle = DeviceStyleWifiBleNetworkFail;
    }else if (state == QNScaleStateRealTime){//测量体重
        self.currentStyle = DeviceStyleMeasuringWeight;
    }else if (state == QNScaleStateRealTime){//测量体重
        self.currentStyle = DeviceStyleMeasuringWeight;
    }else if (state == QNScaleStateBodyFat){//测量阻抗
        self.currentStyle = DeviceStyleMeasuringResistance;
    }else if (state == QNScaleStateHeartRate){//测量心率
        self.currentStyle = DeviceStyleMeasuringHeartRate;
    }else if (state == QNScaleStateMeasureCompleted){//测量完成
        self.currentStyle = DeviceStyleMeasuringSucceed;
    }else if (state == QNScaleStateHeightScaleMeasureFail){//测量失败
        self.currentStyle = DeviceStyleMeasuringFail;
    }else if (state == QNScaleStateLinkLoss){//断开连接/称关机
        self.currentStyle = DeviceStyleDisconnect;
        self.connectedBleDevice = nil;
        self.peelBtn.hidden = YES;
        self.setHeightScaleBtn.hidden = YES;
    }
}

#pragma mark - 测量QNDataListener处理
- (void)onGetUnsteadyWeight:(QNBleDevice *)device weight:(double)weight {
    weight = [self.bleApi convertWeightWithTargetUnit:weight unit:[self.bleApi getConfig].unit];
    if ([self.bleApi getConfig].unit == QNUnitSt) {
        double st = weight / 14.0;
        self.unstableWeightLabel.text = [NSString stringWithFormat:@"%.2f st", st];
    } else if ([self.bleApi getConfig].unit == QNUnitStLb) {
        double st = weight / 14.0;
        double tempSt = floor(st);
        double tempLd = (st - floor(st)) * 14;
        if (device.displayModuleType == QNDisplayModuleTypeSimple && tempSt >= 20 && tempLd >= 10) {
            self.unstableWeightLabel.text = [NSString stringWithFormat:@"%.0f st %.0f lb", tempSt, tempLd];
        } else {
            self.unstableWeightLabel.text = [NSString stringWithFormat:@"%.0f st %.1f lb", tempSt, tempLd];
        }
        
    } else if ([self.bleApi getConfig].unit == QNUnitJIN) {
        self.unstableWeightLabel.text = [NSString stringWithFormat:@"%.2f 斤",weight];
    } else {
        self.unstableWeightLabel.text = [NSString stringWithFormat:@"%.2f %@",weight,[self.bleApi getConfig].unit == QNUnitLB ? @"lb" : @"kg"];
    }
}

- (void)onGetScaleData:(QNBleDevice *)device data:(QNScaleData *)scaleData {
    [self.scaleDataAry removeAllObjects];
    ///判断是否进行体质推算
//    QNScaleData *tempData = [[QNBleApi sharedBleApi] physiqueCalculation:scaleData.user area:YLAreaTypeOther weight:scaleData.weight date:scaleData.measureTime];
//    if (tempData) {
//        scaleData = tempData;
//    }
    
    self.unstableWeightLabel.text = [NSString stringWithFormat:@"当前测量的阻抗：%ld - %ld",scaleData.resistance50,scaleData.resistance500];
    
    BOOL isShowEightReport = NO;
    self.isEightElectrodesData = device.isSupportEightElectrodes;
    for (QNScaleItemData *item in [scaleData getAllItem]) {
        /// 当左臂肌肉数值大于零时 可以显示八电极报告
        if (item.type == QNScaleTypeLeftArmMucaleWeightIndex && item.value > 0) {
            isShowEightReport = YES;
        }
        [self.scaleDataAry addObject:item];
    }
    if (device.deviceType == QNDeviceTypeHeightScale) {
        QNScaleItemData *heightItem = [[QNScaleItemData alloc] init];
        heightItem.type = 0; //此次只是为了方便显示, 采用临时赋值
        heightItem.value = scaleData.height;
        heightItem.valueType = QNValueTypeDouble;
        heightItem.name = @"height";
        [self.scaleDataAry addObject:heightItem];
    }
    self.currentStyle = DeviceStyleMeasuringSucceed;
    [self.tableView reloadData];
    
    ///八电极设备 跳转专属分析报告
    if (device.isSupportEightElectrodes && isShowEightReport) {
        self.scaleData = scaleData;
        EightElectrodesReportVC *reportVC = [[EightElectrodesReportVC alloc] init];
        reportVC.config = self.config;
        reportVC.user = self.user;
        reportVC.scaleDataAry = self.scaleDataAry;
        [self.navigationController pushViewController:reportVC animated:YES];
    }else {
        self.scaleData = nil;
    }
}

- (void)onGetStoredScale:(QNBleDevice *)device data:(NSArray<QNScaleStoreData *> *)storedDataList {
    for (int i = 0; i < storedDataList.count; i++) {
        QNScaleStoreData *data = storedDataList[i];
        NSLog(@"******* %ld - %ld ******",data.resistance50,data.resistance500);
        [self.view makeToast:[NSString stringWithFormat:@"******* %ld - %ld ******",data.resistance50,data.resistance500]];
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"存储数据" message:[NSString stringWithFormat:@"一共收到[%lu]条存储数据",(unsigned long)storedDataList.count] preferredStyle:(UIAlertControllerStyleAlert)];
    [alertC addAction:[UIAlertAction actionWithTitle:@"前往查看" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray *storageList = [NSMutableArray array];
        HeightStorageDataVC *storageVC = [[HeightStorageDataVC alloc] init];
        for (int i = 0; i < storedDataList.count; i++) {
            QNScaleStoreData *data = storedDataList[i];
            NSLog(@"******* %ld - %ld ******",data.resistance50,data.resistance500);
            [self.view makeToast:[NSString stringWithFormat:@"******* %ld - %ld ******",data.resistance50,data.resistance500]];
            [storageList addObject:data];
        }
        storageVC.storageList = [NSArray arrayWithArray:storedDataList];
        storageVC.deviceType = device.deviceType;
        [self.navigationController pushViewController:storageVC animated:YES];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil]];
    [self presentViewController:alertC animated:true completion:nil];
}

- (void)onScaleEventChange:(QNBleDevice *)device scaleEvent:(QNScaleEvent)scaleEvent {
    NSString *log = nil;
    if (scaleEvent == QNScaleEventRegistUserFail) {
        log = @"注册用户失败";
    } else if (scaleEvent == QNScaleEventVisitUserFail) {
        log = @"访问用户失败";
    } else if (scaleEvent == QNScaleEventDeleteUserFail) {
        log = @"删除用户失败";
    } else if (scaleEvent == QNScaleEventDeleteUserSuccess) {
        log = @"删除用户成功";
    }
    if (log) {
        [self.view makeToast:log duration:2 position:CSToastPositionCenter];
    }
}

- (void)registerUserComplete:(QNBleDevice *)device user:(QNUser *)user {
    [self.view makeToast:[NSString stringWithFormat:@"当前序列号: %d",user.index] duration:3 position:CSToastPositionCenter];
}

- (NSString *)getLastDataHmac:(QNBleDevice *)device user:(QNUser *)user {
    return @"";
}

- (void)readSnComplete:(QNBleDevice *)device sn:(NSString *)sn {
//    [self.view makeToast:[NSString stringWithFormat:@"sn: %@",sn] duration:3 position:CSToastPositionBottom];
}

/// 收到秤端电量百分比（部分设备支持）
- (void)onGetBatteryLevel:(NSUInteger)batteryLevel isLowLevel:(BOOL)isLowLevel device:(QNBleDevice *)device {
    [self.view makeToast:[NSString stringWithFormat:@"设备电量[%lu]、是否低电[%d]", (unsigned long)batteryLevel, isLowLevel]];
}

/// 获取条形码
- (void)onGetBarCode:(NSString *)barCode mac:(NSString *)mac {
    self.unstableWeightLabel.text = [NSString stringWithFormat:@"条形码内容：%@",barCode];
}

- (void)onGetBarCodeFail:(NSString *)barCode mac:(NSString *)mac {
    self.unstableWeightLabel.text = [NSString stringWithFormat:@"获取条形码失败：%@",barCode];
}

- (void)onGetBarCodeGunState:(BOOL)isConnect mac:(NSString *)mac {
    if (isConnect) {
        self.unstableWeightLabel.text = @"设备连接扫码枪";
    }else {
        self.unstableWeightLabel.text = @"扫码枪断开连接";
    }
}


#pragma mark - QNBleKitchenDataListener
- (void)onGetBleKitchenWeight:(QNBleKitchenDevice *)device weight:(double)weight {
    weight = [self.bleApi convertWeightWithTargetUnit:weight unit:device.unit];
    if (device.unit == QNUnitMilkML) {
        self.unstableWeightLabel.text = [NSString stringWithFormat:@"%.2f ml", weight];
    } else if (device.unit == QNUnitML) {
        self.unstableWeightLabel.text = [NSString stringWithFormat:@"%.2f ml", weight];
    } else if (device.unit == QNUnitOZ) {
        self.unstableWeightLabel.text = [NSString stringWithFormat:@"%.2f oz",weight];
    } else {
        self.unstableWeightLabel.text = [NSString stringWithFormat:@"%.2f g", weight];
    }
}

- (void)onBleKitchenStateChange:(QNBleKitchenDevice *)device scaleState:(QNScaleState)state {
    if (state == QNScaleStateConnected) {//连接成功
        self.currentStyle = DeviceStyleLingSucceed;
    }else if (state == QNScaleStateRealTime){//测量重量
        self.currentStyle = DeviceStyleMeasuringWeight;
    }else if (state == QNScaleStateLinkLoss){//断开连接/称关机
        self.currentStyle = DeviceStyleDisconnect;
        self.peelBtn.hidden = YES;
    }
}

#pragma mark - QNBleStateListener
- (void)onBleSystemState:(QNBLEState)state {
    
}

#pragma mark - 广播秤处理逻辑
- (void)connectBroadcastDevice:(QNBleBroadcastDevice *)device {
    if (self.connectBroadcastDevice) {
        return;
    }
    self.connectBroadcastDevice = device;
    [self setLingingStyleUI];
    [self setLingSucceedStyleUI];
    //由于广播秤无连接过程，因此当我们开始测量时即可认为是已经连接成功，并设置个定时器，在指定时间内未收到设备的广播数据即可认为设备已经灭屏或者是用户未在使用设备
    //时间间隔，可以更根据不同情况自行设置
    [self setBroadcastTimerWithInterval:5];
}

- (void)measuringBroadcastDevice:(QNBleBroadcastDevice *)device {
    if (self.connectBroadcastDevice == nil) {
        return;
    }
    
    //由于广播秤无连接过程，因此当开始某一台广播秤测量时，过滤其他设备信息，只获取开始测量时对应的那台设备的信息
    if ([self.connectBroadcastDevice.mac isEqualToString:device.mac] == NO) {
        return;
    }
    
    //设置秤的单位信息
    //当设备支持修改单位，并且秤上的单位与准备设备的单位时，修改设备的单位
    //目前广播秤未支持ST,即便下发ST单位也会设置成lb,因此目前对于广播秤不建议下发ST
    QNUnit unit = self.config.unit;
    if (unit == QNUnitSt) {
        unit = QNUnitLB;
    }
    
    [device syncUnitCallback:^(NSError *error) {
        //但是方法调用异常时，会回复错误信息
    }];
    
    //当收到指定的设备数据后，更新定时器，用于判断秤是否灭屏或者用户不在使用设备
    [self setBroadcastTimerWithInterval:5];
    
    double weight = [self.bleApi convertWeightWithTargetUnit:device.weight unit:[self.bleApi getConfig].unit];
    self.unstableWeightLabel.text = [NSString stringWithFormat:@"%.2f",weight];
    
    if (device.isComplete == NO) {
        [self setMeasuringWeightStyleUI];
    }
    
    //由于测量完成时，会收到多条完成的广播数据，此处用于避免收取重复数据的问题
    if (device.isComplete && self.broadcastMesasureCompleteCount != device.measureCode) {
        self.broadcastMesasureCompleteCount = device.measureCode;
        //测量完成
        QNScaleData *scaleData = [device generateScaleDataWithUser:self.user callback:^(NSError *error) {
            
        }];
        [self.scaleDataAry removeAllObjects];
        for (QNScaleItemData *item in [scaleData getAllItem]) {
            [self.scaleDataAry addObject:item];
        }
        self.currentStyle = DeviceStyleMeasuringSucceed;
        [self.tableView reloadData];
        [self setMeasuringResistanceStyleUI];
    }
    
}

- (void)setBroadcastTimerWithInterval:(NSTimeInterval)interval {
    [self removeBroadcastTimer];
    __weak __typeof(self)weakSelf = self;
    self.broadcastTimer = [NSTimer scheduledTimerWithTimeInterval:interval block:^(NSTimer * _Nonnull timer) {
        //未接到新广播数据时，可认为不再测量体重（断开的意思）
        [weakSelf disconnectBroadcastDevice];
    } repeats:NO];
}

- (void)removeBroadcastTimer {
    [self.broadcastTimer invalidate];
    self.broadcastTimer = nil;
}


- (void)disconnectBroadcastDevice {
    self.connectBroadcastDevice = nil;
    [self removeBroadcastTimer];
    [self setDisconnectStyleUI];
    //此处断开后停止扫描，只是demo的处理逻辑
    [self.bleApi stopBleDeviceDiscorvery:^(NSError *error) {
        
    }];
}

#pragma mark - QNBleConnectionChangeListener
- (void)onConnecting:(QNBleDevice *)device {
    
}

- (void)onConnected:(QNBleDevice *)device {
    
}

- (void)onServiceSearchComplete:(QNBleDevice *)device {
    
}

- (void)onDisconnecting:(QNBleDevice *)device {
    
}

- (void)onDisconnected:(QNBleDevice *)device {
    
}

- (void)onConnectError:(QNBleDevice *)device error:(NSError *)error {
    
}

#pragma mark - UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentStyle == DeviceStyleScanning && self.connectBroadcastDevice == nil) {
        return self.scanDveices.count;
    }else {
        return self.scaleDataAry.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentStyle == DeviceStyleScanning && self.connectBroadcastDevice == nil) {
        return 42;
    }else {
        return 90;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentStyle == DeviceStyleScanning && self.connectBroadcastDevice == nil) {
        DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DeviceTableViewCell" owner:self options:nil]lastObject];
        }
        NSString *mac = self.scanDveices.allKeys[indexPath.row];
        id device = self.scanDveices[mac];
        if ([device isKindOfClass:[QNBleBroadcastDevice class]]) {
            cell.broadcastDevice = device;
        }else if ([device isKindOfClass:[QNBleKitchenDevice class]]) {
            cell.kitchenDevice = device;
        } else {
            cell.device = device;
        }
        return cell;
    }else {
        ScaleDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScaleDataCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ScaleDataCell" owner:self options:nil]lastObject];
        }
        cell.isEightElectrodesData = self.isEightElectrodesData;
        cell.user = self.user;
        cell.currentWeight = ((QNScaleItemData *)self.scaleDataAry[0]).value;
        cell.itemData = self.scaleDataAry[indexPath.row];
        cell.unit = [self.bleApi getConfig].unit;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentStyle != DeviceStyleScanning) {
        return;
    }
    
    DeviceTableViewCell *cell = (DeviceTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.broadcastDevice != nil) {
        [self connectBroadcastDevice:cell.broadcastDevice];
        return;
    }
    
    if (cell.kitchenDevice != nil) {
        self.currentStyle = DeviceStyleLinging;
        self.peelBtn.hidden = NO;
        [_bleApi connectBleKitchenDevice:cell.kitchenDevice callback:^(NSError *error) {
        
        }];
    }
    
    QNBleDevice *device = cell.device;
    
    if (device.deviceType == QNDeviceTypeUserScale) {
        
        [self.bleApi stopBleDeviceDiscorvery:^(NSError *error) {
            
        }];
        WspConfigVC *configVC = [[WspConfigVC alloc] init];
        self.wspConfigVC = configVC;
        self.wspConfigVC.bleDevice = device;
        self.wspConfigVC.delegate = self;
        [self presentViewController:self.wspConfigVC animated:YES completion:nil];
    }else if(device.deviceType == QNDeviceTypeSlimScale) {
        QNConfig *shareConfig = self.config;
        [shareConfig save];
        QNUserScaleConfig *config = [[QNUserScaleConfig alloc]init];
        config.curUser = self.user;
        // 连接设备时，默认访问坑位1的用户
        config.curUser.index = 1;
        config.curUser.secret = 1001;
        
        [_bleApi stopBleDeviceDiscorvery:^(NSError *error) {}];
        [_bleApi connectUserScaleDevice:device config:config callback:^(NSError *error) {
            
        }];
        
    }else if (!device.supportWifi) {
        if (device.deviceType == QNDeviceTypeScaleBleDefault) {
            [_bleApi stopBleDeviceDiscorvery:^(NSError *error) {}];
        }
        self.currentStyle = DeviceStyleLinging;
        [_bleApi connectDevice:device user:self.user callback:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }else if(device.deviceType == QNDeviceTypeHeightScale) {
        [self wifiBleNetworkRemindWithHeightScale:device];
    }else {
        [self wifiBleNetworkRemindWithDevice:device];
    }
}

- (void)wifiBleNetworkRemindWithHeightScale:(QNBleDevice *)device {
    NSString *wifiName = @"King";
    NSString *pwd = @"987654321";
    // https://sit-wspmock.yolanda.hk/aios/measurements/get_cp30b_data?
    // http://wsp-lite.yolanda.hk/yolanda/aios?code=
    NSString *serviceUrl = @"http://wsp-lite.yolanda.hk/yolanda/aios?code=";
    NSString *encryption = @"yolandakitnewhdr";
    NSString *otaUrl = @"https://ota.yolanda.hk";
    
    // 创建 UIAlertController
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"设备配网"
                                                                     message:@"如不需要配网，请点击取消"
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加 Wi-Fi 名称文本框
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull wifiNameTextField) {
        wifiNameTextField.text = wifiName;
        wifiNameTextField.textAlignment = NSTextAlignmentCenter;
        wifiNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    // 添加 Wi-Fi 密码文本框
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull wifiPwdTextField) {
        wifiPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        wifiPwdTextField.textAlignment = NSTextAlignmentCenter;
        wifiPwdTextField.placeholder = @"若该WiFi无密码则无需输入";
        wifiPwdTextField.text = pwd;
    }];
    
    // 添加服务器 URL 文本框
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull serverUrlTF) {
        serverUrlTF.text = serviceUrl;
        serverUrlTF.placeholder = @"serverURL";
        serverUrlTF.textAlignment = NSTextAlignmentCenter;
        serverUrlTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    // 添加加密密钥文本框
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull encryptionTF) {
        encryptionTF.text = encryption;
        encryptionTF.placeholder = @"请输入encryption";
        encryptionTF.textAlignment = NSTextAlignmentCenter;
        encryptionTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    // 添加 OTA URL 文本框
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull otaUrlTF) {
        otaUrlTF.text = otaUrl;
        otaUrlTF.textAlignment = NSTextAlignmentCenter;
        otaUrlTF.placeholder = @"otaURL";
        otaUrlTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    // 创建取消动作
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    // 创建“连接并配网”动作
    UIAlertAction *connectAndPairAction = [UIAlertAction actionWithTitle:@"连接并配网"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
        // 从文本字段获取输入
        NSString *wifiName = alertVC.textFields[0].text;
        NSString *wifiPwd = alertVC.textFields[1].text;
        NSString *serverUrl = alertVC.textFields[2].text;
        NSString *encryption = alertVC.textFields[3].text;
        NSString *otaUrl = alertVC.textFields[4].text;
        
        // 创建 QNWiFiConfig 对象并配置属性
        QNWiFiConfig *scaleWifiConfig = [[QNWiFiConfig alloc] init];
        scaleWifiConfig.ssid = wifiName;
        scaleWifiConfig.pwd = wifiPwd;
        scaleWifiConfig.serveUrl = serverUrl;
        scaleWifiConfig.encryptionKey = encryption;
        scaleWifiConfig.fotaUrl = otaUrl;
        
        [_bleApi stopBleDeviceDiscorvery:^(NSError *error) {}];
        // 创建并配置 HeightConnectVC
        QNHeightDeviceConfig *config = [[QNHeightDeviceConfig alloc]init];
        config.wifiConfig = scaleWifiConfig;
        config.curUser = self.user;
        [_bleApi connectHeightScaleDevice:device config:config callback:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }];
    UIAlertAction *connectAction = [UIAlertAction actionWithTitle:@"直接连接"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
        [_bleApi stopBleDeviceDiscorvery:^(NSError *error) {}];
        QNHeightDeviceConfig *config = [[QNHeightDeviceConfig alloc]init];
        config.curUser = self.user;
        [_bleApi connectHeightScaleDevice:device config:config callback:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:connectAndPairAction];
    [alertVC addAction:connectAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}


- (void)wifiBleNetworkRemindWithDevice:(QNBleDevice *)device {
    __weak __typeof(self)weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"双模秤配置" message:@"如不需要配网，请直接点击连接" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = [WiFiTool currentWifiName];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.enabled = NO;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"若该WiFi无密码，则无需输入";
        textField.textAlignment = NSTextAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *connectAction = [UIAlertAction actionWithTitle:@"直接连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.bleApi stopBleDeviceDiscorvery:^(NSError *error) {}];
        [weakSelf.bleApi connectDevice:device user:weakSelf.user callback:^(NSError *error) {
            
        }];
    }];
    
    UIAlertAction *networkAction = [UIAlertAction actionWithTitle:@"配网并连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *ssid = alert.textFields.firstObject.text;
        NSString *pwd = alert.textFields[1].text;
        QNWiFiConfig *config = [[QNWiFiConfig alloc] init];
        config.ssid = ssid;
        config.pwd = pwd;
        if (device.deviceType == QNDeviceTypeUserScale) {
            config.serveUrl = @"http://wifi.yolanda.hk:80/wifi_api/wsps?code=";
        }
        [weakSelf.bleApi stopBleDeviceDiscorvery:^(NSError *error) {}];
        [weakSelf.bleApi connectDeviceSetWiFiWithDevice:device user:weakSelf.user wifiConfig:config callback:^(NSError *error) {
            
        }];
    }];
    [alert addAction:connectAction];
    [alert addAction:networkAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (IBAction)clickScanBtn:(UIButton *)sender {
    switch (self.currentStyle) {
        case DeviceStyleScanning: self.currentStyle = DeviceStyleNormal; break;
        case DeviceStyleLinging:
        case DeviceStyleLingSucceed:
        case DeviceStyleMeasuringWeight:
        case DeviceStyleMeasuringResistance:
        case DeviceStyleMeasuringHeartRate:
        case DeviceStyleMeasuringSucceed:
            self.currentStyle = DeviceStyleDisconnect;
            break;
        case DeviceStyleDisconnect: self.currentStyle = DeviceStyleScanning; break;
        default:
            self.currentStyle = DeviceStyleScanning;
            break;
    }
}

- (NSMutableDictionary *)scanDveices {
    if (_scanDveices == nil) {
        _scanDveices = [NSMutableDictionary dictionary];
    }
    return _scanDveices;
}

- (NSMutableArray *)scaleDataAry {
    if (!_scaleDataAry) {
        _scaleDataAry = [NSMutableArray arrayWithCapacity:1];
    }
    return _scaleDataAry;
}

#pragma mark -
- (void)selectUserConfig:(QNUserScaleConfig *)userConfig userIndex:(int)userIndex userSecret:(int)userSecret device:(QNBleDevice *)device {
    QNUserScaleConfig *config = userConfig;
    self.currentStyle = DeviceStyleLinging;
    self.user.index = userIndex;
    self.user.secret = userSecret;
    config.curUser = self.user;
    [_bleApi connectUserScaleDevice:device config:config callback:^(NSError *error) {
        
    }];
}

- (void)dismissWspConfigVC {
    [self.wspConfigVC dismissViewControllerAnimated:YES completion:^{

    }];
}

- (void)adjustResistanceWithHmac:(NSString *)hmac {
    [self.scaleData setFatThreshold:2 hmac:hmac callBlock:^(NSError *error) {
        
    }];
    [self.scaleDataAry removeAllObjects];
    for (QNScaleItemData *item in [self.scaleData getAllItem]) {
        [self.scaleDataAry addObject:item];
    }
    [self.tableView reloadData];
}
@end
