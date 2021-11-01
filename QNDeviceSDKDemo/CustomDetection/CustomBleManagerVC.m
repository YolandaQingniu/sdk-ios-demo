//
//  CustomBleManagerVC.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2020/10/21.
//  Copyright © 2020 Yolanda. All rights reserved.
//

#import "CustomBleManagerVC.h"
#import "QNDeviceSDK.h"
#import "Masonry.h"
#import "UIView+Toast.h"
#import "QNBleDevice+Addition.h"
#import "CustomDeviceCell.h"

//服务ID
#define KScaleDeviceServiceUUID @"FFE0" //qn-scale 服务
#define KScaleDeviceCharacteristicUUIDNotify @"FFE1"
#define KScaleDeviceCharacteristicUUIDWrite @"FFE3"
#define KScaleDeviceCharacteristicUUIDIndicate @"FFE2"
#define KScaleDeviceCharacteristicUUIDStorageWrite @"FFE4"

#define KScale1SerivceUUID @"FFF0" //qn-scale1 服务
#define KScale1CharacteristicUUIDWrite @"FFF2"
#define KScale1CharacteristicUUIDNotify @"FFF1"

@interface CustomBleManagerVC ()<CBCentralManagerDelegate, CBPeripheralDelegate, QNScaleDataListener, QNBleProtocolDelegate, QNBleProtocolDelegate, QNScaleDataListener, QNBleConnectionChangeListener, UITableViewDelegate, UITableViewDataSource, CustomDeviceCellDelegate>

@property(nonatomic, strong) CBCentralManager *centralManager;

@property(nonatomic, strong) UILabel *bleStateLabel;
@property(nonatomic, strong) UIButton *scanBtn;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITextView *textView;

@property(nonatomic, strong) QNBleApi *bleApi;

@property(nonatomic, strong) NSMutableArray<QNBleDevice *> *scanDeviceList;

@property(nonatomic, strong) NSMutableArray<QNBleDevice *> *connectedDeviceList;

@property(nonatomic, strong) NSString *info;

@end

@implementation CustomBleManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"蓝牙自主管理";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.scanDeviceList = [NSMutableArray<QNBleDevice *> array];
    self.connectedDeviceList = [NSMutableArray<QNBleDevice *> array];
    [self createUI];
    self.centralManager =  [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey : @YES}];
    self.bleApi = [QNBleApi sharedBleApi];
    self.bleApi.dataListener = self;
    self.bleApi.connectionChangeListener = self;
    self.info = @"";
}

- (void)setInfo:(NSString *)info {
    _info = info;
    self.textView.text = info;
}

- (void)createUI {
    self.bleStateLabel = [[UILabel alloc] init];
    self.bleStateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.bleStateLabel];
    [self.bleStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    self.scanBtn = [[UIButton alloc] init];
    self.scanBtn.layer.borderColor = UIColor.blueColor.CGColor;
    self.scanBtn.layer.borderWidth = 1.0f;
    self.scanBtn.layer.cornerRadius = 5.0f;
    [self.scanBtn addTarget:self action:@selector(scanHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.scanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.scanBtn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    [self.scanBtn setTitle:@"开始扫描" forState:UIControlStateNormal];
    [self.scanBtn setTitle:@"停止扫描" forState:UIControlStateSelected];
    [self.view addSubview:self.scanBtn];
    [self.scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.top.equalTo(self.bleStateLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
        make.trailing.mas_equalTo(-10);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.estimatedRowHeight = 46;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanBtn.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_centerY).offset(40);
    }];
        
    self.textView = [[UITextView alloc] init];
    self.textView.editable = NO;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom).offset(10);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.textView.mas_top);
        make.height.mas_equalTo(1);
    }];
}

- (void)scanHandler:(UIButton *)sender {
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        sender.selected = NO;
        [self.view makeToast:@"蓝牙开启"];
        return;
    }
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        [self.scanDeviceList removeAllObjects];
        [self.scanDeviceList addObjectsFromArray:self.connectedDeviceList];
        [self.tableView reloadData];
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    } else {
        [self.centralManager stopScan];
    }
}

#pragma mark -
- (void)connectDevice:(QNBleDevice *)device {
    for (QNBleDevice *item in self.connectedDeviceList) {
        if ([device.mac isEqualToString:item.mac]) {
            self.info = [NSString stringWithFormat:@"%@ 设备发起连接失败，该设备已连接\n%@ ",device.mac, self.info];
            return;
        }
    }
    self.info = [NSString stringWithFormat:@"%@ 设备发起连接\n%@",device.mac, self.info];
    [self.connectedDeviceList addObject:device];
    [self.centralManager connectPeripheral:device.peripheral options:nil];
    [self.tableView reloadData];
}

