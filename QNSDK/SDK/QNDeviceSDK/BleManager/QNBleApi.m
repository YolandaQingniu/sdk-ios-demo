//
//  QNBleApi.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNBleApi.h"
#import "QNBleApi+NormalDevice.h"
#import "QNBleApi+BroadcastDevice.h"
#import "QNBleApi+WspDevice.h"
#import "QNBleApi+HeightWeight.h"
#import "QNNetwork.h"
#import "QNConfig+QNAddition.h"
#import "QNBleBroadcastDevice+QNAddition.h"
#import "QNBleProtocolHandler+QNAddition.h"
#import "QNScaleData+QNAddition.h"
#import "QNAESCrypt.h"

@interface FilterDevice : NSObject

@property (nonatomic, strong) QNBleDevice *device;

@property (nonatomic, assign) int scanNum;

@end

@implementation FilterDevice

@end

@interface QNBleApi ()

@property (nonatomic, assign) BOOL requestUpdateSdkConfigFlag;
//过滤数据
@property (nonatomic, strong) NSMutableDictionary<NSString *, FilterDevice *> *filtDeviceInfo;
/** 已经注册的设备 */
@property (nonatomic, strong) NSMutableArray<NSString *> *registerDevices;

@property(nonatomic, strong) NSCalendar *calendar;

@end

@implementation QNBleApi
static QNBleApi *bleApi = nil;

+ (void)setDebug:(BOOL)debug {
    QNDebug.debug = debug;
    QNCentralManager.debug = debug;
}

+ (BOOL)debug {
    return QNDebug.debug;
}

- (NSMutableDictionary<NSString *,FilterDevice *> *)filtDeviceInfo {
    if (_filtDeviceInfo == nil) {
        _filtDeviceInfo = [NSMutableDictionary<NSString *,FilterDevice *> dictionary];
    }
    return _filtDeviceInfo;
}

- (NSMutableArray<NSString *> *)registerDevices {
    if (_registerDevices == nil) {
        _registerDevices = [NSMutableArray<NSString *> array];
    }
    return _registerDevices;
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
        QNCentralManager.logPrefix = YES;
        QNCentralManager.sdkFlag = YES;
        bleApi = [[super allocWithZone:zone] init];
        bleApi.calendar = [NSCalendar currentCalendar];
    });
    return bleApi;
}

#pragma mark - 初始化SDK
- (void)initSdk:(NSString *)appId firstDataFile:(NSString *)dataFile callback:(QNResultCallback)callback {
    [[QNDebug sharedDebug] log:[NSString stringWithFormat:@"<initSdk> appid: %@  dataFile: %@",appId,dataFile]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataFile]){
        [NSError errorCode:QNBleErrorCodeFirstDataFileURL callBack:callback];
        return;
    }
    NSError *error = nil;
    NSString *dataFileContent = [NSString stringWithContentsOfFile:dataFile encoding:NSUTF8StringEncoding error:&error];
    [self initSdk:appId dataFileContent:dataFileContent callback:callback];
}


- (void)initSdk:(NSString *)appId dataFileContent:(NSString *)dataFileContent callback:(QNResultCallback)callback {
    [[QNDebug sharedDebug] log:[NSString stringWithFormat:@"<initSdk> appid: %@  fileContent: %@",appId,dataFileContent]];
    QNAuthInfo *authInfo = [QNAuthInfo sharedAuthInfo];
    [authInfo askAuthInfoWithMethodAppid:appId];
    
    BOOL vail = [authInfo updateAuthInfoWithEncryptInfo:dataFileContent];
    if (vail == NO) {
        [NSError errorCode:QNBleErrorCodeInvalidateAppId callBack:callback];
        return;
    }
    
    if (authInfo.serverType == 0) {
        if (self.requestUpdateSdkConfigFlag == NO || authInfo.dayNum != [authInfo dayNumSince1970]) {
            __weak typeof(self) weakself = self;
            [QNNetwork registerSDKAppid:appId response:^(NSDictionary *result, NSError *error) {
                if (result) {
                    weakself.requestUpdateSdkConfigFlag = YES;
                    authInfo.dayNum = [authInfo dayNumSince1970];
                    [authInfo updateAuthInfoWithJson:result];
                }
            }];
        }
    }
    QNConfig *config = [QNConfig sharedConfig];
    if (self.centralManager == nil) {
        self.centralManager = [[QNCentralManager alloc] initCentralManager:nil showPowerAlertFlag:config.showPowerAlertKey queue:nil];
        self.centralManager.delegate = self;
    }
    
    if (self.scaleManager == nil) {
        self.scaleManager = [[QNPScaleManager alloc] initWithCentralManager:self.centralManager];
        self.scaleManager.delegate = self;
    }
    
    if (self.advertManager == nil) {
        self.advertManager = [[QNAdvertScaleManager alloc] initWithCentralManager:self.centralManager];
        self.advertManager.delegate = self;
    }
    
    if (self.wspManager == nil) {
        self.wspManager = [[QNWspManager alloc] initWithCentralManager:self.centralManager];
        self.wspManager.delegate = self;
    }

    if (self.heightScaleManager == nil) {
        self.heightScaleManager = [[QNHeightScaleManager alloc] initWithCentralManager:self.centralManager];
        self.heightScaleManager.delegate = self;
    }
    
    if (callback) {
        callback(nil);
    }
}

