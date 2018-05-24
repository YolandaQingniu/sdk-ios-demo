# 轻牛蓝牙iOS SDK 

SDK的运行需要appid以及配置文件，商家在接入时可先使用轻牛提供的测试appid和测试配置文件，正式发布时必须向轻牛官方获取正式appid和配置文件

## SDK文件说明
### 统一引入
#### QNDeviceSDK.h
该.h文件包含所有的头文件信息

### 操作
#### QNBleApi.h
该类为SDK的主要工作类，提供SDK的各种方法的操作

### 配置
#### QNConfig.h
该类为SDK的设置类，包括扫描的配置、连接的配置、秤单位显示等配置

### 代理
#### QNBleConnectionChangeProtocol.h
该协议主要提供秤在使用过程中各种状态的回调
#### QNBleDeviceDiscoveryProtocol.h
该协议主要提供扫描秤时的回调，保存app开启停止扫描的回调
#### QNBleStateProtocol.h
该协议主要提供系统蓝牙状态的回调
#### QNDataProtocol.h
该协议主要提供测量数的回调，包括实时体重、测量结果、存储数据


### 数据
#### QNBleDevice.h
该类主要显示设备的信息

#### QNScaleData.h
该类主要提供测量结果数据信息

#### QNScaleStoreData.h
该类主要提供存储数据信息

#### QNUser.h
该类主要有app向SDK提供用户信息

#### QNScaleItemData
该类主要显示每个指标的详细数据信息

### 错误信息
#### QNErrorCode.h
该头文件展示了SDK中所有的错误信息类型


## SDK调用步骤

### 1. 工程的配置

- 在Info.plist中有对 "Privacy - Bluetooth Peripheral Usage Description" 键 进行蓝牙的使用说明
- 引入SDK路径 【TARGETS】-> 【Build Setting】->【Search Paths】->【LibrarySearch Paths】中添加SDK路径
- 配置链接器 【TARGETS】-> 【Build Setting】-> 【Linking】-> 【Other Linker Flags】中添加 `-ObjC`、`-all_load`、`-force_load [SDK路径]` 其中之一

### 2. 方法的调用步骤

1. 初始化SDK `+ (QNBleApi *)sharedBleApi;`
2. 配置系统蓝牙弹框提示开关
	+ 获取配置信息 `- (QNConfig *)getConfig;`
	+ 设置是否需要弹框的开关值 `showPowerAlertKey`
3. 注册SDK `- (void)initSdk:(NSString *)appId firstDataFile:(NSString *)dataFile callback:(QNResultCallback)callback;`
4. 遵守和实现所需的代理
5. 设置扫描配置 （也可以在步骤2中设置）
 	+ 获取配置信息 `- (QNConfig *)getConfig;`
	+ 设置是否只扫描开机的秤 `onlyScreenOn`
	+ 设置扫描到秤时是否返回多次 `allowDuplicates`
	+ 设置扫描的时间 `duration`
6. 扫描设备 `- (void)startBleDeviceDiscovery:(QNResultCallback)callback;`
7. 设置连接的配置 （也可以在步骤2或者步骤5中设置）
	+ 获取配置信息 `- (QNConfig *)getConfig;`
	+ 设置秤端显示的单位 `unit`
8. 构建连接秤的用户对象 `- (QNUser *)buildUser:(NSString *)userId height:(int)height gender:(NSString *)gender birthday:(NSDate *)birthday callback:(QNResultCallback)callback`
9. 连接设备 `- (void)connectDevice:(QNBleDevice *)device user:(QNUser *)user callback:(QNResultCallback)callback;`



## 注意事项
- SDK适配8.0及以上系统
- iOS10.0及以上系统必须Info.plist中配置蓝牙的使用数据，否则无法使用系统的蓝牙功能
- 必须为SDK配置链接器，否则SDK无法正常运行
