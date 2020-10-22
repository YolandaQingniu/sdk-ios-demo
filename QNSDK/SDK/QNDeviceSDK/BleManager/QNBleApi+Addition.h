//
//  QNBleApi+Addition.h
//  QNDeviceSDK
//
//  Created by JuneLee on 2019/9/18.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "QNBleApi.h"
#import <objc/runtime.h>
#import "QNAPIConst.h"
#import "QNDataCypher.h"
#import "QNBleDevice+QNAddition.h"
#import "NSError+QNAPI.h"
#import "QNCentralModule.h"
#import "QNDebug.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNBleApi (Addition)<QNCentralManagerDelegate>
/** 蓝牙管理类 */
@property (nonatomic, strong) QNCentralManager *centralManager;
@property(nonatomic, strong) NSMutableArray<QNBleDevice *> *deviceList;
///** 当前连接的设备 */
@property (nonatomic, strong, nullable) QNBleDevice *connectDevice;
/* 是否已连接设备 */
@property (nonatomic, assign) BOOL connectDeviceFlag;

@property (nonatomic, strong, nullable) NSTimer *scanTimer;

/** 储存数据临时保存数据 */
@property (nonatomic, strong) NSMutableArray<QNScaleStoreData *> *storageAll;

/* 用户扫描意图 */
@property (nonatomic, assign) BOOL scanBehaviorFlag;

/**
 自己的蓝牙协议代理类
 可在 QNBleProtocolDelegate.h 中查看详细信息

 非自主管理蓝牙不需要实现该代理
 
 */
@property (nonatomic, weak) id<QNBleProtocolDelegate> bleProtocolListener;


//- (nullable QNBleDevice *)getDeviceWithMac:(NSString  *)mac;

- (nullable QNBleDevice *)getBleDeviceWithMac:(NSString *)mac;

- (void)cancelScanTimer;
- (void)privateStopBleDeviceWithMac:(NSString *)mac isCallback:(BOOL)isCallback resultCallback:(nullable QNResultCallback)callback;


- (void)handleRealTimeWeight:(double)weight connectDevice:(QNBleDevice *)device;
- (void)handleResultDataCypher:(QNDataCypher *)dataCypher connectDevice:(QNBleDevice *)device isCalculate:(BOOL)isCalculate;
- (void)handleStoragDataCypher:(QNDataCypher *)dataCypher connectDevice:(QNBleDevice *)device user:(nullable QNUser *)user isComplete:(BOOL)isComplete;
- (void)receiveStorageDataCompleteWithMac:(NSString *)mac;


@end

NS_ASSUME_NONNULL_END
