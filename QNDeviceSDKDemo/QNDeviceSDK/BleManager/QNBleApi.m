//
//  QNBleApi.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNBleApi.h"
#import "QNCentralModule.h"
#import "QNPScaleModule.h"

#import "QNDebug.h"
#import "NSError+QNAPI.h"
#import "QNAPIConst.h"
#import "QNScaleData.h"
#import "QNScaleData+QNResultData.h"
#import "QNScaleStoreData.h"
#import "QNScaleStoreData+QNResultData.h"
#import "QNBleDevice+Addittion.h"
#import "QNResultData.h"
#import "QNUser+QNAddition.h"
#import "QNUnitTool.h"
#import "QNFileManage.h"
#import "QNAESCrypt.h"
#import "QNNetwork.h"
#import "QNDataTool.h"
#import "QNUser+QNAddition.h"
#import "QNBandManager+QNAddition.h"

@interface FilterDevice : NSObject

@property (nonatomic, strong) QNBleDevice *device;

@property (nonatomic, assign) int scanNum;

@end

@implementation FilterDevice

@end

@interface QNBleApi ()<QNCentralManagerDelegate,QNPScaleDelegate,QNBandDelegate>
/** 蓝牙管理类 */
@property (nonatomic, strong) QNCentralManager *centralManager;
/** 设备管理 */
@property (nonatomic, strong) QNPScaleManager *scaleManager;
/** 手环管理类 */
@property (nonatomic, strong) QNBandManager *bandManager;
/** calendar */
@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) QNBleDevice *connectScaleDevice;

@property (nonatomic, strong) QNBleDevice *connectBandDevice;

@property (nonatomic, strong) QNUser *scaleUser;

@property (nonatomic, strong) NSTimer *scanTimer;

@property (nonatomic, assign) BOOL requsetUpdateSdkConfigFlag;

//过滤数据
@property (nonatomic, strong) NSMutableDictionary<NSString *, FilterDevice *> *filtDeviceInfo;

/** 储存数据临时保存数据 */
@property (nonatomic, strong) NSMutableArray<QNScaleStoreData *> *storageAll;

@end

@implementation QNBleApi
static QNBleApi *bleApi = nil;

+ (void)setDebug:(BOOL)debug {
    QNDebug.debug = debug;
    QNCentralManager.debug = debug;
    QNPScaleManager.logPrefix = YES;
    QNWristManager.logPrefix = YES;
}

+ (BOOL)debug {
    return QNDebug.debug;
}

- (NSCalendar *)calendar {
    if (_calendar == nil) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (NSMutableArray<QNScaleStoreData *> *)storageAll {
    if (_storageAll == nil) {
        _storageAll = [NSMutableArray array];
    }
    return _storageAll;
}

- (NSMutableDictionary<NSString *,FilterDevice *> *)filtDeviceInfo {
    if (_filtDeviceInfo == nil) {
        _filtDeviceInfo = [NSMutableDictionary<NSString *,FilterDevice *> dictionary];
    }
    return _filtDeviceInfo;
}

+ (QNBleApi *)sharedBleApi {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bleApi = [QNBleApi alloc];
    });
    return bleApi;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        QNCentralManager.logHeader = QNDEBUG_IDENTIFIER;
        QNPScaleManager.logPrefix = YES;
        bleApi = [[super allocWithZone:zone] init];
    });
    return bleApi;
}