- (QNBLEState)getCurSystemBleState {
    QNBlueToothState state = [self.centralManager currentBlueTooth];
    QNBLEState bleState = QNBLEStateUnknown;
    switch (state) {
        case QNBlueToothStateResetting: bleState = QNBLEStateResetting; break;
        case QNBlueToothStateUnsupported: bleState = QNBLEStateUnsupported; break;
        case QNBlueToothStateUnauthorized: bleState = QNBLEStateUnauthorized; break;
        case QNBlueToothStatePoweredOn: bleState = QNBLEStatePoweredOn; break;
        case QNBlueToothStatePoweredOff: bleState = QNBLEStatePoweredOff; break;
        default:
            break;
    }
    return bleState;
}

#pragma mark 开始扫描
- (void)startBleDeviceDiscovery:(QNResultCallback)callback {
    [[QNDebug sharedDebug] log:@"<startBleDeviceDiscovery>"];
    [self.advertManager beginEnhanceBroadcast];
    NSError *checkoutError = [[QNAuthInfo sharedAuthInfo] checkUseAuth];
    if (checkoutError) {
        //不允许使用
        [NSError errorCode:checkoutError.code callBack:callback];
        return;
    }
    
    QNConfig *config = [QNConfig sharedConfig];
    __weak typeof(self) weakSelf = self;
    [self.centralManager scanDeviceHandle:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            weakSelf.scanBehaviorFlag = YES;
            [weakSelf.filtDeviceInfo removeAllObjects];
            if (QNDelegate(weakSelf.discoveryListener,onStartScan)) {
                [weakSelf.discoveryListener onStartScan];
            }
            if (callback) {
                callback(nil);
            }
            if (config.duration > 0) {
                [weakSelf cancelScanTimer];
                weakSelf.scanTimer = [NSTimer qnCentralScheduledTimerWithTimeInterval:config.duration / 1000.0 block:^(NSTimer * _Nonnull timer) {
                    weakSelf.scanBehaviorFlag = NO;
                    [weakSelf cancelScanTimer];
                    [weakSelf privateStopBleDeviceWithMac:self.connectDevice.mac isCallback:YES resultCallback:nil];
                } repeats:NO];
            }
        }else {
            NSError *qnError = [NSError errorForQNBLEModuleError:error];
            [NSError errorCode:qnError.code callBack:callback];
        }
    }];
}


#pragma mark 停止扫描
- (void)stopBleDeviceDiscorvery:(QNResultCallback)callback {
    [[QNDebug sharedDebug] log:@"<stopBleDeviceDiscorvery>"];
    self.scanBehaviorFlag = NO;
    [self privateStopBleDeviceWithMac:self.connectDevice.mac isCallback:YES resultCallback:callback];
}


#pragma mark 连接设备
- (void)connectDevice:(QNBleDevice *)device user:(QNUser *)user callback:(QNResultCallback)callback {
    [self conenctDevice:device user:user wifiConfig:nil callback:callback];
}

