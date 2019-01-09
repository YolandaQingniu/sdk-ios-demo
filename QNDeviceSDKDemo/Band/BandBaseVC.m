//
//  BandBaseVC.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/8.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandBaseVC.h"
#import "AppDelegate.h"

@interface BandBaseVC ()<QNBleStateListener,QNBleConnectionChangeListener,QNBleDeviceDiscoveryListener,QNDataListener>

@end

@implementation BandBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    QNBleApi *bleApi = [QNBleApi sharedBleApi];
    bleApi.bleStateListener = self;
    bleApi.connectionChangeListener = self;
    bleApi.discoveryListener = self;
    bleApi.dataListener = self;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.bandDevice == nil) {
        [self startScanDevice];
    }
}

- (void)startScanDevice {
    [[QNBleApi sharedBleApi] startBleDeviceDiscovery:^(NSError *error) {
        
    }];
    
    BandMessage *message = [BandMessage sharedBandMessage];
    
    [[QNBleApi sharedBleApi] findPairBandWithMac:message.mac modeId:message.modeId uuidIdentifier:message.uuidString callback:^(NSError *error) {
        
    }];
}

- (void)onBleSystemState:(QNBLEState)state {
    if (state != QNBLEStatePoweredOn) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.bandDevice = nil;
    }
}

- (void)onDeviceDiscover:(QNBleDevice *)device {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.bandDevice || [[BandMessage sharedBandMessage].mac isEqualToString:device.mac] == NO) nil;
    delegate.bandDevice = device;
    QNBleApi *api = [QNBleApi sharedBleApi];
    __weak typeof(self) weakSelf = self;
    [api stopBleDeviceDiscorvery:^(NSError *error) {
        
    }];
    [api connectDevice:device user:nil callback:^(NSError *error) {
        if (error) {
            delegate.bandDevice = nil;
            [weakSelf startScanDevice];
        }
    }];
}

- (void)onDeviceStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([device.mac isEqualToString:delegate.bandDevice.mac] == NO) return;
    if (state == QNScaleStateDisconnected || state == QNScaleStateLinkLoss || state == QNScaleStateLinkLoss) {
        delegate.bandDevice = nil;
        [self startScanDevice];
    }
    
    if (state == QNScaleStateInteraction) {
        [self syncLocalSet];
    }
}

- (void)strikeTakePhotosWithDevice:(QNBleDevice *)device {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.contentMode = MBProgressHUDModeText;
    hud.label.text = @"收到拍照指令";
    [hud hideAnimated:YES afterDelay:1];
}

- (void)strikeFindPhoneWithDevice:(QNBleDevice *)device {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.contentMode = MBProgressHUDModeText;
    hud.label.text = @"收到查找手机指令";
    [hud hideAnimated:YES afterDelay:1];
}

- (void)syncLocalSet {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步设置...";
    QNBandManager *manager = [[QNBleApi sharedBleApi] getBandManager];
    [[[[[[[[[FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        //同步时间
        [manager syncBandTimeWithDate:[NSDate date] callback:^(NSError *error) {
            fulfill(nil);
        }];
    }] then:^FBLPromise *(id  _Nullable value) {
        //版本等信息
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
            [manager fetchBandInfo:^(QNBandInfo *info, NSError *error) {
                if (error == nil) {
                    [BandMessage sharedBandMessage].firmwareVer = info.firmwareVer;
                    [BandMessage sharedBandMessage].hardwareVer = info.hardwareVer;
                    [BandMessage sharedBandMessage].battery = info.electric;
                }
                fulfill(nil);
            }];
        }];
    }] then:^FBLPromise *(id  _Nullable value) {
        //第三方提醒
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
            [manager setThirdRemind:[BandMessage sharedBandMessage].thirdRemind callback:^(NSError *error) {
                fulfill(nil);
            }];
        }];
    }] then:^FBLPromise *(id  _Nullable value) {
        //检测与上次绑定手机是否相同
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
            [manager checkSameBindPhone:^(NSNumber *sameNumber, NSError *error) {
                if (error == nil && [sameNumber boolValue] == NO) {
                    fulfill(nil);
                }else {
                    reject(error ? error : [NSError errorWithDomain:@"SDKSynLocalSet" code:1001 userInfo:@{NSLocalizedDescriptionKey : @"与上次绑定手机相同"}]);
                }
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        //不相同时清除设置
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
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
                fulfill(nil);
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        //设置久坐提醒
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
            [manager syncSitRemind:[BandMessage sharedBandMessage].sitRemind callback:^(NSError *error) {
                fulfill(nil);
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        NSString *modeId = [BandMessage sharedBandMessage].modeId;
        int firmwareVer = [BandMessage sharedBandMessage].firmwareVer;
        if ([modeId isEqualToString:@"0000"] || [modeId isEqualToString:@"0001"] || [modeId isEqualToString:@"0002"] || ([modeId isEqualToString:@"0003"] && firmwareVer < 12)) {
            return [self setBandLocalMessage:manager];
        }else {
            return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
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
                    fulfill(nil);
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
            FBLPromise *promise = [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
                [manager syncAlarm:alarms.firstObject callback:^(NSError *error) {
                    fulfill(nil);
                }];
            }];
            
            for (int i = 1; i < alarms.count; i ++) {
                promise = [promise then:^id _Nullable(id  _Nullable value) {
                    return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
                        [manager syncAlarm:alarms[i] callback:^(NSError *error) {
                            fulfill(nil);
                        }];
                    }];
                }];
            }
            return promise;
        }
    }] always:^{
        hud.label.text = @"设置同步完成";
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (FBLPromise *)setBandLocalMessage:(QNBandManager *)manager {
    BandMessage *message = [BandMessage sharedBandMessage];
   return [[[[[[FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
        //用户信息
       [manager syncUser:message.user callback:^(NSError *error) {
           fulfill(nil);
       }];
    }] then:^FBLPromise *(id  _Nullable value) {
        //心率开关
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
            [manager syncHeartRateObserverModeWithAutoFlag:message.heartRateObserver callback:^(NSError *error) {
                fulfill(nil);
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        //抬腕亮屏
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
            [manager syncHandRecognizeModeWithOpenFlag:message.handRecognize callback:^(NSError *error) {
                fulfill(nil);
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        //度量
        QNBandMetrics *metrics = [[QNBandMetrics alloc] init];
        metrics.language = message.language;
        metrics.length = message.length;
        metrics.formatHour = message.hourFormat;
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
            [manager syncMetrics:metrics callback:^(NSError *error) {
                fulfill(nil);
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        //目标
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
            [manager syncGoal:message.sportGoal callback:^(NSError *error) {
                fulfill(nil);
            }];
        }];
    }] then:^id _Nullable(id  _Nullable value) {
        //查找手机
        return [FBLPromise async:^(FBLPromiseFulfillBlock  _Nonnull fulfill, FBLPromiseRejectBlock  _Nonnull reject) {
            [manager syncFindPhoneWithOpenFlag:message.findPhone callback:^(NSError *error) {
                fulfill(nil);
            }];
        }];
    }];
}


@end
