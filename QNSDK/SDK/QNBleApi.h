//
//  QNBleApi.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "QNBleStateProtocol.h"
#import "QNBleDeviceDiscoveryProtocol.h"
#import "QNBleConnectionChangeProtocol.h"
#import "QNScaleDataProtocol.h"
#import "QNLogProtocol.h"
#import "QNUser.h"
#import "QNConfig.h"
#import "QNWiFiConfig.h"
#import "QNBleProtocolDelegate.h"
#import "QNBleProtocolHandler.h"
#import <CoreBluetooth/CoreBluetooth.h>

/**
 此SDK为轻牛旗下设备连接工具的静态库，使用时需要向轻牛官方获取 "appId" 否则无法正常使用该SDK
 
 当前版本【 1.0.0-beta.1 】
 
 SDK最低配置8.0的系统
 
 工程的配置说明:
 1.苹果官方规定在iOS10.0以后（包括10.0）必须在Info.plist中有对 "Privacy - Bluetooth Peripheral Usage Description" 键 进行蓝牙的使用说明，否则无法使用系统蓝牙
 2.引入SDK路径 【TARGETS】-> 【Build Setting】->【Search Paths】->【LibrarySearch Paths】中添加SDK路径
 3.配置链接器 【TARGETS】-> 【Build Setting】-> 【Linking】-> 【Other Linker Flags】中添加 "-ObjC"、"-all_load"、"-force_load [SDK路径]" 其中之一
 
 
 秤测量方法说明：
 1. 必须光脚测量，才能测到人体生物阻抗
 
 
 关于秤数据的说明：
 1. 在连接上秤的时候测量，测量完毕后数据会立即上传
 2. 在未连接秤的时候测量，测量数据会自动存储到秤端，详细说明请参考"QNScaleStoreData"存储数据类
 
 秤有广播的两种情况:
 1. 秤亮屏的时候，会发出广播
 2. 当秤有存储数据的时候，即使秤处于灭屏的状态下也会发广播
 
 
 使用流程:
 一、普通蓝牙秤：
     1. 使用"+ (QNBleApi *)sharedBleApi"初始化SDK
     2. 是否需要系统的蓝牙弹框（此弹框是系统在初始化蓝牙管理的时候会判断蓝牙是否打开，如果蓝牙为关闭状态，系统会自动弹框提示）,如果需要先调用"- (QNConfig *)getConfig"方法获取配置项，然后直接设置对应的属性，如果不需要弹框，直接跳过该步
     2. 使用"- (void)initSdk:(NSString *)appId firstDataFile:(NSString *)dataFile callback:(QNResultCallback)callback"注册SDK
     3. 遵循相应的代理并实现相应的代理方法
     4. 调用"- (QNConfig *)getConfig"方法获取配置项，设置相应的开关，比如返回的设备类型、统一个设备是否返回多次等，该步也可以在第二步的时候一并设置
     4. 调用扫描方法 "- (void)startBleDeviceDiscovery:(QNResultCallback)callback",app处理扫描的设备（比如加入数组实现列表扫描到设备等）
     5. 调用连接方法，连接相应的设备 "- (void)connectDevice:(QNBleDevice *)device user:(QNUser *)user callback:(QNResultCallback)callback"
     6. 代理方法回调测量的各个状态、存储数据、实时体重、测量结果等数据
     7. 测量完毕后，可调用"- (void)disconnectDevice:(QNBleDevice *)device callback:(QNResultCallback)callback"方法，断开设备的连接
 
 二、普通蓝牙秤-自主管理蓝牙：
     1. 自己初始化蓝牙中心管理类，并设置代理实现相应的代理方法
     2. 使用"+ (QNBleApi *)sharedBleApi"初始化SDK
     3. 遵循dataListener,bleProtocolListener代理并实现方法
     4. 遵循bleProtocolListener的代理并实现方法，表示在解析数据时，需要回传方法，让demo自行写入数据
     5. 自行操作扫描、连接、断开等方法
     6. 在发现外设时，调用"- (QNBleDevice *)buildDevice:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData callback:(QNResultCallback)callback" 或者
        "- (QNBleBroadcastDevice *)buildBroadcastDevice:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData callback:(QNResultCallback)callback"(广播秤)，
        构建设备
     7. 点击一个设备进行连接，并调用 "- (QNBleProtocolHandler *)buildProtocolHandler:(QNBleDevice *)device user:(QNUser *)user delegate:(id<QNBleProtocolDelegate>)delegate callback:(QNResultCallback)callback"方法，初始化协议处理器
     8. 收到秤端数据后，调用"- (void)onGetBleData:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID data:(NSData *)data"方法，让SDK解析数据
     9. 解析到的数据通过 QNScaleDataListener 代理回调测量的各个状态、存储数据、实时体重、测量结果等数据
     10. 测量完毕后，可自行断开设备连接
 */

@interface QNBleApi : NSObject

/** 是否打开调试开关 默认为NO (建议发布版本时,设置为NO) */
@property (nonatomic, assign, class) BOOL debug;

/**
 发现设备监听，该监听必须实现，否则无法获取搜索到的设备信息
 可在 QNBleDeviceDiscorveryProtocol.h 中查看详细信息
 
 */