#pragma mark 连接wsp设备
- (void)connectWspDevice:(QNBleDevice *)device config:(QNWspConfig *)config callback:(QNResultCallback)callback {
    [[QNDebug sharedDebug] log:@"<connectWSpDevice>"];
    
    if (device.deviceType != QNDeviceTypeScaleWsp) {
        [NSError errorCode:QNBleErrorCodeIllegalArgument callBack:callback];
        return;
    }
    
    NSError *checkoutError = [[QNAuthInfo sharedAuthInfo] checkUseAuth];
    if (checkoutError) {
        [NSError errorCode:checkoutError.code callBack:callback];
        return;
    }
    
    if (self.dataListener == nil) {
        [NSError errorCode:QNBleErrorCodeMissDataListener callBack:callback];
        return;
    }
    
    if (config.wifiConfig == nil && config.curUser == nil) {
        [NSError errorCode:QNBleErrorCodeIllegalArgument callBack:callback];
        return;
    }
    
    if (config.curUser != nil) {
        NSError *userError = [config.curUser checkUserInfo];
        if (userError) {
            [NSError errorCode:userError.code callBack:callback];
            return;
        }
    }
    
    if (config.longitude != nil || config.latitude != nil) {
        NSString *regular = @"^[-+]?\\d{0,3}\\.?\\d+$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
        BOOL isVailLongitude = [predicate evaluateWithObject:config.longitude];
        BOOL isVailLatitude = [predicate evaluateWithObject:config.latitude];
        if (!isVailLongitude || !isVailLatitude) {
            [[QNDebug sharedDebug] log:[NSString stringWithFormat:@"longitude: %@  latitude: %@", config.longitude, config.latitude]];
            [NSError errorCode:QNBleErrorCodeIllegalArgument callBack:callback];
            return;
        }
    }
    
    [self.storageAll removeAllObjects];
    
    self.connectDevice = device;
    if (device.wspDevice) {
        device.user = config.curUser;
        self.connectDeviceFlag = YES;
        [self.wspManager connectWspDevice:device.wspDevice config:^(QNWspDeploy * _Nonnull deploy) {
            deploy.isWifiChannel = YES;
            QNConfig *sdkConfig = [QNConfig sharedConfig];
            switch (sdkConfig.unit) {
                case QNUnitLB: deploy.unit = QNWspDeviceUnitLB; break;
                case QNUnitST: deploy.unit = QNWspDeviceUnitST; break;
                case QNUnitJIN: deploy.unit = QNWspDeviceUnitJin; break;
                default: deploy.unit = QNWspDeviceUnitKG; break;
            }
            
            NSMutableArray<QNWspUser *> *deleteUsers = [NSMutableArray<QNWspUser *> array];
            for (NSNumber *item in config.deleteUsers) {
                QNWspUser *user = [[QNWspUser alloc] init];
                user.secretIndex = item;
                [deleteUsers addObject:user];
            }
            deploy.deleteUsers = deleteUsers;
            
            if (config.latitude && config.longitude) {
                CGFloat latitude = [config.latitude floatValue];
                CGFloat longitude = [config.longitude floatValue];
                QNWspLocation *location = [[QNWspLocation alloc] init];
                location.latitude = latitude;
                location.longitude = longitude;
                deploy.location = location;
            }
            
            deploy.readSn = config.isReadSN;
            
            if (config.curUser != nil) {
                QNWspUser *wspUser = [[QNWspUser alloc] init];
                wspUser.secretKey = config.curUser.secret;
                if (config.isRegist == NO) {
                    wspUser.secretIndex = [NSNumber numberWithInt:config.curUser.index];
                }
                wspUser.userId = config.curUser.userId;
                wspUser.nick = config.curUser.userId;
                wspUser.gender = [config.curUser.gender isEqualToString:@"female"] ? QNWspGenderFemale : QNWspGenderMale;
                wspUser.birthday = config.curUser.birthday;
                wspUser.height = [config.curUser getHeight];
                wspUser.age = [QNUser getAgeWithBirthday:config.curUser.birthday];
                wspUser.method = [QNDataCypher calculateMethodWithUser:config.curUser device:[QNDeviceTool getDeviceInfoWithInternalModel:device.modeId]];
                wspUser.sportFlag = [QNDataCypher calculateSportModeWithUser:config.curUser];
                if (config.curUser.indicateConfig) {
                    QNWspTarget *target = [[QNWspTarget alloc] init];
                    target.nick = config.curUser.indicateConfig.showUserName;
                    target.bmi = config.curUser.indicateConfig.showBmi;
                    target.bone = config.curUser.indicateConfig.showBone;
                    target.bodyfat = config.curUser.indicateConfig.showFat;
                    target.sinew = config.curUser.indicateConfig.showMuscle;
                    target.water = config.curUser.indicateConfig.showWater;
                    target.hearRate = config.curUser.indicateConfig.showHeartRate;
                    wspUser.target = target;
                }
                
                if (config.isChange || config.isRegist) {
                    wspUser.synUserMesg = YES;
                }
                
                wspUser.visitFlag = config.isVisitor;
                deploy.visitUser = wspUser;
            }

            
            if (config.wifiConfig) {
                QNWspWiFi *wspWifi = [[QNWspWiFi alloc] init];
                wspWifi.ssid = config.wifiConfig.ssid;
                wspWifi.pwd = config.wifiConfig.pwd;
                wspWifi.serverUrl = config.dataUrl;
                wspWifi.otaUrl = config.otaUrl;
                wspWifi.encryption = config.encryption;
                deploy.wifiConfig = wspWifi;
            }
        } response:^(BOOL success, NSError * _Nullable err) {
            if (success) {
                !callback ?: callback(nil);
            } else {
                self.connectDeviceFlag = NO;
                NSError *errorTemp = [NSError errorForQNBLEModuleError:err];
                [NSError errorCode:errorTemp.code callBack:callback];
            }
        }];
    }
}

#pragma mark 断开设备的连接
- (void)disconnectDevice:(QNBleDevice *)device callback:(QNResultCallback)callback {
    [[QNDebug sharedDebug] log:@"<disconnectDevice>"];
    [self.scaleManager cancelConnectScaleDevice:self.connectDevice.publicDevice];
    [self.advertManager cancelConnectScaleDevice];
    [self.wspManager cancelConnectScaleDevice];
    [self.heightScaleManager cancelConnectScaleDevice];
    if (callback) {
        callback(nil);
    }
}

#pragma mark 对设备进行配网
- (void)connectDeviceSetWiFiWithDevice:(QNBleDevice *)device user:(QNUser *)user wifiConfig:(QNWiFiConfig *)wifiConfig callback:(QNResultCallback)callback {
    if (device.supportWifi == NO || device.deviceType == QNDeviceTypeHeightScale) {
        if (callback) {
            [NSError errorCode:QNBleErrorCodeDeviceType callBack:callback];
        }
        return;
    }
    
    if (device.deviceType != QNDeviceTypeScaleBleDefault) {
        [NSError errorCode:QNBleErrorCodeDeviceType callBack:callback];
        return;
    }
    
    if ([wifiConfig isKindOfClass:[QNWiFiConfig class]] == NO || [wifiConfig checkPWDVail] == NO || [wifiConfig checkSSIDVail] == NO || device.deviceType != QNDeviceTypeScaleBleDefault) {
        [NSError errorCode:QNBleErrorCodeWiFiParams callBack:callback];
        return;
    }
    
    QNPWifiConfig *config = [[QNPWifiConfig alloc] init];
    config.ssid = wifiConfig.ssid;
    config.pwd = wifiConfig.pwd;
    [self conenctDevice:device user:user wifiConfig:config callback:callback];
}

