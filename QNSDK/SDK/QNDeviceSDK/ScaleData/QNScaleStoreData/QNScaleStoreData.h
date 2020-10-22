//
//  QNScaleStoreData.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNUser.h"
#import "QNScaleData.h"

/**
 该类为秤端存储数据类
 
 存储数据通过数据代理(QNScaleDataProtocol)回调 "- (void)onGetStoredScale:(QNBleDevice *)device data:(NSArray <QNScaleStoreData *> *)storedDataList"
 
 
 存储数据的产生的说明:
 当秤在没有连接的情况下测量，秤端会自动将数据存储到秤端，当秤下次连接的时候，SDK会自动读取秤端的所有存储数据(当存储数据读取完毕后，秤端会抹掉所有的存储数据)，只要连接上设备，无论是否开始测量，SDK都会先判断秤中是否有存储数据，如果有数据就会先读取存储数据返回
 存储数据的行为由用户产生，SDK无法控制，当商家可以选择是否处理存储数据（无论商家是处理存储数据，SDK都会读取存储数据并返回，商家只要确定是否需要存储数据即可）
 
 
 存储数据的处理说明：
 1. 不需要处理存储数据的情况:
    如果不需要接受存储数据，可不实现"- (void)onGetStoredScale:(QNBleDevice *)device data:(NSArray <QNScaleStoreData *> *)storedDataList"方法，或者实现方法不做任何的处理
 
 2. 需要处于存储数据的情况:
 
    由于秤存在多人使用的情况，也就产生了一台秤中的存储数据可能是多人的数据，SDK将存储数据的处理交由商家灵活决定该条存储数据属于哪个用户
 
    必须确定该条存储数据属于哪个用户，才能获取存储数据的详细信息（见下面方法的调用说明）
 
 */

@interface QNScaleStoreData : NSObject

/** 储存数据的体重值 */
@property (nonatomic, readonly, assign) double weight;

/** 储存数据的测量时间 */
@property (nonatomic, readonly, strong) NSDate *measureTime;

/** 储存数据所属秤的mac地址 */
@property (nonatomic, readonly, strong) NSString *mac;

/** 数据是否完整 */
@property (nonatomic, readonly, assign) BOOL isDataComplete;

/** 身高(身高体重秤专属) */
@property (nonatomic, assign, readonly) double height;

/** 相关加密字符串 */
@property (nonatomic, readonly, strong) NSString *hmac;

- (instancetype)init NS_UNAVAILABLE;

/**
 设置该存储数据的拥有者

 @param user QNUser
 */
- (BOOL)setUser:(QNUser *)user;

/**
 获取测量数据详情
 
 必须调用 "- (void)setUser:(QNUser *)user" 确定该存储数据的拥有者，才能获取测量数据详情
 
 @return QNScaleData
 */
- (QNScaleData *)generateScaleData;


/**
 构建存储数据对象
 
 用于用轻牛云中获取WiFi蓝牙双模设备的未知测量数据从而构建对象

 @param weight 以KG为单位的体重
 @param measureTime 测量时间
 @param mac 测量的秤mac地址
 @param hmac 相关加密字符串
 @param callback 构建结构的回调
 @return QNScaleStoreData
 */
+ (QNScaleStoreData *)buildStoreDataWithWeight:(double)weight measureTime:(NSDate *)measureTime mac:(NSString *)mac hmac:(NSString *)hmac callBlock:(QNResultCallback)callback;

@end