#pragma mark 初始化SDK
- (void)initSdk:(NSString *)appId firstDataFile:(NSString *)dataFile callback:(QNResultCallback)callback {
    
    [[QNDebug sharedDebug] log:[NSString stringWithFormat:@"<initSdk> appid: %@  dataFile: %@",appId,dataFile]];
    if (dataFile == nil || ![[QNFileManage sharedFileManager] fileExistsAtPath:dataFile]){
        if (callback) callback([NSError errorCode:QNBleErrorCodeFirstDataFileURL]);
        return;
    }
    QNSDKConfig *sdkConfig = [[QNFileManage sharedFileManager] sdkConfig];
    if (sdkConfig.code != 50000) {
        [[QNFileManage sharedFileManager] updateSdkConfigForFilePath:dataFile];
    }
    if (appId == nil || ![appId isKindOfClass:[NSString class]] || ![[[QNFileManage sharedFileManager] verifyAppid] isEqualToString:appId]) {
        if (callback) callback([NSError errorCode:QNBleErrorCodeIllegalArgument]);
        return;
    }
    
    if (sdkConfig.serverType == 0) {
        if (self.requsetUpdateSdkConfigFlag == NO || [[QNFileManage sharedFileManager] lastRequestUpdateSDKConfigFromServiceTime] != [[QNDataTool sharedDataTool] currentDaynumSince1970]) {
            __weak typeof(self) weakself = self;
            [QNNetwork registerSDKAppid:appId response:^(NSDictionary *result, NSError *error) {
                if (result) {
                    weakself.requsetUpdateSdkConfigFlag = YES;
                    [[QNFileManage sharedFileManager] saveRequsetUpdateSdkConfigTime:[[QNDataTool sharedDataTool] currentDaynumSince1970]];
                    [[QNFileManage sharedFileManager] updateSdkConfigForDic:result];
                }
            }];
        }
    }
    QNConfig *config = [self getConfigWithPrivate:YES];
    if (self.centralManager == nil) {
        self.centralManager = [[QNCentralManager alloc] initCentralManager:nil showPowerAlertFlag:config.showPowerAlertKey queue:nil];
        self.centralManager.delegate = self;
    }
    
    if (self.scaleManager == nil) {
        self.scaleManager = [[QNPScaleManager alloc] initWithCentralManager:self.centralManager];
        self.scaleManager.delegate = self;
    }
    
    if (self.bandManager == nil) {
        self.bandManager = [[QNBandManager alloc] initWithCentralManager:self.centralManager delegate:self];
    }
    
    if (callback) callback(nil);
}

#pragma mark 开始扫描
- (void)startBleDeviceDiscovery:(QNResultCallback)callback {
    [[QNDebug sharedDebug] log:@"<startBleDeviceDiscovery>"];
    NSError *checkoutError = [[QNDataTool sharedDataTool] checkoutUseLimit];
    if (checkoutError) {
        //不允许使用
        if (callback) callback(checkoutError);
        return;
    }
    
    if (self.discoveryListener == nil) {
        if (callback) callback([NSError errorCode:QNBleErrorCodeMissDiscoveryListener]);
        return;
    }
    QNConfig *config = [self getConfigWithPrivate:YES];
    __weak typeof(self) weakSelf = self;
    [self.centralManager scanDeviceHandle:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            [weakSelf.filtDeviceInfo removeAllObjects];
            if (QNDelegate(weakSelf.discoveryListener,onStartScan)) {
                [weakSelf.discoveryListener onStartScan];
            }
            if (callback) callback(nil);
            if (config.duration > 0) {
                [weakSelf createScanTimerWithTimeInterval:config.duration / 1000.0];
            }
        }else {
            if (callback) callback([NSError transformModuleError:error]);
        }
    }];
}

- (void)createScanTimerWithTimeInterval:(NSTimeInterval)timeInterval {
    [self cancelScanTimer];
    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(stopScan) userInfo:nil repeats:NO];
}

- (void)cancelScanTimer {
    if (self.scanTimer) {
        [self.scanTimer setFireDate:[NSDate distantFuture]];
        [self.scanTimer invalidate];
        self.scanTimer = nil;
    }
}

- (void)findPairBandWithMac:(NSString *)mac modeId:(NSString *)modeId uuidIdentifier:(NSString *)uuidIdentifier callback:(QNResultCallback)callback {
    [[QNDebug sharedDebug] log:@"<findPairBand>"];
    NSError *checkoutError = [[QNDataTool sharedDataTool] checkoutUseLimit];
    if (checkoutError) {
        //不允许使用
        if (callback) callback(checkoutError);
        return;
    }
    
    if (self.discoveryListener == nil) {
        if (callback) callback([NSError errorCode:QNBleErrorCodeMissDiscoveryListener]);
        return;
    }
    [self.bandManager.wristManager findSystemPairBandDeviceWithMac:mac internalModel:modeId uuidIdentifier:uuidIdentifier Response:^(BOOL success, NSError * _Nullable error) {
        if (callback) callback([NSError transformModuleError:error]);
    }];
}

- (void)stopScan {
    [self.centralManager stopScanDevice];
    if (QNDelegate(self.discoveryListener,onStopScan)) {
        [self.discoveryListener onStopScan];
    }
}


#pragma mark 停止扫描
- (void)stopBleDeviceDiscorvery:(QNResultCallback)callback {
    [[QNDebug sharedDebug] log:@"<stopBleDeviceDiscorvery>"];
    [self cancelScanTimer];
    [self stopScan];
    if (callback) callback(nil);
}

