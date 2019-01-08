//
//  QNCentralManager.h
//  QNCentralModule
//
//  Created by donyau on 2018/9/12.
//  Copyright © 2018年 Yolanda. All rights reserved.
//  3.7.3

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "QNCentralEnum.h"
#import "QNConnectConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^QNCentralResponseBlock)(BOOL success, NSError *__nullable error);

@protocol QNCentralManagerDelegate <NSObject>
@optional

/**
 蓝牙状态的更新

 @param state QNBlueToothState
 */
- (void)centralManagerBlueToothUpdateState:(QNBlueToothState)state;

/**
 返回当前连接的设备

 @return 外设
 */
- (nullable CBPeripheral *)centralManagerConnectionPeripheral;

/**
 重要的调试信息输出

 @param message NSString
 */
- (void)centralManagerMessage:(NSString *)message;


/**
 扫描操作的回调

 @param scanState QNCentralScanState
 */
- (void)centralScanStateUpdate:(QNCentralScanState)scanState;

/******************************************** 外部不需操作 ********************************************/

/**
 发现设备

 @param peripheral CBPeripheral
 @param advertisementData NSDictionary<NSString *,id>
 @param rssi NSNumber
 */
- (void)centralDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData rssi:(NSNumber *)rssi;


/**
 连接状态的更新

 @param state QNPeripheralState
 @param peripheral CBPeripheral
 @param error NSError
 */
- (void)centralManagerPeripheralUpdateState:(QNPeripheralState)state peripheral:(CBPeripheral *)peripheral error:(NSError *__nullable)error;

@end



/******************************************** 外部需操作 ********************************************/
@interface QNCentralManager : NSObject

/**
 * 日志头[** %02d:%02d:%02d.%03d [头]] **]
 * 当logheader为空字符串时，只有时间前缀
 * 当logheader为空时，时间前缀也没有，直接输出信息
 */
@property (nonatomic, strong, class) NSString *logHeader;
/** 设置调试日志*/
@property (nonatomic, assign, class) BOOL debug;
/** log前缀*/
@property (nonatomic, assign, class) BOOL logPrefix;

@property (nonatomic, weak) id<QNCentralManagerDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isScanning NS_AVAILABLE_IOS(9_0);


/**
 获取当前系统蓝牙的状态
 
 @return QNBLEBlueToothState
 */
- (QNBlueToothState)currentBlueTooth;


/**
 初始化方法

 @return QNCentralManager
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 初始化中心管理类

 @param centralManager CBCentralManager 当中心类参数未nil时，会取上次初始化的中心类，如果是第一次调用内部会自动创建。但中心类参数不未nil时，每次初始化都会启用新的中心类。重新初始化后，前面扫描到的设备会无法连接，需要重新扫描
 @param showPowerAlert 是否弹框提示蓝牙开关(centralManager传值时，设置该值无效)
 @param queue dispatch_queue_t
 @return QNCentralManager
 */
- (instancetype)initCentralManager:(nullable CBCentralManager *)centralManager showPowerAlertFlag:(BOOL)showPowerAlert queue:(nullable dispatch_queue_t)queue;

/**
 开始扫描设备
 
 @param block 操作结果回调
 */
- (void)scanDeviceHandle:(nullable QNCentralResponseBlock)block;

/**q
 停止扫描设备
 */
- (void)stopScanDevice;

@end

/******************************************** 外部不需操作 ********************************************/
@interface QNCentralManager (Addition)
/**
 重要信息的输出
 
 @param message message
 */
- (void)logMessage:(NSString *)message;

/**
 获取蓝牙状态的错误

 当蓝牙状态为打开时，不会返回错误，其他状态均会返回相应的错误
 
 @return 错误信息
 */
- (nullable NSError *)blueToothStateError;

/**
 连接设备
 
 @param peripheral 外设
 @param config 连接设置
 @param block 状态回调
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral connectConfig:(QNConnectConfig *)config response:(nullable QNCentralResponseBlock)block;

/**
 断开设备连接
 
 @param peripheral 外设
 @param block 状态回调
 */
- (void)cancelConnectDevicePeripheral:(CBPeripheral *)peripheral response:(nullable QNCentralResponseBlock)block;


/**
 从系统获取已经连接的设备

 @param serviceUUIDs serviceUUIDs
 @return NSArray<CBPeripheral *>
 */
- (NSArray<CBPeripheral *> *)findConnectedPeripheralFromSystemWithServices:(NSArray<CBUUID *> *)serviceUUIDs;
@end

NS_ASSUME_NONNULL_END
