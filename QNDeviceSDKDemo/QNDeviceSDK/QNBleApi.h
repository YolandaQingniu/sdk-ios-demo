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
#import "QNDataProtocol.h"
#import "QNUser.h"
#import "QNConfig.h"
#import "QNBandManager.h"

/**
 此SDK为轻牛旗下设备连接工具的静态库，使用时需要向轻牛官方获取 "appId" 否则无法正常使用该SDK
 
 当前版本【 0.4.2 】
 
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
 1. 使用"+ (QNBleApi *)sharedBleApi"初始化SDK
 2. 是否需要系统的蓝牙弹框（此弹框是系统在初始化蓝牙管理的时候会判断蓝牙是否打开，如果蓝牙为关闭状态，系统会自动弹框提示）,如果需要先调用"- (QNConfig *)getConfig"方法获取配置项，然后直接设置对应的属性，如果不需要弹框，直接跳过该步
 2. 使用"- (void)initSdk:(NSString *)appId firstDataFile:(NSString *)dataFile callback:(QNResultCallback)callback"注册SDK
 3. 遵循相应的代理并实现相应的代理方法
 4. 调用"- (QNConfig *)getConfig"方法获取配置项，设置相应的开关，比如返回的设备类型、统一个设备是否返回多次等，该步也可以在第二步的时候一并设置
 4. 调用扫描方法 "- (void)startBleDeviceDiscovery:(QNResultCallback)callback",app处理扫描的设备（比如加入数组实现列表扫描到设备等）
 5. 调用连接方法，连接相应的设备 "- (void)connectDevice:(QNBleDevice *)device user:(QNUser *)user callback:(QNResultCallback)callback"
 6. 代理方法回调测量的各个状态、存储数据、实时体重、测量结果等数据
 7. 测量完毕后，可调用"- (void)disconnectDevice:(QNBleDevice *)device callback:(QNResultCallback)callback"方法，断开设备的连接
 
 */

NS_ASSUME_NONNULL_BEGIN
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
 测量数据的监听，该监听必须实现
 可在 QNDataProtocol.h 中查看详细信息
 
 */
@property (nonatomic, weak) id<QNDataListener> dataListener;

/**
 系统蓝牙状态的监听
 可在 QQNBleStateProtocol.h 中查看详细信息
 
 */
@property (nonatomic, weak) id<QNBleStateListener> bleStateListener;

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
- (void)initSdk:(NSString *)appId firstDataFile:(NSString *)dataFile callback:(nullable QNResultCallback)callback;


/**
 扫描设备
 
 @param callback 结果回调
 */
- (void)startBleDeviceDiscovery:(nullable QNResultCallback)callback;


/**
 从系统中获取已经配对的设备（当接入手环时才启作用，仅接入秤时忽略该方法）
 
 用于获取已经和系统配对的手环
 
 调用该方法时，会自动启动扫描
 
 当手环和系统配对时，无法再从广播数据中获取手环设备，必须从系统配对列表中获取设备，进行连接。因此如果有绑定的手环，后续搜索设备时，必须调用该方法。
 当获取到已经配对的设备后，会通过 “- (void)onDeviceDiscover:(QNBleDevice *)device;”回调设备

 @param mac 已配对的设备的mac
 @param modeId 已配对的设备的modeID
 @param uuidIdentifier 已配对的设备的uuidIdentifier
 @param callback 结果回调
 */
- (void)findPairBandWithMac:(NSString *)mac modeId:(NSString *)modeId uuidIdentifier:(NSString *)uuidIdentifier callback:(nullable QNResultCallback)callback;

/**
 停止扫描
 
 @param callback 结果回调
 */
- (void)stopBleDeviceDiscorvery:(nullable QNResultCallback)callback;


/**
 连接设备
 
 @param device 连接的设备(该设备对象必须是搜索返回的设备对象)
 @param user 用户信息,连接秤时user不可以为nil
 @param callback 结果回调
 */
- (void)connectDevice:(QNBleDevice *)device user:(nullable QNUser *)user callback:(nullable QNResultCallback)callback;


/**
 断开设备的连接
 
 @param device 当前连接的设备
 @param callback 结果回调
 */
- (void)disconnectDevice:(QNBleDevice *)device callback:(nullable QNResultCallback)callback;


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
- (QNUser *)buildUser:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday callback:(nullable QNResultCallback)callback NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请自行构建对象");

/**
 获取手环管理类

 @return QNBandManager
 */
- (QNBandManager *)getBandManager;
@end
NS_ASSUME_NONNULL_END