#pragma mark 连接设备
- (void)connectDevice:(QNBleDevice *)device user:(QNUser *)user callback:(QNResultCallback)callback {
    [[QNDebug sharedDebug] log:@"<connectDevice>"];
    NSError *checkoutError = [[QNDataTool sharedDataTool] checkoutUseLimit];
    if (checkoutError) {
        //不允许使用
        if (callback) callback(checkoutError);
        return;
    }
    if (self.dataListener == nil && device.deviceType == QNDeviceScale) {
        if (callback) callback([NSError errorCode:QNBleErrorCodeMissDataListener]);
        return;
    }

    QNConfig *localConfig = [self getConfigWithPrivate:YES];
    
    if (device.deviceType == QNDeviceBand) {
        self.connectBandDevice = device;
        [self.bandManager.wristManager connectBandDevice:device.bandDevice configBlock:^(QNConnectConfig * _Nonnull config) {
            config.connectOverTime = config.connectOverTime;
        } response:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                if (callback) callback(nil);
            }else {
                NSError *errorTemp = [NSError transformModuleError:error];
                if (callback) callback(errorTemp);
            }
        }];
        return;
    }
    
    NSError *userError = [QNUser checkUser:user deviceType:device.deviceType];
    if (userError) {
        if (callback) callback(userError);
        return;
    }
    
    self.connectScaleDevice = device;
    self.scaleUser = user;
    QNPUser *puser = [QNPUser userHeight:user.height gender:[user.gender isEqualToString:@"female"] ? QNPUserGenderFemale : QNPUserGenderMale age:user.age];
    
    [self.storageAll removeAllObjects];
    [self.scaleManager connectScaleDevice:device.scaleDevice user:puser wifiConifg:nil configBlock:^(QNConnectConfig * _Nonnull config, QNPScaleUnitMode * _Nonnull unitMode) {
        config.connectOverTime = config.connectOverTime;
        switch (localConfig.unit) {
            case QNUnitLB:
                *unitMode = QNPScaleUnitLB;
                break;
                
            case QNUnitJIN:
                *unitMode = QNPScaleUnitJin;
                break;
                
            case QNUnitST:
                *unitMode = QNPScaleUnitST;
                break;
                
            default:
                *unitMode = QNPScaleUnitKG;
                break;
        }
    } response:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            if (callback) callback(nil);
        }else {
            NSError *errorTemp = [NSError transformModuleError:error];
            if (callback) callback(errorTemp);
        }
    }];
}

#pragma mark 断开设备的连接
- (void)disconnectDevice:(QNBleDevice *)device callback:(nullable QNResultCallback)callback {
    [[QNDebug sharedDebug] log:@"<disconnectDevice>"];
    if (device.deviceType == QNDeviceBand) {
        [self.bandManager.wristManager cancelConnectBandDevice];
    }else {
        [self.scaleManager cancelConnectScaleDevice];
    }
    if (callback) callback(nil);
}

#pragma mark 获取SDK的当前设置情况
- (QNConfig *)getConfigWithPrivate:(BOOL)private {
    if (private == NO) {
        [[QNDebug sharedDebug] log:@"<getConfig>"];
    }
    return [[QNFileManage sharedFileManager] config];
}

- (QNConfig *)getConfig {
    return [self getConfigWithPrivate:NO];
}

#pragma mark 根据提供的kg数值的体重，转化为指定单位的数值
- (double)convertWeightWithTargetUnit:(double)kgWeight unit:(QNUnit)unit {
    return [QNUnitTool convertWeightWithTargetUnit:kgWeight unit:unit];
}

#pragma mark 用户模型的建立
- (QNUser *)buildUser:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday callback:(QNResultCallback)callback {
    return [[QNUser alloc] initWithUser:userId height:height gender:gender birthday:birthday athleteType:YLAthleteDefault shapeType:YLUserShapeNone goalType:YLUserGoalNone weight:0 callback:callback];
}

#pragma mark 手环管理类
- (QNBandManager *)getBandManager {
    NSError *checkoutError = [[QNDataTool sharedDataTool] checkoutUseLimit];
    if (checkoutError) {
        //不允许使用
        return nil;
    }
    return self.bandManager;
}

