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
    DeviceStyleLinging = 2,   //正在链接
    DeviceStyleLingSucceed = 3, //链接成功
    DeviceStyleMeasuringWeight = 4,//测量体重
    DeviceStyleMeasuringResistance = 5,//测量阻抗
    DeviceStyleMeasuringHeartRate = 6, //测量心率
    DeviceStyleMeasuringSucceed = 7,     //测量完成
    DeviceStyleDisconnect = 8,         //断开连接/称关机
    DeviceStyleWifiBleStartNetwork = 9,         //开始配网
    DeviceStyleWifiBleNetworkSuccess = 10,         //配网成功
    DeviceStyleWifiBleNetworkFail = 11,         //配网失败
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

@interface DetectionViewController ()<UITableViewDelegate,UITableViewDataSource,QNBleConnectionChangeListener,QNUserScaleDataListener,QNBleDeviceDiscoveryListener,QNBleStateListener,WspConfigVCDelegate,QNBleKitchenListener>
@property (weak, nonatomic) IBOutlet UILabel *appIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *unstableWeightLabel;  //时时体重
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *peelBtn; //去皮按键

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

/// 当前测量数据
@property (nonatomic, strong) QNScaleData *scaleData;

@end

@implementation DetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测量";
    self.appIdLabel.text = kAppid;
    self.peelBtn.hidden = YES;
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

#pragma mark 设置设备各个阶段状态
- (void)setCurrentStyle:(DeviceStyle)currentStyle {
    _currentStyle = currentStyle;
    switch (_currentStyle) {
        case DeviceStyleScanning: //正在扫描
            [self setScanningStyleUI];
            [self startScanDevice];
            break;
        case DeviceStyleLinging: //正在链接
            [self setLingingStyleUI];
            break;
        case DeviceStyleLingSucceed: //链接成功
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
    self.styleLabel.text = @"点击链接设备";
    self.unstableWeightLabel.text = @"";
    self.tableView.hidden = NO;
}

#pragma mark 正在链接状态UI
- (void)setLingingStyleUI {
    [self.scanBtn setTitle:@"断开连接" forState:UIControlStateNormal];
    self.styleLabel.text = @"正在连接";
    self.unstableWeightLabel.text = @"";
    self.tableView.hidden = YES;
    self.headerView.hidden = YES;
}

#pragma mark 链接成功状态UI
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

#pragma mark 链接设备设备
- (void)connectDevice:(QNBleDevice *)device {
    [_bleApi stopBleDeviceDiscorvery:^(NSError *error) {
        
    }];
}

#pragma mark 断开设备
- (void)disconnectDevice {
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
    if (state == QNScaleStateConnected) {//链接成功
        self.currentStyle = DeviceStyleLingSucceed;
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
    }else if (state == QNScaleStateLinkLoss){//断开连接/称关机
        self.currentStyle = DeviceStyleDisconnect;
        self.peelBtn.hidden = YES;
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
//    QNScaleStoreData *data = storedDataList.firstObject;
//    QNScaleStoreData *temp = [QNScaleStoreData buildStoreDataWithWeight:data.weight measureTime:data.measureTime mac:data.mac hmac:data.hmac callBlock:^(NSError *error) {
//        
//    }];
//    NSString *string = [NSString stringWithFormat:@"收到存储数据 %ld 条：",storedDataList.count];
//    for (int i = 0; i < storedDataList.count; i++) {
//        QNScaleStoreData *storeData = storedDataList[i];
//        string = [string stringByAppendingFormat:@"\n第%d条数据，测量时间：%@",i+1,storeData.measureTime];
//    }
//    [self.view makeToast:string duration:10 position:CSToastPositionCenter];
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
    if (state == QNScaleStateConnected) {//链接成功
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
        } else if (!device.supportWifi || device.deviceType == QNDeviceTypeHeightScale) {
            if (device.deviceType == QNDeviceTypeScaleBleDefault) {
                [_bleApi stopBleDeviceDiscorvery:^(NSError *error) {}];
            }
            self.currentStyle = DeviceStyleLinging;
            [_bleApi connectDevice:device user:self.user callback:^(NSError *error) {
                
            }];
        }else {
            [self wifiBleNetworkRemindWithDevice:device];
        }
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
