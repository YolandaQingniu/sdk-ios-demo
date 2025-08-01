//
//  QNBleApi.h
//  QNDeviceSDK
//
//  Created by com.qn.device on 2018/1/9.
//  Copyright © 2018年 com.qn.device. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "QNBleStateProtocol.h"
#import "QNBleDeviceDiscoveryProtocol.h"
#import "QNBleConnectionChangeProtocol.h"
#import "QNScaleDataProtocol.h"
#import "QNBleKitchenProtocol.h"
#import "QNLogProtocol.h"
#import "QNUser.h"
#import "QNConfig.h"
#import "QNWiFiConfig.h"
#import "QNBleProtocolDelegate.h"
#import "QNBleProtocolHandler.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "QNWspConfig.h"
#import "QNUserScaleConfig.h"
#import "QNBleKitchenConfig.h"
#import "QNBleOTAProtocol.h"
#import "QNBleRulerProtocol.h"

/**
 此SDK为轻牛旗下设备连接工具的静态库，使用时需要向轻牛官方获取 "appId" 否则无法正常使用该SDK
 
 当前版本【 2.24.1 】
 
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
 
 */

@interface QNBleApi : NSObject

/** 是否打开调试开关 默认为NO (建议发布版本时,设置为NO) */
@property (nonatomic, assign, class) BOOL debug;

/**
 系统蓝牙状态的监听
 可在 QNBleStateProtocol.h 中查看详细信息
 
 */
@property (nonatomic, weak) id<QNBleStateListener> bleStateListener;

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
 测量数据的监听，该监听必须实现
 可在 QNScaleDataProtocol.h 中查看详细信息
 
 */
@property (nonatomic, weak) id<QNScaleDataListener> dataListener;

/**
 蓝牙厨房秤测量数据的监听
 可在 QNBleKitchenDataProtocol.h 中查看详细信息
 
 */
@property (nonatomic, weak) id<QNBleKitchenListener> bleKitchenListener;

/**
 日志信息监听
 不需要收集日志时，可忽略该监听
 此处监听的回调不受 debug 开关的控制
 */
@property(nonatomic, weak) id<QNLogProtocol> logListener;

/**
 升级固件的监听(WSP专属)
 可在 QNBleOTAProtocol.h 中查看详细信息
 
 */
@property (nonatomic, weak) id<QNBleOTAListener> bleOTAListener;

/**
 蓝牙围度监听
 可在 QNBleRulerProtocol.h 中查看详细信息
 
 */
@property (nonatomic, weak) id<QNBleRulerListener> bleRulerListener;

/**
 初始化SDK
 
 @return QNBleApi
 */
+ (QNBleApi *)sharedBleApi;

/**
 初始化SDK：注册SDK +  初始化蓝牙管理类，等效于“registerSdk” + “initBleManager”
 必须先注册SDK后使用其他操作
 appid以及初始配置文件请向轻牛官方洽谈
 
 @param appId 需要向官方获取正确的appid
 @param dataFile 配置文件路径
 @param callback 结果回调
 */
- (void)initSdk:(NSString *)appId firstDataFile:(NSString *)dataFile callback:(QNResultCallback)callback;

/**
 初始化SDK：注册SDK + 初始化蓝牙管理类，等效于“registerSdk” + “initBleManager”
 必须先注册SDK后使用其他操作
 appid以及初始配置文件请向轻牛官方洽谈
 
 @param appId 需要向官方获取正确的appid
 @param dataFileContent 配置文件内容
 @param callback 结果回调
 */
- (void)initSdk:(NSString *)appId dataFileContent:(NSString *)dataFileContent callback:(QNResultCallback)callback;


/// 注册SDK（初始化SDK分为两步，满足某些客户需要在特定页面（例如二级页面）才去授权并使用蓝牙功能的场景，第一步是注册SDK，即registerSdk，第二步是初始化蓝牙管理类，即initBleManager）
/// @param appId 授权appid，如果没有，则需要向官方获取正确的appid
/// @param dataFile 授权文件，官方授权后会提供授权文件
/// @param callback 结果回调
- (void)registerSdk:(NSString *)appId firstDataFile:(NSString *)dataFile callback:(QNResultCallback)callback;

/// 注册SDK（初始化SDK分为两步，满足某些客户需要在特定页面（例如二级页面）才去授权并使用蓝牙功能的场景，第一步是注册SDK，即registerSdk，第二步是初始化蓝牙管理类，即initBleManager）
/// @param appId appId 授权appid，如果没有，则需要向官方获取正确的appid
/// @param dataFileContent 授权文件内容，官方授权后会提供授权文件
/// @param callback 结果回调
- (void)registerSdk:(NSString *)appId dataFileContent:(NSString *)dataFileContent callback:(QNResultCallback)callback;