#pragma mark -
#pragma mark QNBLEManagerScaleDataSource
- (void)publicScaleReceiveRealTimeWeight:(double)weight connectedDevice:(QNPScaleDevice *)device {
    if (QNDelegate(self.dataListener,onGetUnsteadyWeight:weight:)) {
        [self.dataListener onGetUnsteadyWeight:self.connectScaleDevice weight:weight];
    }
}

- (void)publicScaleReceiveResultData:(QNPScaleData *)scaleData connectedDevice:(QNPScaleDevice *)device {
    QNResultData *resultData = [[QNResultData alloc] init];
    resultData.resistance = (int)scaleData.resistance;
    resultData.secResistance = (int)scaleData.secResistance;
    resultData.supportHeartRate = device.supportHeartRateFlag;
    resultData.supportCharge = device.supportChargeFlag;
    
    resultData.bodyIndexFlag = self.connectScaleDevice.deviceMessage.bodyIndexFlag;
    resultData.method = self.connectScaleDevice.deviceMessage.method;
    resultData.user = self.scaleUser;
    resultData.weight = scaleData.weight;
    resultData.heartRate = (int)scaleData.heartRate;
    resultData.timeTemp = scaleData.timeTemp;
    //计算结果值
    [resultData reckonMeasureResult];
    
    QNScaleData *scaleDataResult = [[QNScaleData alloc] init];
    scaleDataResult.resultData = resultData;
    if (self.scaleUser) {
        [scaleDataResult setValue:self.scaleUser forKeyPath:@"user"];
    }
    NSDate *measureDate = [NSDate dateWithTimeIntervalSince1970:scaleData.timeTemp];
    if (measureDate) {
        [scaleDataResult setValue:measureDate forKeyPath:@"measureTime"];
    }
    
    if (QNDelegate(self.dataListener,onGetScaleData:data:)) {
        [self.dataListener onGetScaleData:self.connectScaleDevice data:scaleDataResult];
    }
}

- (void)publicScaleReceiveStorageData:(QNPScaleStorageData *)storageScaleData connectedDevice:(QNPScaleDevice *)device {
    QNScaleStoreData *scaleStoreData = [[QNScaleStoreData alloc] init];
    QNResultData *resultData = [[QNResultData alloc] init];
    scaleStoreData.resultData = resultData;
    resultData.resistance = (int)storageScaleData.resistance;
    resultData.secResistance = (int)storageScaleData.secResistance;
    resultData.supportHeartRate = device.supportHeartRateFlag;
    resultData.supportCharge = device.supportChargeFlag;
    
    resultData.bodyIndexFlag = self.connectScaleDevice.deviceMessage.bodyIndexFlag;
    resultData.method = self.connectScaleDevice.deviceMessage.method;
    resultData.weight = storageScaleData.weight;
    resultData.heartRate = (int)storageScaleData.heartRate;
    resultData.timeTemp = storageScaleData.timeTemp;
    [self.storageAll addObject:scaleStoreData];
    
    
    [scaleStoreData setValue:[NSNumber numberWithFloat:storageScaleData.weight] forKeyPath:@"weight"];
    NSDate *measureDate = [NSDate dateWithTimeIntervalSince1970:storageScaleData.timeTemp];
    if (measureDate) {
        [scaleStoreData setValue:measureDate forKeyPath:@"measureTime"];
    }
    if (storageScaleData.curCNT == storageScaleData.total) {
        if (QNDelegate(self.dataListener,onGetStoredScale:data:)) {
            [self.dataListener onGetStoredScale:self.connectScaleDevice data:[self.storageAll mutableCopy]];
        }
    }
}

- (QNPScaleReplayData *)publicScaleRequestRelayDataForMeasureData:(QNPScaleData *)scaleData connectedDevice:(QNPScaleDevice *)device {
    QNResultData *resultData = [[QNResultData alloc] init];
    resultData.resistance = (int)scaleData.resistance;
    resultData.secResistance = (int)scaleData.secResistance;
    resultData.supportHeartRate = device.supportHeartRateFlag;
    resultData.supportCharge = device.supportChargeFlag;
    
    resultData.bodyIndexFlag = self.connectScaleDevice.deviceMessage.bodyIndexFlag;
    resultData.method = self.connectScaleDevice.deviceMessage.method;
    resultData.user = self.scaleUser;
    resultData.weight = scaleData.weight;
    resultData.heartRate = (int)scaleData.heartRate;
    //计算结果值
    [resultData reckonMeasureResult];
    
    QNPScaleReplayData *replayData = [[QNPScaleReplayData alloc] init];
    replayData.bodyFat = resultData.bodyfatRate;
    replayData.BMI = resultData.BMI;
    replayData.bodyFatLevel = QNScaleBodyFatLevelStand;
    replayData.BMILevel = QNScaleBMILevelStand;
    return replayData;
}


