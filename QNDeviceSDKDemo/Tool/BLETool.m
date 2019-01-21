//
//  BLETool.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/8.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BLETool.h"

typedef void (^ResultCallBlock)(BOOL success);

@interface BLETool ()<QNBleDeviceDiscoveryListener,QNBleConnectionChangeListener,QNDataListener,QNBleStateListener>
@property (nonatomic, strong) QNBleApi *bleApi;
@end

@implementation BLETool
static BLETool *_bleTool = nil;

+ (BLETool *)sharedBLETool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bleTool = [BLETool alloc];
    });
    return _bleTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bleTool = [[super allocWithZone:zone] init];
    });
    return _bleTool;
}

- (instancetype)init {
    if (self = [super init]) {
        self.bleApi = [QNBleApi sharedBleApi];
        self.bleApi.discoveryListener = self;
        self.bleApi.connectionChangeListener = self;
        self.bleApi.dataListener = self;
        self.bleApi.bleStateListener = self;
        
        QNConfig *config = [self.bleApi getConfig];
        config.showPowerAlertKey = YES;
        
        QNBleApi.debug = YES;
        NSString *file = [[NSBundle mainBundle] pathForResource:@"123456789" ofType:@"qn"];
        [self.bleApi initSdk:@"123456789" firstDataFile:file callback:^(NSError *error) {
            
        }];
    }
    return self;
}

#pragma mark -
- (QNBandManager *)bandManager {
    return [self.bleApi getBandManagerCallback:^(NSError *error) {
        if (error) {
            //错误处理
            [self alertMesgError:error];
        }
    }];
}

#pragma mark -
- (void)connectDevice:(QNBleDevice *)device user:(QNUser *)user {
    [self stopScan];
    if (device.deviceType == QNDeviceBand) {
        self.bandDevice = device;
    }else {
        self.scaleDevice = device;
    }
    __weak typeof(self) weakSelf = self;
    [self.bleApi connectDevice:device user:user callback:^(NSError *error) {
        if (error) {
            if (device.deviceType == QNDeviceBand) {
                weakSelf.bandDevice = nil;
            }else {
                weakSelf.scaleDevice = nil;
            }
        }
    }];
}

- (void)disconnectBand {
    if (self.bandDevice == nil) return;
    [self.bleApi disconnectDevice:self.bandDevice callback:^(NSError *error) {
        if (error) {
            //错误处理
            [self alertMesgError:error];
        }
    }];
}

- (void)disconnectScale {
    if (self.scaleDevice == nil) return;
    [self.bleApi disconnectDevice:self.scaleDevice callback:^(NSError *error) {
        if (error) {
            //错误处理
            [self alertMesgError:error];
        }
    }];
}

#pragma mark -
- (void)scanDevice {
    [self.bleApi startBleDeviceDiscovery:^(NSError *error) {
        if (error) {
            //错误处理
            [self alertMesgError:error];
        }else {
            if ([self.bleApi getConfig].scanType == QNScanScale) return;
            BandMessage *message = [BandMessage sharedBandMessage];
            if (message.mac.length > 0) {
                [self.bleApi findPairBandWithMac:message.mac modeId:message.modeId uuidIdentifier:message.uuidString callback:^(NSError *error) {
                    if (error) {
                        //错误处理
                        [self alertMesgError:error];
                    }
                }];
            }
        }
    }];
}

- (void)stopScan {
    [self.bleApi stopBleDeviceDiscorvery:^(NSError *error) {
        if (error) {
            //错误处理
            [self alertMesgError:error];
        }
    }];
}

#pragma mark -
- (double)convertWeightWithTargetUnit:(double)kgWeight unit:(QNUnit)unit {
   return [self.bleApi convertWeightWithTargetUnit:kgWeight unit:unit];
}

#pragma mark -
- (void)onBleSystemState:(QNBLEState)state {
    if ([self.delegate respondsToSelector:@selector(qnBleStateUpdate:)]) {
        [self.delegate qnBleStateUpdate:state];
    }
}

#pragma mark -
- (void)onDeviceDiscover:(QNBleDevice *)device {
    NSString *bindedBandMac = [BandMessage sharedBandMessage].mac;
    if (device.deviceType == QNDeviceBand && bindedBandMac.length > 0 &&  [bindedBandMac isEqualToString:device.mac]) {
        [self connectDevice:device user:nil];
    }else {
        if ([self.delegate respondsToSelector:@selector(qnDiscoverDevice:)]) {
            [self.delegate qnDiscoverDevice:device];
        }
    }
}

- (void)onStartScan {
    
}

- (void)onStopScan {
    
}

#pragma mark -
- (void)onConnecting:(QNBleDevice *)device {
    
}

- (void)onConnected:(QNBleDevice *)device {
    
}

- (void)onServiceSearchComplete:(QNBleDevice *)device {
    
}

- (void)onDisconnecting:(QNBleDevice *)device {
    
}

- (void)onDisconnected:(QNBleDevice *)device {
    [self disconnectedWithDevice:device];
}