/// 初始化蓝牙管理类（该操作之前，需要先注册SDK，即registerSdk方法）
/// @param callback 结果回调
- (void)initBleManagerWithCallback:(QNResultCallback)callback;

/**

 获取当前系统蓝牙转台

@return QNUser
*/
- (QNBLEState)getCurSystemBleState;

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
 连接轻牛用户秤设备
 
 @param device 需要连接的蓝牙设备
 @param config 连接用户秤设备时的配置项
 @param callback 结果回调
 */
- (void)connectUserScaleDevice:(QNBleDevice *)device config:(QNUserScaleConfig *)config callback:(QNResultCallback)callback;

/**
 连接轻牛Wsp设备
 
 @param device 需要连接的蓝牙设备
 @param config 连接wsp设备时的配置项
 @param callback 结果回调
 */
- (void)connectWspDevice:(QNBleDevice *)device config:(QNWspConfig *)config callback:(QNResultCallback)callback;

/**
 断开设备的连接
 
 @param device 当前连接的设备
 @param callback 结果回调
*/
- (void)disconnectDevice:(QNBleDevice *)device callback:(QNResultCallback)callback;

/**
 断开设备的连接
 @param mac 当前连接的设备mac
 @param callback 结果回调
 */
- (void)disconnectDeviceWithMac:(NSString *)mac callback:(QNResultCallback)callback;

/**
 
 对WiFi双模设备进行配网

 @param device 需要配网的设备
 @param user 用户信息
 @param wifiConfig 配网的WiFi信息
 @param callback 配网操作的回到  您可以通过监听“- (void)onScaleStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state”方法获取配网的结果
 */
- (void)connectDeviceSetWiFiWithDevice:(QNBleDevice *)device user:(QNUser *)user wifiConfig:(QNWiFiConfig *)wifiConfig callback:(QNResultCallback)callback;

/**
 向轻牛云注册WiFi蓝牙双模秤

 目前只允许注册WiFi蓝牙双模秤

 @param device QNBleDevice
 @param callback 注册结果
 */
- (void)registerWiFiBleDevice:(QNBleDevice *)device callback:(QNResultCallback)callback;

/**
 获取SDK的当前设置情况
 
 @return QNConfig
 */
- (QNConfig *)getConfig;

/**
 根据提供的kg数值的体重，转化为指定单位的数值
 
 @param weight 默认单位的重量（体脂秤为KG 、厨房秤为G）
 @param unit  KG、LB、JIN、ST、STLB 为体脂秤单位 (不支持ST的转换，查询文档获取相关转化方法)  G、ML、OZ、LBOZ 为厨房秤单位（不支持LBOZ的转换查询文档获取相关转化方法）
 @return 结果回调
 */
- (double)convertWeightWithTargetUnit:(double)weight unit:(QNUnit)unit;

/**
 根据提供的kg数值的体重，转化为指定单位的数值
 
 @param weight 默认单位的重量（体脂秤为KG）
 @param unit  KG、LB、JIN、ST、STLB 为体脂秤单位 (不支持ST的转换，查询文档获取相关转化方法)  
 @return 结果回调
 */
- (double)convertWeight:(double)weight unit:(QNUnit)unit;

/**
 建立用户模型
 
 @param userId 用户id
 @param height 用户身高
 @param gender 用户性别 male female
 @param birthday 用户的出生日期
 @param callback 结果的回调
 @return QNUser
 */
- (QNUser *)buildUser:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday callback:(QNResultCallback)callback;

/**
 创建SDK蓝牙对象
 
 @param peripheral 外设对象
 @param rssi 信号强度
 @param advertisementData 蓝牙广播数据
 @param callback 结果的回调
 @return QNBleDevice
 */
- (QNBleDevice *)buildDevice:(CBPeripheral *)peripheral rssi:(NSNumber *)rssi advertisementData:(NSDictionary *)advertisementData callback:(QNResultCallback)callback;

/**
 创建轻牛广播蓝牙秤设备对象
 
 @param peripheral 外设对象
 @param rssi 信号强度
 @param advertisementData 蓝牙广播数据
 @param callback 结果的回调
 @return QNBleBroadcastDevice
 */
- (QNBleBroadcastDevice *)buildBroadcastDevice:(CBPeripheral *)peripheral rssi:(NSNumber *)rssi advertisementData:(NSDictionary *)advertisementData callback:(QNResultCallback)callback;

/**
 创建轻牛厨房广播蓝牙秤设备对象
 
 @param peripheral 外设对象
 @param rssi 信号强度
 @param advertisementData 蓝牙广播数据
 @param callback 结果的回调
 @return QNBleKitchenDevice
 */
- (QNBleKitchenDevice *)buildKitchenDevice:(CBPeripheral *)peripheral rssi:(NSNumber *)rssi advertisementData:(NSDictionary *)advertisementData callback:(QNResultCallback)callback;