- (void)publicScaleChangeToScaleState:(QNPScaleState)scaleState connectedDevice:(QNPScaleDevice *)device error:(NSError *)error {
    QNScaleState qnScaleState = QNScaleStateDisconnected;
    switch (scaleState) {
        case QNPScaleStateConnecting:
            qnScaleState = QNScaleStateConnecting;
            if (QNDelegate(self.connectionChangeListener,onConnecting:)) {
                [self.connectionChangeListener onConnecting:self.connectScaleDevice];
            }
            break;
            
        case QNPScaleStateConnectFail:
            qnScaleState = QNScaleStateLinkLoss;
            if (QNDelegate(self.connectionChangeListener,onConnectError:error:)) {
                [self.connectionChangeListener onConnectError:self.connectScaleDevice error:[NSError transformModuleError:error]];
            }
            break;
            
        case QNPScaleStateConnected:
            qnScaleState = QNScaleStateConnected;
            if (QNDelegate(self.connectionChangeListener,onConnected:)) {
                [self.connectionChangeListener onConnected:self.connectScaleDevice];
            }
            break;
            
        case QNPScaleStateDiscoverServices:
            if (QNDelegate(self.connectionChangeListener,onServiceSearchComplete:)) {
                [self.connectionChangeListener onServiceSearchComplete:self.connectScaleDevice];
            }
            break;
            
        case QNPScaleStateDiscoverCharacteristics:
            
            break;
            
        case QNPScaleStateStartInteraction:
            qnScaleState = QNScaleStateStartMeasure;
            break;
            
        case QNPScaleStateRealTime:
            qnScaleState = QNScaleStateRealTime;
            break;
            
        case QNPScaleStateBodyFat:
            qnScaleState = QNScaleStateBodyFat;
            break;
            
        case QNPScaleStateHeartRate:
            qnScaleState = QNScaleStateHeartRate;
            break;
            
        case QNPScaleStateMeasureComplete:
            qnScaleState = QNScaleStateMeasureCompleted;
            if (QNDelegate(self.connectionChangeListener,onDisconnecting:)) {
                [self.connectionChangeListener onDisconnecting:self.connectScaleDevice];
            }
            break;
            
        case QNPScaleStateDisconected:
            qnScaleState = QNScaleStateLinkLoss;
            break;
        default:
            break;
    }
    if (QNDelegate(self.connectionChangeListener,onDeviceStateChange:scaleState:)) {
        [self.connectionChangeListener onDeviceStateChange:self.connectScaleDevice scaleState:qnScaleState];
    }
}

- (void)publicScaleReceiveElectric:(NSUInteger)electric connectedDevice:(QNPScaleDevice *)device {
    if (QNDelegate(self.dataListener,onGetElectric:device:)) {
        [self.dataListener onGetElectric:electric device:self.connectScaleDevice];
    }
}

- (void)publicScaleLowElectricConnectedDevice:(QNPScaleDevice *)device {
    
}

#pragma mark - QNBandDelegate
- (void)bandDevice:(QNBandDevice *)device changeToBandState:(QNBandState)bandState error:(NSError *)error {
    QNScaleState qnScaleState = QNScaleStateDisconnected;
    switch (bandState) {
        case QNBandStateConnecting:
            qnScaleState = QNScaleStateConnecting;
            if (QNDelegate(self.connectionChangeListener,onConnecting:)) {
                [self.connectionChangeListener onConnecting:self.connectBandDevice];
            }
            break;
            
        case QNBandStateConnectFail:
            qnScaleState = QNScaleStateLinkLoss;
            if (QNDelegate(self.connectionChangeListener,onConnectError:error:)) {
                [self.connectionChangeListener onConnectError:self.connectBandDevice error:[NSError transformModuleError:error]];
            }
            break;
            
        case QNBandStateConnected:
            qnScaleState = QNScaleStateConnected;
            if (QNDelegate(self.connectionChangeListener,onConnected:)) {
                [self.connectionChangeListener onConnected:self.connectBandDevice];
            }
            break;
            
        case QNBandStateDiscoverServices:
            if (QNDelegate(self.connectionChangeListener,onServiceSearchComplete:)) {
                [self.connectionChangeListener onServiceSearchComplete:self.connectBandDevice];
            }
            break;
            
        case QNBandStateDiscoverCharacteristics:
            
            break;
            
        case QNBandStateStartInteraction:
            qnScaleState = QNScaleStateInteraction;
            break;
            
        case QNBandStateDisconnected:
            qnScaleState = QNScaleStateLinkLoss;
            break;
        default:
            break;
    }
    if (qnScaleState == QNScaleStateDisconnected) return;
    if (QNDelegate(self.connectionChangeListener,onDeviceStateChange:scaleState:)) {
        [self.connectionChangeListener onDeviceStateChange:self.connectBandDevice scaleState:qnScaleState];
    }
    
}