#pragma mark - 向轻牛云注册设备
- (void)registerWiFiBleDevice:(QNBleDevice *)device callback:(QNResultCallback)callback {
    NSError *checkoutError = [[QNAuthInfo sharedAuthInfo] checkUseAuth];
    if (device.mac.length != 17 || device.modeId.length == 0) {
        checkoutError = [NSError errorCode:QNBleErrorCodeIllegalArgument];
    } else if (device.isSupportWifi == NO || device.deviceType != QNDeviceTypeScaleBleDefault) {
        checkoutError = [NSError errorCode:QNBleErrorCodeDeviceType];
    }
    if (checkoutError) {
        if (QNDebugLogIsVail) {
            [[QNDebug sharedDebug] log:[checkoutError description]];
        }
        if (callback) {
            callback(checkoutError);
        }
        return;
    }
    
    if ([self.registerDevices containsObject:device.mac.uppercaseString]) {
        if (callback) {
            callback(nil);
        }
        return;
    }
    
    [QNNetwork registerDevice:device response:^(BOOL success, NSError *error) {
        if (success) {
            [self.registerDevices addObject:device.mac.uppercaseString];
        }
        if (callback) {
            callback(error);
        }
    }];
}


- (void)conenctDevice:(QNBleDevice *)device user:(QNUser *)user wifiConfig:(QNPWifiConfig *)wifiConfig callback:(QNResultCallback)callback {
    [[QNDebug sharedDebug] log:@"<connectDevice>"];
    NSError *checkoutError = [[QNAuthInfo sharedAuthInfo] checkUseAuth];
    if (checkoutError) {
        //不允许使用
        [NSError errorCode:checkoutError.code callBack:callback];
        return;
    }
    if (self.dataListener == nil) {
        [NSError errorCode:QNBleErrorCodeMissDataListener callBack:callback];
        return;
    }
    
    if (user == nil) {
        [[QNDebug sharedDebug] log:@"未设置用户信息，采用默认值"];
        user = [[QNUser alloc] init];
        user.userId = @"123456789";
        user.gender = @"male";
        user.height = 170;
        NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        dateComponents.year = dateComponents.year - 30;
        user.birthday = [self.calendar dateFromComponents:dateComponents];
    }
    
    NSError *userError = [user checkUserInfo];
    if (userError) {
        [NSError errorCode:userError.code callBack:callback];
        return;
    }
    device.user = user;
    QNConfig *sdkConfig = [QNConfig sharedConfig];
    
    [self.storageAll removeAllObjects];
    self.connectDevice = device;
    if (device.publicDevice) {
        self.connectDeviceFlag = YES;
        QNPUser *puser = [QNPUser userHeight:[user getHeight] gender:[user.gender isEqualToString:@"female"] ? QNPUserGenderFemale : QNPUserGenderMale age:[QNUser getAgeWithBirthday:user.birthday]];
        [self.scaleManager connectScaleDevice:device.publicDevice user:puser wifiConifg:wifiConfig configBlock:^(QNConnectConfig * _Nonnull config, QNPScaleConfig * _Nonnull scaleConifg) {
            switch (sdkConfig.unit) {
                case QNUnitLB: scaleConifg.unitMode = QNPScaleUnitLB; break;
                case QNUnitJIN: scaleConifg.unitMode = QNPScaleUnitJin; break;
                case QNUnitST: scaleConifg.unitMode = QNPScaleUnitST; break;
                default: scaleConifg.unitMode = QNPScaleUnitKG; break;
            }
        } response:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                !callback ?: callback(nil);
            } else {
                self.connectDeviceFlag = NO;
                NSError *errorTemp = [NSError errorForQNBLEModuleError:error];
                [NSError errorCode:errorTemp.code callBack:callback];
            }
        }];
    } else if (device.heightScaleDevice) {
        self.connectDeviceFlag = YES;
        QNWeightScaleConfig *heigthScaleConfig = [[QNWeightScaleConfig alloc] init];
        switch (sdkConfig.unit) {
            case QNUnitLB: heigthScaleConfig.unit = QNHeightScaleLB; break;
            case QNUnitJIN: heigthScaleConfig.unit = QNHeightScaleJin; break;
            case QNUnitST: heigthScaleConfig.unit = QNHeightScaleST; break;
            default: heigthScaleConfig.unit = QNHeightScaleKG; break;
        }
        [self.heightScaleManager connectScaleDevice:device.heightScaleDevice config:heigthScaleConfig response:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                !callback ?: callback(nil);
            } else {
                self.connectDeviceFlag = NO;
                NSError *errorTemp = [NSError errorForQNBLEModuleError:error];
                [NSError errorCode:errorTemp.code callBack:callback];
            }
        }];
    } else if (device.advertDevice) {
        self.connectDeviceFlag = YES;
        [self.advertManager beginEnhanceBroadcast];
        [self.centralManager scanDeviceHandle:nil];
        [self.advertManager connectScaleDevice:device.advertDevice config:^(QNAdvertScaleUnitMode * _Nonnull unitMode) {
            switch (sdkConfig.unit) {
                case QNUnitLB: *unitMode = QNAdvertScaleUnitLB; break;
                case QNUnitJIN:  *unitMode = QNAdvertScaleUnitJin; break;
                case QNUnitST: *unitMode = QNAdvertScaleUnitST; break;
                default: *unitMode = QNAdvertScaleUnitKG; break;
            }
        } response:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                !callback ?: callback(nil);
            }else {
                self.connectDeviceFlag = NO;
                NSError *errorTemp = [NSError errorForQNBLEModuleError:error];
                [NSError errorCode:errorTemp.code callBack:callback];
            }
        }];
    } else if (device.wspDevice) {
        self.connectDeviceFlag = YES;
        QNWspUser *wspUser = [[QNWspUser alloc] init];
        wspUser.visitFlag = true;
        wspUser.userId = user.userId;
        wspUser.gender = [user.gender isEqualToString:@"male"] ? QNWspGenderMale : QNWspGenderFemale;
        wspUser.birthday = user.birthday;
        wspUser.height = (NSUInteger)[user getHeight];
        wspUser.age = [QNUser getAgeWithBirthday:user.birthday];
        wspUser.method = [QNDataCypher calculateMethodWithUser:user device:device.authDevice];
        wspUser.sportFlag = [QNDataCypher calculateSportModeWithUser:user];
        [self.wspManager connectWspDevice:device.wspDevice config:^(QNWspDeploy * _Nonnull config) {
            config.isWifiChannel = YES;
            switch (sdkConfig.unit) {
                case QNUnitLB: config.unit = QNWspDeviceUnitLB; break;
                case QNUnitJIN: config.unit = QNWspDeviceUnitJin; break;
                case QNUnitST: config.unit = QNWspDeviceUnitST; break;
                default: config.unit = QNWspDeviceUnitKG; break;
            }
            config.visitUser = wspUser;
        } response:^(BOOL success, NSError * _Nullable err) {
            if (success) {
                !callback ?: callback(nil);
            }else {
                self.connectDeviceFlag = NO;
                NSError *errorTemp = [NSError errorForQNBLEModuleError:err];
                [NSError errorCode:errorTemp.code callBack:callback];
            }
        }];
        
    }
}

