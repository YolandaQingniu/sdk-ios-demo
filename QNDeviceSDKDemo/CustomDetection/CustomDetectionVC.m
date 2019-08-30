//
//  CustomDetectionVC.m
//  QNDeviceSDKDemo
//
//  Created by JuneLee on 2019/8/29.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "CustomDetectionVC.h"
#import "DeviceTableViewCell.h"
#import "ScaleDataCell.h"
#import "WiFiTool.h"
#import "NSTimer+YYAdd.h"
#import <CoreBluetooth/CoreBluetooth.h>

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

#pragma mark 系统蓝牙状态
typedef NS_ENUM(NSUInteger, DMBlueToothState) {
    DMBlueToothStateUnknown = 0,
    DMBlueToothStateResetting,
    DMBlueToothStateUnsupported,
    DMBlueToothStateUnauthorized,
    DMBlueToothStatePoweredOff,
    DMBlueToothStatePoweredOn,
};


@interface CustomDetectionVC ()<UITableViewDelegate,UITableViewDataSource,QNScaleDataListener,QNBleProtocolDelegate,CBCentralManagerDelegate,CBPeripheralDelegate>

@property (weak, nonatomic) IBOutlet UILabel *appIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *unstableWeightLabel;  //时时体重
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic, assign) DeviceStyle currentStyle;
@property (nonatomic, strong) NSMutableDictionary *scanDveices;
@property (nonatomic, strong) NSMutableArray *scaleDataAry; //收到测量完成后数组

@property (nonatomic, strong) QNBleApi *bleApi;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) QNBleDevice *bleDevice;
@property (nonatomic, strong) QNBleProtocolHandler *protocolHandle;
@property (nonatomic, strong) QNBleBroadcastDevice *connectBroadcastDevice; //当前连接的设备
@property (nonatomic, assign) int broadcastMesasureCompleteCount;
@property (nonatomic, strong) NSTimer *broadcastTimer;

@end