#pragma mark - QNBleProtocolDelegate
- (void)writeCharacteristicValue:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID data:(NSData *)data device:(QNBleDevice *)device {
    QNBleDevice *bleDevice = nil;
    CBCharacteristic *characteristic = nil;
    for (QNBleDevice *item in self.connectedDeviceList) {
        if ([item.mac isEqualToString:device.mac]) {
            bleDevice = item;
            break;
        }
    }
    
    if ([bleDevice.ffe3Write.UUID.UUIDString isEqualToString:characteristicUUID]) {
        characteristic = bleDevice.ffe3Write;
    } else if ([bleDevice.ffe4Write.UUID.UUIDString isEqualToString:characteristicUUID]) {
        characteristic = bleDevice.ffe4Write;
    } else if ([bleDevice.fff2Write.UUID.UUIDString isEqualToString:characteristicUUID]) {
        characteristic = bleDevice.fff2Write;
    }
    
    if (bleDevice == nil || characteristic == nil) return;

    if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) {
        [bleDevice.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
    } else {
        [bleDevice.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)readCharacteristicValue:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID device:(QNBleDevice *)device {
    QNBleDevice *bleDevice = nil;
    CBCharacteristic *characteristic = nil;
    for (QNBleDevice *item in self.connectedDeviceList) {
        if ([item.mac isEqualToString:device.mac]) {
            bleDevice = item;
            break;
        }
    }
    
    if ([bleDevice.ffe3Write.UUID.UUIDString isEqualToString:characteristicUUID]) {
        characteristic = bleDevice.ffe3Write;
    } else if ([bleDevice.ffe4Write.UUID.UUIDString isEqualToString:characteristicUUID]) {
        characteristic = bleDevice.ffe4Write;
    } else if ([bleDevice.fff2Write.UUID.UUIDString isEqualToString:characteristicUUID]) {
        characteristic = bleDevice.fff2Write;
    }
    
    if (bleDevice == nil || characteristic == nil) return;
    [bleDevice.peripheral readValueForCharacteristic:characteristic];
}

#pragma mark - QNScaleDataListener
- (void)onGetUnsteadyWeight:(QNBleDevice *)device weight:(double)weight {
    self.info = [NSString stringWithFormat:@"%@ 体重: %.2f\n%@", device.mac, weight, self.info];
}

- (void)onGetScaleData:(QNBleDevice *)device data:(QNScaleData *)scaleData {
    NSString *info = [device.mac stringByAppendingString:@" 测量结果:"];
    NSArray<QNScaleItemData *> *itemDataList = [scaleData getAllItem];
    for (QNScaleItemData *item in itemDataList) {
        info = [NSString stringWithFormat:@"%@ %@: %.2f", info, item.name, item.value];
    }
    self.info = [NSString stringWithFormat:@"%@\n%@", info, self.info];
}

- (void)onGetStoredScale:(QNBleDevice *)device data:(NSArray<QNScaleStoreData *> *)storedDataList {
    
}

- (void)onGetElectric:(NSUInteger)electric device:(QNBleDevice *)device {
    
}

- (void)onScaleStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state {
    NSString *stateStr = @"";
    switch (state) {
        case QNScaleStateStartMeasure: stateStr = @"正在测量"; break;
        case QNScaleStateRealTime: stateStr = @"测量体重"; break;
        case QNScaleStateBodyFat: stateStr = @"测量生物阻抗"; break;
        case QNScaleStateHeartRate: stateStr = @"测量心率"; break;
        case QNScaleStateMeasureCompleted: stateStr = @"测量完成"; break;
        default:
            break;
    }
    self.info = [NSString stringWithFormat:@"%@ %@\n%@", device.mac, stateStr, self.info];
}

- (void)onScaleEventChange:(QNBleDevice *)device scaleEvent:(QNScaleEvent)scaleEvent {
    
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

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    self.bleStateLabel.text = central.state == CBCentralManagerStatePoweredOn ? @"蓝牙已开启" : @"蓝牙未开启";
    if (central.state != CBCentralManagerStatePoweredOn) {
        self.scanBtn.selected = NO;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    QNBleDevice *device = [self.bleApi buildDevice:peripheral rssi:RSSI advertisementData:advertisementData callback:^(NSError *error) {
        //自行处理错误，一般为参数
    }];
    
    if (device == nil) return;
    for (QNBleDevice *item in self.scanDeviceList) {
        if ([item.mac isEqualToString:device.mac]) {
            return;
        }
    }
    device.peripheral = peripheral;
    [self.scanDeviceList addObject:device];
    [self.tableView reloadData];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    QNBleDevice *bleDevice = nil;
    for (QNBleDevice *device in self.connectedDeviceList) {
        if ([device.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            bleDevice = device;
            break;;
        }
    }
    if (bleDevice == nil) return;
    self.info = [NSString stringWithFormat:@"%@ 设备断开连接\n%@", bleDevice.mac, self.info];
    [self.connectedDeviceList removeObject:bleDevice];
    [self.tableView reloadData];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    QNBleDevice *bleDevice = nil;
    for (QNBleDevice *device in self.connectedDeviceList) {
        if ([device.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            bleDevice = device;
            return;
        }
    }
    if (bleDevice == nil) return;
    self.info = [NSString stringWithFormat:@"%@ 设备连接失败\n%@", bleDevice.mac, self.info];
    [self.connectedDeviceList removeObject:bleDevice];
    [self.tableView reloadData];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    for (QNBleDevice *device in self.connectedDeviceList) {
        if ([device.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            self.info = [NSString stringWithFormat:@"%@ 设备连接成功\n%@",device.mac, self.info];
            device.handler = [self.bleApi buildProtocolHandler:device user:self.user wifiConfig:nil delegate:self callback:^(NSError *error) {
                            
            }];
            peripheral.delegate = self;
            [peripheral discoverServices:nil];
            return;
        }
    }
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    QNBleDevice *device = nil;
    for (QNBleDevice *item in self.connectedDeviceList) {
        if ([item.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            device = item;
            break;
        }
    }
    if (device == nil) return;
    
    if ([service.UUID.UUIDString isEqualToString:KScaleDeviceServiceUUID]) {
        [device.handler prepare:KScaleDeviceServiceUUID];
    } else if ([service.UUID.UUIDString isEqualToString:KScale1SerivceUUID]) {
        [device.handler prepare:KScale1SerivceUUID];
    }
    
    for (CBCharacteristic *item in service.characteristics) {
        if ([item.UUID.UUIDString isEqualToString:KScaleDeviceCharacteristicUUIDWrite]) {
            device.ffe3Write = item;
        } else if ([item.UUID.UUIDString isEqualToString:KScaleDeviceCharacteristicUUIDStorageWrite]) {
            device.ffe4Write = item;
        } else if ([item.UUID.UUIDString isEqualToString:KScale1CharacteristicUUIDWrite]) {
            device.fff2Write = item;
        } else if ([item.UUID.UUIDString isEqualToString:KScaleDeviceCharacteristicUUIDNotify]) {
            [peripheral setNotifyValue:YES forCharacteristic:item];
        } else if ([item.UUID.UUIDString isEqualToString:KScaleDeviceCharacteristicUUIDIndicate]) {
            [peripheral setNotifyValue:YES forCharacteristic:item];
        } else if ([item.UUID.UUIDString isEqualToString:KScale1CharacteristicUUIDNotify]) {
            [peripheral setNotifyValue:YES forCharacteristic:item];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    QNBleDevice *device = nil;
    for (QNBleDevice *item in self.connectedDeviceList) {
        if ([item.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            device = item;
            break;
        }
    }
    if (device != nil) {
        [device.handler onGetBleData:characteristic.service.UUID.UUIDString characteristicUUID:characteristic.UUID.UUIDString data:characteristic.value];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"写入数据失败 %@", error);
    } else {
        NSLog(@"写入数据成功");
    }
}

#pragma mark - UITableViewDelegate、UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.scanDeviceList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCellIdentifier"];
    if (cell == nil) {
        cell = [[CustomDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCellIdentifier"];
    }
    cell.delegate = self;
    cell.device = self.scanDeviceList[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 41;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QNBleDevice *device = self.scanDeviceList[indexPath.row];
    [self connectDevice:device];
}

#pragma mark - CustomDeviceCellDelegate
- (void)disconnectDevice:(QNBleDevice *)device {
    if (device.peripheral) {
        [self.centralManager cancelPeripheralConnection:device.peripheral];
    }
}

@end