- (QNConfig *)getConfig {
    return [QNConfig sharedConfig];
}

#pragma mark 根据提供的kg数值的体重，转化为指定单位的数值
- (double)convertWeightWithTargetUnit:(double)weight unit:(QNUnit)unit {
    return [[QNDataTool sharedDataTool] convertWeightWithTargetUnit:weight unit:unit];
}

#pragma mark 用户模型的建立
- (QNUser *)buildUser:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday callback:(QNResultCallback)callback {
    QNUser *user = [[QNUser alloc] init];
    user.userId = userId;
    user.height = height;
    user.gender = gender;
    user.birthday = birthday;
    NSError *error = [user checkUserInfo];
    if (callback) {
        callback(error);
    }
    return error == nil ? user : nil;
}

#pragma mark 创建SDK蓝牙对象
- (QNBleDevice *)buildDevice:(CBPeripheral *)peripheral rssi:(NSNumber *)rssi advertisementData:(NSDictionary *)advertisementData callback:(QNResultCallback)callback {
    
    BOOL scaleVail = NO;
    if ([advertisementData.allKeys containsObject:@"kCBAdvDataServiceUUIDs"]) {
        for (CBUUID *item in advertisementData[@"kCBAdvDataServiceUUIDs"]) {
            if ([item.UUIDString.uppercaseString isEqualToString:@"FFE0"] || [item.UUIDString.uppercaseString isEqualToString:@"FFF0"] || [item.UUIDString.uppercaseString isEqualToString:@"FEB3"]) {
                scaleVail = YES;
                break;
            }
        }
    }
    
    NSData *manufacturerData = (NSData *)[advertisementData valueForKey:CBAdvertisementDataManufacturerDataKey];
    
    if (scaleVail == NO || peripheral.name.length == 0 || manufacturerData.length < 10) {
        !callback ?: callback([NSError errorCode:QNBleErrorCodeIllegalArgument]);
        return nil;
    };
    
    const Byte *bytes = manufacturerData.bytes;
    NSString *prefixStr = [[NSString stringWithFormat:@"%02x%02x",bytes[0],bytes[1]] uppercaseString];
    
    if (![prefixStr isEqualToString:@"FFFF"] && ![prefixStr isEqualToString:@"A801"]) {
        !callback ?: callback([NSError errorCode:QNBleErrorCodeIllegalArgument]);
        return nil;
    };
    
    if ([peripheral.name isEqualToString:@"QN-Scale"] || [peripheral.name isEqualToString:@"QN-Scale1"]) {
        return [self analysisPublicAdvertWithPeripheral:peripheral manufacturerData:manufacturerData rssi:rssi];
    }
    !callback ?: callback([NSError errorCode:QNBleErrorCodeIllegalArgument]);
    return nil;
}