@property (nonatomic, weak) id<QNBleDeviceDiscoveryListener> discoveryListener;

/**
 设备状态的监听
 可在 QNBleConnectionChangeProtocol.h 中查看详细信息
 
 */
@property (nonatomic, weak) id<QNBleConnectionChangeListener> connectionChangeListener;


/**
 日志信息监听
 不需要收集日志时，可忽略该监听
 此处监听的回调不受 debug 开关的控制
 */
@property(nonatomic, weak) id<QNLogProtocol> logListener;

/**
 测量数据的监听，该监听必须实现
 可在 QNScaleDataProtocol.h 中查看详细信息
 
 */
@property (nonatomic, weak) id<QNScaleDataListener> dataListener;

/**
 系统蓝牙状态的监听
 可在 QQNBleStateProtocol.h 中查看详细信息
 
 */
@property (nonatomic, weak) id<QNBleStateListener> bleStateListener;

/**
 自己的蓝牙协议代理类
 可在 QNBleProtocolDelegate.h 中查看详细信息
 
 */
@property (nonatomic, weak) id<QNBleProtocolDelegate> bleProtocolListener;

/** 当前SDK版本 */
@property (nonatomic, strong) NSString *sdkVersion;

/**
 初始化SDK
 
 @return QNBleApi
 */
+ (QNBleApi *)sharedBleApi;


/**
 注册SDK
 必须先注册SDK后使用其他操作
 appid以及初始配置文件请向轻牛官方洽谈
 
 @param appId 需要向官方获取正确的appid
 @param dataFile 配置文件路径
 @param callback 结果回调
 */
- (void)initSdk:(NSString *)appId firstDataFile:(NSString *)dataFile callback:(QNResultCallback)callback;


/**
 扫描设备
 
 @param callback 结果回调
 */
- (void)startBleDeviceDiscovery:(QNResultCallback)callback;


/**
 停止扫描
 
 @param callback 结果回调
 */
- (void)stopBleDeviceDiscorvery:(QNResultCallback)callback;


/**
 连接设备
 
 @param device 连接的设备(该设备对象必须是搜索返回的设备对象)
 @param user 用户信息
 @param callback 结果回调
 */
- (void)connectDevice:(QNBleDevice *)device user:(QNUser *)user callback:(QNResultCallback)callback;

/**
 断开设备的连接
 
 @param device 当前连接的设备(可不传)
 @param callback 结果回调
 */
- (void)disconnectDevice:(QNBleDevice *)device callback:(QNResultCallback)callback;

/**
 
 对WiFi双模设备进行配网

 @param device 需要配网的设备
 @param user 用户信息
 @param wifiConfig 配网的WiFi信息
 @param callback 配网操作的回到  您可以通过监听“- (void)onScaleStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state”方法获取配网的结果
 */
- (void)connectDeviceSetWiFiWithDevice:(QNBleDevice *)device user:(QNUser *)user wifiConfig:(QNWiFiConfig *)wifiConfig callback:(QNResultCallback)callback;

///**
// 向轻牛云注册WiFi蓝牙双模秤
// 
// 目前只允许注册WiFi蓝牙双模秤
//
// @param device QNBleDevice
// @param callback 注册结果
// */
//- (void)registerWiFiBleDevice:(QNBleDevice *)device callback:(QNResultCallback)callback;


/**
 获取SDK的当前设置情况
 
 @return QNConfig
 */
- (QNConfig *)getConfig;


/**
 根据提供的kg数值的体重，转化为指定单位的数值
 
 @param kgWeight kg单位的体重
 @param unit QNUnit kg、lb，所有秤都能够支持这个单位; 斤，秤端如果不支持，则会显示kg (不支持ST的转换)
 @return 结果回调
 */
- (double)convertWeightWithTargetUnit:(double)kgWeight unit:(QNUnit)unit;

/**
 建立用户模型
 
 @param userId 用户id
 @param height 用户身高
 @param gender 用户性别 male female
 @param birthday 用户的出生日期 age 3~80
 @param callback 结果的回调
 @return QNUser
 */
- (QNUser *)buildUser:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday callback:(QNResultCallback)callback;

/**
 创建SDK蓝牙对象
 
 @param peripheral 外设对象
 @param advertisementData 蓝牙广播数据
 @param callback 结果的回调
 @return QNBleDevice
 */
- (QNBleDevice *)buildDevice:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData callback:(QNResultCallback)callback;

/**
 创建轻牛广播蓝牙秤设备对象
 
 @param peripheral 外设对象
 @param advertisementData 蓝牙广播数据
 @param callback 结果的回调
 @return QNBleBroadcastDevice
 */
- (QNBleBroadcastDevice *)buildBroadcastDevice:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData callback:(QNResultCallback)callback;

/**
 创建蓝牙协议处理器
 
 @param device 设备
 @param user 用户模型
 @param delegate 协议处理类
 @param callback 结果的回调
 @return QNBleProtocolHandler
 */
- (QNBleProtocolHandler *)buildProtocolHandler:(QNBleDevice *)device user:(QNUser *)user wifiConfig:(QNWiFiConfig *)wifiConfig delegate:(id<QNBleProtocolDelegate>)delegate callback:(QNResultCallback)callback;

@end

