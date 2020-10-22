//
//  QNConfig.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/27.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 秤端体重单位的显示

 - QNUnitKG: 所有的设备都支持该单位的显示
 - QNUnitLB: 若设备不支持该单位的显示，即便设置为 "QNUnitLB" 类型也会显示 "QNUnitKG" 类型
 - QNUnitJIN: 若设备不支持该单位的显示，即便设置为 "QNUnitJIN" 类型也会显示 "QNUnitKG" 类型
 - QNUnitST: 若设备不支持该单位的显示，而支持 "QNUnitLB" 的显示，则会显示 "QNUnitLB", 倘若 "QNUnitLB" 也不支持，则会显示 "QNUnitKG"
 */
typedef NS_ENUM(NSUInteger, QNUnit) {
    QNUnitKG = 0,
    QNUnitLB = 1,
    QNUnitJIN = 2,
    QNUnitST = 3,
    
    QNUnitG = 10, //厨房秤专属
    QNUnitML = 11, //厨房秤专属
    QNUnitOZ = 12, //厨房秤专属
    QNUnitLBOZ = 13, //厨房秤专属
};

/**
 该QNConfig类，用户设置后，SDK会自动保存设置信息，当再次用到类中的设置信息时，会采用用户上次设置的信息
 */
@interface QNConfig : NSObject

/** 是否只返回已开机（亮屏）的设备，默认为false */
@property (nonatomic, assign) BOOL onlyScreenOn;

/** 同一个设备是否返回多次，默认为false , 该设置对广播秤无效*/
@property (nonatomic, assign) BOOL allowDuplicates;

/**
 扫描持续时间,单位 ms，默认为0，即一直进行扫描，除非APP调用了stopBleDeviceDiscovery
 不为0时，最小值为3000ms，延时 duration ms的时间后，自动停止扫描
 */
@property (nonatomic, assign) int duration;

/** 端显示的单位，不设置的话，SDK默认为kg，设置后会保存本地，如果当前已经连接设备，会尽量实时更新秤端的单位显示 ，该设置对广播秤无效，广播秤修改单位请前往【QNBleBroadcastDevice】*/
@property (nonatomic, assign) QNUnit unit;

/**
 该设置只有在 调用 "- (void)initSdk:(NSString *)appId firstDataFile:(NSString *)dataFile callback:(QNResultCallback)callback" 方法前设置才有效，若在调用该方法后面再设置，SDK会在下次重新启动SDK的时候自动配置该设置.
 该属性的作用详情请参考Apple Developer Documenttation => CoreBluetooth => CBCentralManager =>  Central Manager Initialization Options
 */
@property (nonatomic, assign) BOOL showPowerAlertKey;

/**
 强化广播秤信号
 */
@property (nonatomic, assign) BOOL enhanceBleBoradcast;

/// 保存设置信息
- (BOOL)save;

- (instancetype)init NS_UNAVAILABLE;

@end