/**
 创建蓝牙协议处理器
 
 @param device 设备
 @param user 用户模型
 @param delegate 协议处理类
 @param callback 结果的回调
 @return QNBleProtocolHandler
 */
- (QNBleProtocolHandler *)buildProtocolHandler:(QNBleDevice *)device user:(QNUser *)user wifiConfig:(QNWiFiConfig *)wifiConfig delegate:(id<QNBleProtocolDelegate>)delegate callback:(QNResultCallback)callback;

/**
 连接蓝牙厨房秤
 
 @param device 连接的设备(该设备对象必须是搜索返回的蓝牙厨房秤设备对象)
 @param callback 结果回调
 */
- (void)connectBleKitchenDevice:(QNBleKitchenDevice *)device callback:(QNResultCallback)callback;

/**
 设置蓝牙厨房秤信息
 
 @param config 设置信息
 */
- (void)setBleKitchenDeviceConfig:(QNBleKitchenConfig *)config;

/**
 连接蓝牙围度尺
 
 @param device 连接的设备(该设备对象必须是搜索返回的蓝牙围度尺设备对象)
 @param callback 结果回调
 */
- (void)connectRulerDevice:(QNBleRulerDevice *)device callback:(QNResultCallback)callback;

/**
 WSP设备恢复出厂设置

 @param callback 结果的回调
 */
- (void)restoreFactorySettingsCallback:(QNResultCallback)callback;

/**
 生成测量数据方法（该方法只支持wsp设备使用）

 @param user 该条数据的所属用户
 @param modeId 型号标识
 @param weight 体重。单位为kg
 @param measureDate 测量时间
 @param resistance 50阻抗
 @param secResistance 500阻抗
 @param hmac 加密字段
 @param heartRate 心率值，若无则赋值0
 @return QNScaleData
*/
- (QNScaleData *)generateScaleData:(QNUser *)user modeId:(NSString *)modeId weight:(double)weight date:(NSDate *)measureDate resistance:(int)resistance secResistance:(int)secResistance hmac:(NSString *)hmac heartRate:(int)heartRate;

/**
 重算测量数据
 @param user 该条数据的所属用户
 @param resistance 50阻抗
 @param secResistance 500阻抗
 @param hmac 加密字段
 @param callback 构建结果
 */
- (QNScaleData *)recalculateScaleData:(QNUser *)user resistance:(NSInteger)resistance secResistance:(NSInteger)secResistance hmac:(NSString *)hmac callback:(QNResultCallback)callback;

/// 重算数据指标
/// @param user 重算数据指标的目标用户
/// @param hmac 重算数据的hmac
/// @param lastEightHmac 上次测量数据的hmac，八电极设备拟合要用
/// @param callback 回调
- (QNScaleData *)calculateScaleDataByHmac:(QNUser *)user hmac:(NSString *)hmac lastEightHmac:(nullable NSString *)lastEightHmac callback:(QNResultCallback)callback;

/**
 体质推算测量方法

 @param user 该条数据的所属用户
 @param area 区域
 @param weight 体重。单位为kg
 @param measureDate 测量时间
 @return QNScaleData
*/
- (QNScaleData *)physiqueCalculation:(QNUser *)user area:(QNAreaType)area weight:(double)weight date:(NSDate *)measureDate;

/// 切换用户秤访问用户
/// @param user 用户信息
/// @param callback 结果的回调
- (void)switchUserScaleUser:(QNUser *)user callback:(QNResultCallback)callback;

/// 更新用户秤用户识别体重
/// @param weight 体重
/// @param callback 结果的回调
- (void)updateUserScaleIdentifyWeight:(double)weight callback:(QNResultCallback)callback;

/// 删除用户秤秤端用户信息
/// @param indexList 用户索引数组
/// @param callback 结果的回调
- (void)deleteScaleUsers:(NSArray <NSNumber *>*)indexList callback:(QNResultCallback)callback;

/// 设置秤端是否测脂
/// @param state 开关状态
/// @param longTerm 是否长期有效（用户秤支持）
/// @param callback 结果的回调
- (void)setFatMeasurementSwitch:(BOOL)state longTerm:(BOOL)longTerm callback:(QNResultCallback)callback;

/// 设置用户秤进入抱婴模式
/// @param state 开关状态
/// @param callback 结果的回调
- (void)setBabyCarryingModelSwitch:(BOOL)state callback:(QNResultCallback)callback;


/// 读取授权设备信息列表
- (NSDictionary *)readAuthDeviceInfoList;

/// 读取SDK授权配置信息
- (NSString *)readSDKConfigurationInfo;

/// 下发OTA固件
- (void)applyOta:(NSData *)otaData callback:(QNResultCallback)callback;
@end