- (QNBleDevice *)analysisPublicAdvertWithPeripheral:(CBPeripheral *)peripheral manufacturerData:(NSData *)manufacturerData rssi:(NSNumber *)rssi {
    if (manufacturerData.length < 13) return nil;
    
    const Byte *bytes = manufacturerData.bytes;
    
    //内部型号
    NSString *internalModel = [[NSString stringWithFormat:@"%02x%02x",bytes[2],bytes[3]] uppercaseString];
    //状态
    NSInteger status = bytes[5];
    //存储数据
    NSUInteger storageNum = (NSUInteger)bytes[6];
    //mac地址
    NSString *mac = nil;
    for (NSUInteger i = 12; i > 6; i --) {
        if (mac == nil) {
            mac = [NSString stringWithFormat:@"%02x",bytes[i]];
        }else{
            mac = [NSString stringWithFormat:@"%@:%02x",mac,bytes[i]];
        }
    }
    mac = [mac uppercaseString];
    
    BOOL doubleModuleFlag = NO;
    if (manufacturerData.length > 13 && bytes[13] == 0x30) {
        doubleModuleFlag = YES;
    }
    
    QNDeviceScreenState screenState = QNDeviceScreenStateOpen;
    if (status == 1) {
        screenState = QNDeviceScreenStateClose;
    }
    
    QNPScaleDevice *scaleDevice = [[QNPScaleDevice alloc] init];
    [scaleDevice setValue:mac forKeyPath:@"mac"];
    [scaleDevice setValue:internalModel forKeyPath:@"internalModel"];
    [scaleDevice setValue:rssi forKeyPath:@"RSSI"];
    [scaleDevice setValue:[NSNumber numberWithUnsignedInteger:screenState] forKeyPath:@"screenState"];
    [scaleDevice setValue:[NSNumber numberWithUnsignedInteger:storageNum] forKeyPath:@"storage"];
    [scaleDevice setValue:[NSNumber numberWithBool:doubleModuleFlag] forKeyPath:@"doubleModuleFlag"];
    scaleDevice.peripheral = peripheral;
    
    QNBleDevice *bleDevice = [QNBleDevice buildBleDeviceWithDevice:scaleDevice];
    
    return bleDevice;

}

#pragma mark 创建轻牛广播蓝牙秤设备对象
- (QNBleBroadcastDevice *)buildBroadcastDevice:(CBPeripheral *)peripheral rssi:(NSNumber *)rssi advertisementData:(NSDictionary *)advertisementData callback:(QNResultCallback)callback {
    
    QNAdvertScaleDevice *adertScaleDevice = [self.advertManager analysisBroadcastDeviceAdvertisementData:advertisementData peripheral:peripheral RSSI:rssi];
    if (adertScaleDevice.deviceType != QNAdvertDeviceTypeQNS3) {
        return nil;
    }

    QNBleDevice *bleDevice = [QNBleDevice buildBleDeviceWithDevice:adertScaleDevice];
    QNBleBroadcastDevice *broadcastDevice = [[QNBleBroadcastDevice alloc] init];
    if (bleDevice.advertDevice.isComplete) {
        broadcastDevice.timeTemp = [[NSDate date] timeIntervalSince1970];
    }
    
    [broadcastDevice tranform:bleDevice];
    return broadcastDevice;
}

- (QNBleKitchenDevice *)buildKitchenDevice:(CBPeripheral *)peripheral rssi:(NSNumber *)rssi advertisementData:(NSDictionary *)advertisementData callback:(QNResultCallback)callback {
    QNAdvertScaleDevice *advertScaleDevice = [self.advertManager analysisBroadcastDeviceAdvertisementData:advertisementData peripheral:peripheral RSSI:rssi];
    return [self tranformKitchenDeviceWithAdvertScaleDeivce:advertScaleDevice];
}

- (QNBleKitchenDevice *)tranformKitchenDeviceWithAdvertScaleDeivce:(QNAdvertScaleDevice *)advertScaleDevice {
    if (advertScaleDevice.deviceType != QNAdvertDeviceTypeKitchen) {
        return nil;
    }
    QNBleDevice *bleDevice = [QNBleDevice buildBleDeviceWithDevice:advertScaleDevice];
    QNBleKitchenDevice *kitchenDevice = [[QNBleKitchenDevice alloc] init];
    [kitchenDevice setValue:advertScaleDevice.mac forKeyPath:@"mac"];
    [kitchenDevice setValue:bleDevice.name forKeyPath:@"name"];
    [kitchenDevice setValue:advertScaleDevice.internalModel forKeyPath:@"modeId"];
    [kitchenDevice setValue:advertScaleDevice.RSSI forKeyPath:@"RSSI"];
    QNUnit unit = QNUnitG;
    switch (advertScaleDevice.unit) {
        case QNAdvertScaleUnitML: unit = QNUnitML; break;
        case QNAdvertScaleUnitOZ: unit = QNUnitOZ; break;
        case QNAdvertScaleUnitLBOZ: unit = QNUnitLBOZ; break;
        default:
            break;
    }
    [kitchenDevice setValue:[NSNumber numberWithUnsignedInteger:unit] forKeyPath:@"unit"];
    [kitchenDevice setValue:[NSNumber numberWithFloat:advertScaleDevice.weight] forKeyPath:@"weight"];
    [kitchenDevice setValue:[NSNumber numberWithBool:advertScaleDevice.isShelling] forKeyPath:@"isPeel"];
    [kitchenDevice setValue:[NSNumber numberWithBool:advertScaleDevice.reverseWeightFlag] forKeyPath:@"isNegative"];
    [kitchenDevice setValue:[NSNumber numberWithBool:advertScaleDevice.overWeightFlag] forKeyPath:@"isOverload"];
    return kitchenDevice;
}