- (void)triggerCarmen:(QNBandDevice *)device {
    if (QNDelegate(self.dataListener, strikeTakePhotosWithDevice:)) {
        [self.dataListener strikeTakePhotosWithDevice:self.connectBandDevice];
    }
}

- (void)triggerFindPhone:(QNBandDevice *)device {
    if (QNDelegate(self.dataListener, strikeFindPhoneWithDevice:)) {
        [self.dataListener strikeFindPhoneWithDevice:self.connectBandDevice];
    }
}

#pragma mark - discoveryDevice
- (void)discoverPublicScaleDevice:(QNPScaleDevice *)device {
    [self filterDevice:device];
}

- (void)discoverBandDevice:(QNBandDevice *)device {
    [self filterDevice:device];
}

- (void)filterDevice:(id)device {
    
    QNBleDevice *bleDevice = [QNBleDevice createQNBleDeviceForDevice:device];
    
    if (bleDevice == nil) return;
    
    QNConfig *localConfig = [self getConfigWithPrivate:YES];
    
    if (localConfig.scanType == QNScanScale && bleDevice.deviceType == QNDeviceBand) return;
    if (localConfig.scanType == QNScanBand && bleDevice.deviceType == QNDeviceScale) return;
    
    if (bleDevice.deviceType == QNDeviceScale) {
        if (localConfig.onlyScreenOn && bleDevice.screenOn == NO) {
            return;
        }
    }
    
    if (localConfig.allowDuplicates) {
        if (bleDevice && QNDelegate(self.discoveryListener,onDeviceDiscover:)) {
            [self.discoveryListener onDeviceDiscover:bleDevice];
        }
    }else {
        FilterDevice *fDevice = nil;
        if ([self.filtDeviceInfo.allKeys containsObject:bleDevice.mac]) {
            fDevice = (FilterDevice *)self.filtDeviceInfo[bleDevice.mac];
        }
        if (fDevice == nil) {
            FilterDevice *fDevice = [[FilterDevice alloc] init];
            fDevice.device = bleDevice;
            fDevice.scanNum = 1;
            [self.filtDeviceInfo setObject:fDevice forKey:bleDevice.mac];
        }else{
            if (fDevice.device.screenOn != bleDevice.screenOn) {
                [self.filtDeviceInfo removeObjectForKey:bleDevice.mac];
            }else{
                fDevice.device = bleDevice;
                fDevice.scanNum ++;
                if (fDevice.scanNum == 3) {
                    if (bleDevice && QNDelegate(self.discoveryListener,onDeviceDiscover:)) {
                        [self.discoveryListener onDeviceDiscover:bleDevice];
                    }
                }
            }
        }
    }
}

#pragma mark - QNBLEManagerDelegate
- (void)centralManagerBlueToothUpdateState:(QNBlueToothState)state{
    if (state != QNBlueToothStatePoweredOn) {
        [self cancelScanTimer];
    }
    
    if (QNDelegate(self.bleStateListener,onBleSystemState:)) {
        QNBLEState state = QNBLEStateUnknown;
        switch (state) {
            case QNBlueToothStateResetting:
                state = QNBLEStateResetting;
                break;
                
            case QNBlueToothStateUnsupported:
                state = QNBLEStateUnsupported;
                break;
                
            case QNBlueToothStateUnauthorized:
                state = QNBLEStateUnauthorized;
                break;
                
            case QNBlueToothStatePoweredOff:
                state = QNBLEStatePoweredOff;
                break;
                
            case QNBlueToothStatePoweredOn:
                state = QNBLEStatePoweredOn;
                break;
            default:
                break;
        }
        [self.bleStateListener onBleSystemState:state];
    }
}
@end