- (void)onConnectError:(QNBleDevice *)device error:(NSError *)error {
    [self disconnectedWithDevice:device];
}

- (void)disconnectedWithDevice:(QNBleDevice *)device {
    if (device.deviceType == QNDeviceBand) {
        self.bandDevice = nil;
        if ([BandMessage sharedBandMessage].mac.length > 0) {
            [self scanDevice];
        }
    }else {
        self.scaleDevice = nil;
    }
}

- (void)onDeviceStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state {
    if ([self.delegate respondsToSelector:@selector(qnDeviceStateChange:device:)]) {
        [self.delegate qnDeviceStateChange:state device:device];
    }
    if (state == QNScaleStateInteraction) {
        [self syncLocalBandSet];
    }
}

#pragma mark -
- (void)onGetUnsteadyWeight:(QNBleDevice *)device weight:(double)weight {
    if ([self.delegate respondsToSelector:@selector(qnScaleReceiveRealTimeWeight:device:)]) {
        [self.delegate qnScaleReceiveRealTimeWeight:weight device:device];
    }
}

- (void)onGetScaleData:(QNBleDevice *)device data:(QNScaleData *)scaleData {
    if ([self.delegate respondsToSelector:@selector(qnScaleReceiveResultData:device:)]) {
        [self.delegate qnScaleReceiveResultData:scaleData device:device];
    }
}

- (void)onGetStoredScale:(QNBleDevice *)device data:(NSArray<QNScaleStoreData *> *)storedDataList {
    //TODO...
}

- (void)onGetElectric:(NSUInteger)electric device:(QNBleDevice *)device {
    //电量
    [self alertMesg:[NSString stringWithFormat:@"电量： %ld",(long)electric]];
}

- (void)strikeTakePhotosWithDevice:(QNBleDevice *)device {
    //收到拍照指令
    [self alertMesg:@"收到拍照指令"];
}

- (void)strikeFindPhoneWithDevice:(QNBleDevice *)device {
    //收到查找手机指令
    [self alertMesg:@"收到查找手机指令"];
}