- (QNBleProtocolHandler *)buildProtocolHandler:(QNBleDevice *)device user:(QNUser *)user wifiConfig:(QNWiFiConfig *)wifiConfig delegate:(id<QNBleProtocolDelegate>)delegate callback:(QNResultCallback)callback {
    
    QNConfig *localConfig = [self getConfig];
    
    QNPScaleConfig *scaleConfig = [[QNPScaleConfig alloc] init];
    
    switch ([QNConfig sharedConfig].unit) {
        case QNUnitLB: scaleConfig.unitMode = QNUnitLB; break;
        case QNUnitJIN: scaleConfig.unitMode = QNUnitLB; break;
        case QNUnitST: scaleConfig.unitMode = QNUnitLB; break;
        default: scaleConfig.unitMode = QNUnitKG; break;
    }
    scaleConfig.readStorageDataFlag = YES;
    
    if (scaleConfig == nil) {
        scaleConfig = [[QNPScaleConfig alloc] init];
        scaleConfig.unitMode = QNPScaleUnitKG;
        scaleConfig.readStorageDataFlag = YES;
    }
    
    switch (localConfig.unit) {
        case QNUnitLB:
            scaleConfig.unitMode = QNPScaleUnitLB;
            break;
            
        case QNUnitJIN:
            scaleConfig.unitMode = QNPScaleUnitJin;
            break;
            
        case QNUnitST:
            scaleConfig.unitMode = QNPScaleUnitST;
            break;
            
        default:
            scaleConfig.unitMode = QNPScaleUnitKG;
            break;
    }
    
    device.publicDevice.scaleHelp = [[QNPScaleHelp  alloc] init];
    device.publicDevice.scaleHelp.scaleConfig = scaleConfig;
    QNPUser *puser = [QNPUser userHeight:[user getHeight] gender:[user.gender isEqualToString:@"female"] ? QNPUserGenderFemale : QNPUserGenderMale age:[QNUser getAgeWithBirthday:user.birthday]];
    device.publicDevice.scaleHelp.scaleUser = puser;
    
    QNPWifiConfig *pwifiConfig = [[QNPWifiConfig alloc] init];
    pwifiConfig.ssid = wifiConfig.ssid;
    pwifiConfig.pwd = wifiConfig.pwd;
    if (device.supportWifi) {
        device.publicDevice.scaleHelp.wifiConfig = pwifiConfig;
    }else {
        device.publicDevice.scaleHelp.wifiConfig = nil;
    }
    
    QNBleDevice *bleDevice = nil;
    for (QNBleDevice *item in self.deviceList) {
        if ([device.mac isEqualToString:item.mac]) {
            bleDevice = item;
        }
    }
    if (bleDevice) {
        [self.deviceList removeObject:bleDevice];
    }
    device.user = user;
    [self.deviceList addObject:device];
    QNBleProtocolHandler *protocolHandler = [[QNBleProtocolHandler alloc] init];
    protocolHandler.peripheral = device.publicDevice.peripheral;
    protocolHandler.device = device;
    self.bleProtocolListener = delegate;
    return protocolHandler;
}

- (QNScaleData *)generateScaleData:(QNUser *)user modeId:(NSString *)modeId weight:(double)weight date:(NSDate *)measureDate resistance:(int)resistance secResistance:(int)secResistance hmac:(NSString *)hmac heartRate:(int)heartRate {
    NSString *decrypt = [QNAESCrypt AES128Decrypt:hmac];
    NSDictionary *resultDic = [[QNDataTool sharedDataTool] jsonTodictionary:decrypt];
    
    if (resultDic == nil) return nil;
    
    NSInteger hmac_heartRate = [[QNDataTool sharedDataTool] toInteger:resultDic[@"heart_rate"]];
    NSString *hmac_internalModel = [[QNDataTool sharedDataTool] toString:resultDic[@"model_id"]];
    NSInteger hmac_measureDate = [[QNDataTool sharedDataTool] toInteger:resultDic[@"measure_time"]];
//    NSString *hmac_deviceMac = [[QNDataTool sharedDataTool] toString:resultDic[@"mac"]];
    NSInteger hmac_res = [[QNDataTool sharedDataTool] toInteger:resultDic[@"resistance_50"]];
    NSInteger hmac_secRes = [[QNDataTool sharedDataTool] toInteger:resultDic[@"resistance_500"]];
    double hmac_weight = [[QNDataTool sharedDataTool] toDouble:resultDic[@"weight"]];
    
    NSDate *hmac_date = [NSDate dateWithTimeIntervalSince1970:hmac_measureDate];
    
    if (![hmac_internalModel isEqualToString:modeId] || fabs(hmac_weight - weight) > 0.5 || fabs([hmac_date timeIntervalSinceDate:measureDate]) > 5 || hmac_heartRate != heartRate || labs(resistance - hmac_res) > 0.5 || labs(secResistance - hmac_secRes) > 0.5) {
        return nil;
    }
    
    QNAuthDevice *device = [QNDeviceTool getDeviceInfoWithInternalModel:modeId];
    if (device == nil) return nil;
    
    NSInteger tureRes = (NSInteger)secResistance * 3 - resistance * 3 / 2;
    NSInteger tureSecRes = (NSInteger)resistance * 1.5 - secResistance;

    QNDataCypher *dataCypher = [QNDataCypher buildCypherWithWeight:weight res:tureRes secRes:tureSecRes timeTemp:[measureDate timeIntervalSince1970] device:device heartRate:heartRate];
    QNScaleData *scaleData = [QNScaleData buildDataCypher:dataCypher user:user isCallCalculate:YES];
    return scaleData;
}