@implementation CustomDetectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测量";
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.currentStyle = DeviceStyleNormal;
    
    if (self.centralManager == nil) {
        self.centralManager =  [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey : [NSNumber numberWithBool:YES]}];
    }
    
    self.bleApi = [QNBleApi sharedBleApi];
    self.bleApi.dataListener = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)back {
    [self cancelConnectDevicePeripheral:self.bleDevice.publicDevice.peripheral];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 连接与断开
- (void)startScanDevice {
    [self.scanDveices removeAllObjects];
    [self.tableView reloadData];
    DMBlueToothState state = [self currentBlueToothState];
    if (state == DMBlueToothStatePoweredOn) {
        [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
    }
}

- (void)stopScanDevice {
    if ([self currentBlueToothState] == DMBlueToothStatePoweredOn) {
        [self.centralManager stopScan];
    }
}

- (void)connectPeripheral:(QNBleDevice *)device user:(nonnull QNUser *)user {
    
    QNPScaleConfig *scaleConfig = [[QNPScaleConfig alloc] init];
    
    scaleConfig.unitMode = QNPScaleUnitKG;
    scaleConfig.readStorageDataFlag = YES;
    
    if (scaleConfig == nil) {
        scaleConfig = [[QNPScaleConfig alloc] init];
        scaleConfig.unitMode = QNPScaleUnitKG;
        scaleConfig.readStorageDataFlag = YES;
    }
    
    device.publicDevice.scaleHelp = [[QNPScaleHelp  alloc] init];
    device.publicDevice.scaleHelp.scaleConfig = scaleConfig;
    device.publicDevice.scaleHelp.scaleUser = [self transformQNPUser:user];
    
    self.bleDevice = device;
    self.bleDevice.publicDevice.peripheral.delegate = self;
    
    NSMutableDictionary *configDic = [NSMutableDictionary dictionary];
    [configDic setObject:[NSNumber numberWithBool:NO] forKey:CBConnectPeripheralOptionNotifyOnConnectionKey];
    [configDic setObject:[NSNumber numberWithBool:NO] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey];
    [configDic setObject:[NSNumber numberWithBool:NO] forKey:CBConnectPeripheralOptionNotifyOnNotificationKey];
    [configDic setObject:[NSNumber numberWithBool:NO] forKey:CBConnectPeripheralOptionNotifyOnNotificationKey];
    
    [self onScaleStateChange:device scaleState:(QNScaleStateConnected)];
    [self.centralManager connectPeripheral:device.publicDevice.peripheral options:configDic];
    
    self.protocolHandle = [self.bleApi buildProtocolHandler:device user:self.user delegate:self callback:^(NSError *error) {
    }];
}

- (void)cancelConnectDevicePeripheral:(CBPeripheral *)peripheral {
    BOOL vail = [self currentBlueToothState] == DMBlueToothStatePoweredOn;
    if (@available(iOS 9.0, *)) {
        vail =  vail && peripheral.state != CBPeripheralStateDisconnected && peripheral.state != CBPeripheralStateDisconnecting;
    } else {
        vail =  vail && peripheral.state != CBPeripheralStateDisconnected;
    }
    if (vail) {
        [self.centralManager cancelPeripheralConnection:peripheral];
        [self onScaleStateChange:self.bleDevice scaleState:(QNScaleStateLinkLoss)];
    }
    if (self.connectBroadcastDevice) {
        [self disconnectBroadcastDevice];
    }
}

#pragma mark - private
- (DMBlueToothState)currentBlueToothState {
    DMBlueToothState bleState = DMBlueToothStateUnknown;
    if (@available(iOS 10.0, *)) {
        switch (self.centralManager.state) {
            case CBManagerStateResetting:
                bleState = DMBlueToothStateResetting;
                break;
            case CBManagerStateUnsupported:
                bleState = DMBlueToothStateUnsupported;
                break;
            case CBManagerStateUnauthorized:
                bleState = DMBlueToothStateUnauthorized;
                break;
            case CBManagerStatePoweredOff:
                bleState = DMBlueToothStatePoweredOff;
                break;
            case CBManagerStatePoweredOn:
                bleState = DMBlueToothStatePoweredOn;
                break;
            default:
                bleState = DMBlueToothStateUnknown;
                break;
        }
    } else {
        switch (self.centralManager.state) {
            case CBCentralManagerStateResetting:
                bleState = DMBlueToothStateResetting;
                break;
            case CBCentralManagerStateUnsupported:
                bleState = DMBlueToothStateUnsupported;
                break;
            case CBCentralManagerStateUnauthorized:
                bleState = DMBlueToothStateUnauthorized;
                break;
            case CBCentralManagerStatePoweredOff:
                bleState = DMBlueToothStatePoweredOff;
                break;
            case CBCentralManagerStatePoweredOn:
                bleState = DMBlueToothStatePoweredOn;
                break;
            default:
                bleState = DMBlueToothStateUnknown;
                break;
        }
    }
    return bleState;
}

#pragma mark - QNBleProtocolDelegate
- (void)writeCharacteristicValue:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID data:(NSData *)data {
    
    [self writeData:data uuidMode:characteristicUUID];
}

- (void)writeData:(NSData *)writeData uuidMode:(NSString *)writeUUIDMode{
    const Byte *bytes = writeData.bytes;
    NSString *dataStr = @"";
    for (int i = 0; i < writeData.length; i ++) {
        dataStr = [NSString stringWithFormat:@"%@ %02x",dataStr,bytes[i]];
    }
    
    QNPScaleHelp *scaleHelp = self.bleDevice.publicDevice.scaleHelp;
    
    if (scaleHelp == nil) {
        NSLog(@"设备为nil %lu 值为nil %@",(unsigned long)writeUUIDMode,dataStr);
        return;
    }
    
    CBCharacteristic *characteristic = nil;
    if ([writeUUIDMode isEqualToString:@"FFE3"]) {
        characteristic = scaleHelp.writeCharacteristic;
    }else if ([writeUUIDMode isEqualToString:@"FFE4"]){
        characteristic = scaleHelp.storageWriteCharacteristic;
    }else if ([writeUUIDMode isEqualToString:@"FFF2"]){
        characteristic = scaleHelp.writeCharacteristic;
    }else if ([writeUUIDMode isEqualToString:@"FFE5"]){
        characteristic = scaleHelp.productWriteCharacteristic;
    }
    
    if (characteristic) {
        
        if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) {
            [self.bleDevice.publicDevice.peripheral writeValue:writeData forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
        }else{
            [self.bleDevice.publicDevice.peripheral writeValue:writeData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }
    }else {
        NSLog(@"特征 %lu 值为nil %@",(unsigned long)writeUUIDMode,dataStr);
    }
}

- (void)readCharacteristicValue:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID {
    
}

#pragma mark - CBCentralManagerDelegate
/** 系统蓝牙状态更新 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    DMBlueToothState bleState = [self currentBlueToothState];
    NSLog(@"系统蓝牙状态更新: %ld",(long)bleState);
    if (bleState != DMBlueToothStatePoweredOn) {
        self.bleDevice = nil;
    }
}

/** 系统蓝牙发现外设 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSString *bleName = peripheral.name;
    NSData *manufacturerData = (NSData *)[advertisementData valueForKey:CBAdvertisementDataManufacturerDataKey];
    
    if ([bleName isEqualToString:@"QN-S3"] && manufacturerData.length >= 19) {
        [self analysisAdvertDevicePeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    }else {
        [self analysisPublicDevicePeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    }
}

- (void)analysisPublicDevicePeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    QNBleDevice *bleDevice = [self.bleApi buildDevice:peripheral advertisementData:advertisementData callback:^(NSError *error) {
    }];
    if (bleDevice == nil) return;
    
    [bleDevice setValue:RSSI forKeyPath:@"RSSI"];
    if (bleDevice.deviceType == QNDeviceTypeScaleBroadcastDouble || bleDevice.deviceType == QNDeviceTypeScaleBroadcastSingle) {
        //为了兼容0.6.5之前的版本，该处依然会有广播秤设备信息的回调
        //当使用0.6.5及以上版本，不再建议监听广播秤设备对象。而是【onBroadcastDeviceDiscover】使用该回调监听自定义广播秤的测量逻辑
        return;
    }
    
    if (self.scanDveices[bleDevice.mac] == nil) {
        self.scanDveices[bleDevice.mac] = bleDevice;
        [self.tableView reloadData];
    }
}

- (void)analysisAdvertDevicePeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    QNBleBroadcastDevice *broadcastDevice = [self.bleApi buildBroadcastDevice:peripheral advertisementData:advertisementData callback:^(NSError *error) {
    }];
    if (broadcastDevice == nil) return;
    
    [broadcastDevice setValue:RSSI forKeyPath:@"RSSI"];
    [self measuringBroadcaseDevice:broadcastDevice];
    if (self.connectBroadcastDevice) { return; }
    if (self.scanDveices[broadcastDevice.mac] == nil) {
        self.scanDveices[broadcastDevice.mac] = broadcastDevice;
        [self.tableView reloadData];
    }
}

/** 系统蓝牙连接到外设 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    self.currentStyle = DeviceStyleLingSucceed;
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"连接失败");
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"断开连接设备");
}

/** 发现服务 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"%@ 设备发现服务出错 %@",peripheral.name,userInfo);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

/** 发现特征 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error {
    
    if (error) {
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"%@ 设备发现特征出错 %@",peripheral.name,userInfo);
        return;
    }
    for (CBCharacteristic *characteristics in service.characteristics) {
        NSString *uuidStr = characteristics.UUID.UUIDString.uppercaseString;
        
        NSLog(@"%@ 设备发现特征: %@",peripheral.name,uuidStr);
        
        if ([uuidStr isEqualToString:@"FFE2"]) {
            self.bleDevice.publicDevice.scaleHelp.indicateCharacteristic = characteristics;
            [peripheral setNotifyValue:YES forCharacteristic:characteristics];
        }else if ([uuidStr isEqualToString:@"FFE3"] || [uuidStr isEqualToString:@"FFF2"]){
            self.bleDevice.publicDevice.scaleHelp.writeCharacteristic = characteristics;
        }else if ([uuidStr isEqualToString:@"FFE1"] || [uuidStr isEqualToString:@"FFF1"]){
            self.bleDevice.publicDevice.scaleHelp.notifyCharacteristic = characteristics;
            [peripheral setNotifyValue:YES forCharacteristic:characteristics];
        }else if ([uuidStr isEqualToString:@"FFE4"]){
            self.bleDevice.publicDevice.scaleHelp.storageWriteCharacteristic = characteristics;
        }else if ([uuidStr isEqualToString:@"FFE5"]){
            self.bleDevice.publicDevice.scaleHelp.productWriteCharacteristic = characteristics;
        }
        //电量
        if ([service.UUID.UUIDString.uppercaseString isEqualToString:@"180F"]) {
            self.bleDevice.publicDevice.scaleHelp.batteryCharacteristic = characteristics;
        }
    }
    [self.protocolHandle prepare:service.UUID.UUIDString];
}

/** 写数据的回应 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error) {
        NSLog(@"%@ 数据通道出现错误  %@",characteristic.UUID.UUIDString,error.description);
    }
}

/** 数据更新 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *serviceUUID = @"FFE0";
        if (self.bleDevice.publicDevice.scaleHelp.serverMode == QNPScaleServerFFF0) {
            serviceUUID = @"FFF0";
        }
        [self.protocolHandle onGetBleData:serviceUUID characteristicUUID:characteristic.UUID.UUIDString data:characteristic.value];
    });
}

- (QNPUser *)transformQNPUser:(QNUser *)user {
    QNPUser *puser = [QNPUser userHeight:user.height gender:[user.gender isEqualToString:@"female"] ? QNPUserGenderFemale : QNPUserGenderMale age:[self userAgeForBirthday:user.birthday]];
    return puser;
}

- (int)userAgeForBirthday:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear fromDate:date];
    int birthdayYear = (int)dateComponents.year;
    dateComponents = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    int age = (int)(dateComponents.year - birthdayYear);
    return age;
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
            [self cancelConnectDevicePeripheral:self.bleDevice.publicDevice.peripheral];
            break;
        default: //默认状态
            [self setNormalStyleUI];
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
        self.currentStyle = DeviceStyleNormal;
    }
}

#pragma mark - 测量QNDataListener处理
- (void)onGetUnsteadyWeight:(QNBleDevice *)device weight:(double)weight {
    weight = [self.bleApi convertWeightWithTargetUnit:weight unit:[self.bleApi getConfig].unit];
    self.unstableWeightLabel.text = [NSString stringWithFormat:@"%.2f",weight];
}

- (void)onGetScaleData:(QNBleDevice *)device data:(QNScaleData *)scaleData {
    [self.scaleDataAry removeAllObjects];
    for (QNScaleItemData *item in [scaleData getAllItem]) {
        [self.scaleDataAry addObject:item];
    }
    [self.tableView reloadData];
}

- (void)onGetStoredScale:(QNBleDevice *)device data:(NSArray<QNScaleStoreData *> *)storedDataList {
    
}

- (void)onGetElectric:(NSUInteger)electric device:(QNBleDevice *)device {
    
}

#pragma mark - 广播秤处理逻辑
- (void)connectBroadcaseDevice:(QNBleBroadcastDevice *)device {
    if (self.connectBroadcastDevice) {
        return;
    }
    self.connectBroadcastDevice = device;
    [self setLingingStyleUI];
    [self setLingSucceedStyleUI];
    //由于广播秤无连接过程，因此当我们开始测量时即可认为是已经连接成功，并设置个定时器，在指定时间内未收到设备的广播数据即可认为设备已经灭屏或者是用户未在使用设备
    //时间间隔，可以更根据不同情况自行设置
    [self setBroadcaseTimerWithInterval:5];
}

- (void)measuringBroadcaseDevice:(QNBleBroadcastDevice *)device {
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
    if (unit == QNUnitST) {
        unit = QNUnitLB;
    }
    
    if (device.supportUnitChange && device.unit != unit) {
        [device syncUnitCallback:^(NSError *error) {
            //但是方法调用异常时，会回复错误信息
        }];
    }
    
    //当收到指定的设备数据后，更新定时器，用于判断秤是否灭屏或者用户不在使用设备
    [self setBroadcaseTimerWithInterval:5];
    
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
        [self.tableView reloadData];
        [self setMeasuringResistanceStyleUI];
    }
    
}

- (void)setBroadcaseTimerWithInterval:(NSTimeInterval)interval {
    [self removeBroadcaseTimer];
    __weak __typeof(self)weakSelf = self;
    self.broadcastTimer = [NSTimer scheduledTimerWithTimeInterval:interval block:^(NSTimer * _Nonnull timer) {
        //未接到新广播数据时，可认为不再测量体重（断开的意思）
        [weakSelf disconnectBroadcastDevice];
    } repeats:NO];
}

- (void)removeBroadcaseTimer {
    [self.broadcastTimer invalidate];
    self.broadcastTimer = nil;
}


- (void)disconnectBroadcastDevice {
    self.connectBroadcastDevice = nil;
    [self removeBroadcaseTimer];
    [self setDisconnectStyleUI];
    //此处断开后停止扫描，只是demo的处理逻辑
    [self stopScanDevice];
}


#pragma mark - UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentStyle == DeviceStyleScanning && self.connectBroadcastDevice == nil) {
        return self.scanDveices.count;
    }else {
        return self.scaleDataAry.count;
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
        }else {
            cell.device = device;
        }
        return cell;
    }else {
        ScaleDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScaleDataCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ScaleDataCell" owner:self options:nil]lastObject];
        }
        cell.itemData = self.scaleDataAry[indexPath.row];
        cell.unit = [self.bleApi getConfig].unit;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentStyle != DeviceStyleScanning) { return; }
    DeviceTableViewCell *cell = (DeviceTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.broadcastDevice != nil) {
        [self connectBroadcaseDevice:cell.broadcastDevice];
        return;
    }
    
    QNBleDevice *device = cell.device;
    if (device.deviceType != QNDeviceTypeScaleWiFiBLE) {
        if (device.deviceType == QNDeviceTypeScaleBleDefault) {
            [self stopScanDevice];
        }
        self.currentStyle = DeviceStyleLinging;
        [self connectPeripheral:device user:self.user];
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
        [weakSelf stopScanDevice];
        [weakSelf connectPeripheral:device user:weakSelf.user];
    }];
    
    UIAlertAction *networkAction = [UIAlertAction actionWithTitle:@"配网并连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *ssid = alert.textFields.firstObject.text;
        NSString *pwd = alert.textFields[1].text;
        QNWiFiConfig *config = [[QNWiFiConfig alloc] init];
        config.ssid = ssid;
        config.pwd = pwd;
        
        //TODO...配网连接 待定
        [weakSelf stopScanDevice];
        [weakSelf connectPeripheral:device user:weakSelf.user];
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


@end