#pragma mark -
- (void)syncLocalBandSet {
    QNBandManager *manager = [BLETool sharedBLETool].bandManager;
    
    [[[[[[[[[self createPromiseExecuteBlock:^(ResultCallBlock callBlock) {
        //同步时间
        [manager syncBandTimeWithDate:[NSDate date] callback:^(NSError *error) {
            callBlock(error == nil);
        }];
    }] then:^FBLPromise *(id  _Nullable value) {
        //版本等信息
        return [self createPromiseExecuteBlock:^(ResultCallBlock callBlock) {
            [manager fetchBandInfo:^(QNBandInfo *info, NSError *error) {
                if (error == nil) {
                    [BandMessage sharedBandMessage].firmwareVer = info.firmwareVer;
                    [BandMessage sharedBandMessage].hardwareVer = info.hardwareVer;
                    [BandMessage sharedBandMessage].battery = info.electric;
                }
                callBlock(error == nil);
            }];
        }];
    }] then:^FBLPromise *(id  _Nullable value) {
        //第三方提醒
        return [self createPromiseExecuteBlock:^(ResultCallBlock callBlock) {
            [manager setThirdRemind:[BandMessage sharedBandMessage].thirdRemind callback:^(NSError *error) {
                callBlock(error == nil);
            }];
        }];
    }] then:^FBLPromise *(id  _Nullable value) {
        //检测与上次绑定手机是否相同
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
            if (self.bandDevice == nil) {
                reject([NSError errorWithDomain:@"PromiseSynLocal" code:10001 userInfo:nil]);
            }else {
                [manager checkSameBindPhone:^(NSNumber *sameNumber, NSError *error) {
                    if (error == nil && [sameNumber boolValue] == YES) {
                        reject(error ? error : [NSError errorWithDomain:@"SDKSynLocalSet" code:1001 userInfo:@{NSLocalizedDescriptionKey : @"与上次绑定手机相同"}]);
                    }else {
                        fulfill(nil);
                    }
                }];
            }
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        //不相同时清除设置
        return [self createPromiseExecuteBlock:^(ResultCallBlock callBlock) {
            QNCleanInfo *cleanInfo = [[QNCleanInfo alloc] init];
            cleanInfo.alarm = YES;
            cleanInfo.goal = YES;
            cleanInfo.metrics = YES;
            cleanInfo.sitRemind = YES;
            cleanInfo.lossRemind = YES;
            cleanInfo.heartRateObserver = YES;
            cleanInfo.handRecoginze = YES;
            cleanInfo.bindState = YES;
            cleanInfo.thirdRemind = YES;
            [manager resetWithCleanInfo:cleanInfo callback:^(NSError *error) {
                callBlock(error == nil);
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        //设置久坐提醒
        return [self createPromiseExecuteBlock:^(ResultCallBlock callBlock) {
            [manager syncSitRemind:[BandMessage sharedBandMessage].sitRemind callback:^(NSError *error) {
                callBlock(error == nil);
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        NSString *modeId = [BandMessage sharedBandMessage].modeId;
        int firmwareVer = [BandMessage sharedBandMessage].firmwareVer;
        if ([modeId isEqualToString:@"0000"] || [modeId isEqualToString:@"0001"] || [modeId isEqualToString:@"0002"] || ([modeId isEqualToString:@"0003"] && firmwareVer < 12)) {
            return [self syncOldVerBandSet:manager];
        }else {
            return [self createPromiseExecuteBlock:^(ResultCallBlock callBlock) {
                BandMessage *message = [[BandMessage alloc] init];
                QNBandBaseConfig *baseConfig = [[QNBandBaseConfig alloc] init];
                baseConfig.heartRateObserver = message.heartRateObserver;
                baseConfig.handRecog = message.handRecognize;
                baseConfig.findPhone = message.findPhone;
                baseConfig.lostRemind = message.lossRemind;
                baseConfig.user = message.user;
                baseConfig.stepGoal = message.sportGoal;
                baseConfig.metrics = [[QNBandMetrics alloc] init];
                baseConfig.metrics.length = message.length;
                baseConfig.metrics.language = message.language;
                baseConfig.metrics.formatHour = message.hourFormat;
                [manager syncFastSetting:baseConfig callback:^(NSError *error) {
                    callBlock(error == nil);
                }];
            }];
        }
    }] then:^id _Nullable(id  _Nullable value) {
        //设置闹钟
        NSMutableArray<QNAlarm *> *alarms = [BandMessage sharedBandMessage].alarms;
        if (alarms.count == 0) {
            return [FBLPromise do:^id _Nullable{
                return nil;
            }];
        }else {
            FBLPromise *promise = [self createPromiseExecuteBlock:^(ResultCallBlock callBlock) {
                [manager syncAlarm:alarms.firstObject callback:^(NSError *error) {
                    callBlock(error == nil);
                }];
            }];
            
            for (int i = 1; i < alarms.count; i ++) {
                promise = [promise then:^id _Nullable(id  _Nullable value) {
                    return [self createPromiseExecuteBlock:^(ResultCallBlock callBlock) {
                        [manager syncAlarm:alarms[i] callback:^(NSError *error) {
                            callBlock(error == nil);
                        }];
                    }];
                }];
            }
            return promise;
        }
    }] always:^{
        //同步设置完成
    }];
}

- (FBLPromise *)createPromiseExecuteBlock:(void (^)(ResultCallBlock callBlock))excuteBlock {
    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        if (self.bandDevice == nil) {
            reject([NSError errorWithDomain:@"PromiseSynLocal" code:10001 userInfo:nil]);
        }else {
            ResultCallBlock callBlock = ^(BOOL success) {
                fulfill(nil);
            };
            excuteBlock(callBlock);
        }
    }];
}

- (FBLPromise *)syncOldVerBandSet:(QNBandManager *)manager {
    BandMessage *message = [BandMessage sharedBandMessage];
    
    return [[[[[[self createPromiseExecuteBlock:^(ResultCallBlock callBlock) {
        //用户信息
        [manager syncUser:message.user callback:^(NSError *error) {
            callBlock(error == nil);
        }];
    }] then:^FBLPromise *(id  _Nullable value) {
        //心率开关
        return [self createPromiseExecuteBlock:^(ResultCallBlock callBlock) {
            [manager syncHeartRateObserverModeWithAutoFlag:message.heartRateObserver callback:^(NSError *error) {
                callBlock(error == nil);
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        //抬腕亮屏
        return [self createPromiseExecuteBlock:^(ResultCallBlock callBlock) {
            [manager syncHandRecognizeModeWithOpenFlag:message.handRecognize callback:^(NSError *error) {
                callBlock(error == nil);
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        //度量
        QNBandMetrics *metrics = [[QNBandMetrics alloc] init];
        metrics.language = message.language;
        metrics.length = message.length;
        metrics.formatHour = message.hourFormat;
        return [self createPromiseExecuteBlock:^(ResultCallBlock callBlock) {
            [manager syncMetrics:metrics callback:^(NSError *error) {
                callBlock(error == nil);
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        //目标
        return [self createPromiseExecuteBlock:^(ResultCallBlock callBlock) {
            [manager syncGoal:message.sportGoal callback:^(NSError *error) {
                callBlock(error == nil);
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        //查找手机
        return [self createPromiseExecuteBlock:^(ResultCallBlock callBlock) {
            [manager syncFindPhoneWithOpenFlag:message.findPhone callback:^(NSError *error) {
                callBlock(error == nil);
            }];
        }];
    }];
}


#pragma mark -
- (void)alertMesg:(NSString *)mesg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows.lastObject animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.numberOfLines = 0;
    hud.label.text = mesg;
    [hud hideAnimated:YES afterDelay:1.0];
}

- (void)alertMesgError:(NSError *)error {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows.lastObject animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.numberOfLines = 0;
    hud.label.text = [error.userInfo valueForKey:NSLocalizedFailureReasonErrorKey];
    [hud hideAnimated:YES afterDelay:1.0];
}

@end