#pragma mark - scan device listener
- (void)discoverKitchenScaleDevice:(QNAdvertScaleDevice *)device {
    //意图关闭时，停止回调任何设备
    if (self.scanBehaviorFlag == NO) return;
    
    QNBleKitchenDevice *kitchenDevice = [self tranformKitchenDeviceWithAdvertScaleDeivce:device];
    if (kitchenDevice == nil) { return; }
    if (QNDelegate(self.discoveryListener,onKitchenDeviceDiscover:)) {
        [self.discoveryListener onKitchenDeviceDiscover:kitchenDevice];
    }
}

- (void)discoverAdvertScaleDevice:(QNAdvertScaleDevice *)device {
    [self discoveryScaleDeviceHandler:device];
}

- (void)discoverPublicScaleDevice:(QNPScaleDevice *)device {
    [self discoveryScaleDeviceHandler:device];
}

- (void)discoverWSPScaleDevice:(QNWspDevice *)device{
    [self discoveryScaleDeviceHandler:device];
}

- (void)discoverHeightScaleDevice:(QNHeightScaleDevice *)device {
    [self discoveryScaleDeviceHandler:device];
}

- (void)discoveryScaleDeviceHandler:(id)device {
    //意图关闭时，停止回调任何设备
    if (self.scanBehaviorFlag == NO) return;
    
    QNBleDevice *bleDevice = [QNBleDevice buildBleDeviceWithDevice:device];
    if (bleDevice == nil) return;
    
    [self callbackBroadcastDevice:device bleDevice:bleDevice];
    
    //排除已连接的设备
    if (self.connectDeviceFlag && [self.connectDevice.mac isEqualToString:bleDevice.mac]) return;
    
    QNConfig *localConfig = [QNConfig sharedConfig];
    
    if (localConfig.onlyScreenOn && bleDevice.screenOn == NO) return;
    
    if (localConfig.allowDuplicates) {
        if (bleDevice && QNDelegate(self.discoveryListener,onDeviceDiscover:)) {
            [self.discoveryListener onDeviceDiscover:bleDevice];
        }
    } else {
        FilterDevice *fDevice = nil;
        if ([self.filtDeviceInfo.allKeys containsObject:bleDevice.mac]) {
            fDevice = (FilterDevice *)self.filtDeviceInfo[bleDevice.mac];
        }
        if (fDevice == nil) {
            FilterDevice *fDevice = [[FilterDevice alloc] init];
            fDevice.device = bleDevice;
            fDevice.scanNum = 1;
            [self.filtDeviceInfo setObject:fDevice forKey:bleDevice.mac];
        } else {
            if (fDevice.device.isScreenOn != bleDevice.isScreenOn) {
                [self.filtDeviceInfo removeObjectForKey:bleDevice.mac];
            }else{
                fDevice.device = bleDevice;
                fDevice.scanNum ++;
                if (fDevice.scanNum == 3) {
                    QNBleDevice *bleDevice = [QNBleDevice buildBleDeviceWithDevice:device];
                    if (bleDevice && QNDelegate(self.discoveryListener,onDeviceDiscover:)) {
                        [self.discoveryListener onDeviceDiscover:bleDevice];
                    }
                }
            }
        }
    }
}

- (void)callbackBroadcastDevice:(id)device bleDevice:(QNBleDevice *)bleDevice {
    //排除非广播秤
    if ([device isKindOfClass:[QNAdvertScaleDevice class]] == NO) return;
    //排除已经连接的设备
    if (self.connectDeviceFlag && [self.connectDevice.advertDevice.mac isEqualToString:bleDevice.mac]) return;
    
    QNAdvertScaleDevice *advertDevice = (QNAdvertScaleDevice *)device;
    //排除一对一、厨房秤
    if (advertDevice.deviceType == QNAdvertDeviceTypeQS1 || advertDevice.deviceType == QNAdvertDeviceTypeKitchen) return;
    
    QNBleBroadcastDevice *broadcastDevice = [[QNBleBroadcastDevice alloc] init];
    if (bleDevice.advertDevice.isComplete) {
        broadcastDevice.timeTemp = [[NSDate date] timeIntervalSince1970];
    }
    [broadcastDevice tranform:bleDevice];
    
    if (QNDelegate(self.discoveryListener,onBroadcastDeviceDiscover:)) {
        [self.discoveryListener onBroadcastDeviceDiscover:broadcastDevice];
    }
}

#pragma mark - QNBLEManagerDelegate
- (void)centralManagerBlueToothUpdateState:(QNBlueToothState)blueToothState{
    if (blueToothState != QNBLEStatePoweredOn) {
        self.connectDeviceFlag = NO;
        if (self.scanBehaviorFlag) {
            [self privateStopBleDeviceWithMac:self.connectDevice.mac isCallback:YES resultCallback:nil];
        }
        self.scanBehaviorFlag = NO;
    }
    
    if (QNDelegate(self.bleStateListener,onBleSystemState:)) {
        QNBLEState state = QNBLEStateUnknown;
        switch (blueToothState) {
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

- (void)centralManagerMessage:(NSString *)message {
    if ([self.logListener respondsToSelector:@selector(onLog:)]) {
        [self.logListener onLog:message];
    }
}

@end

