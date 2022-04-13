//
//  QNScaleDataProtocol.h
//  QNDeviceSDKDemo
//
//  Created by com.qn.device on 2018/3/31.
//  Copyright © 2018年 com.qn.device. All rights reserved.
//

#import "QNBleDevice.h"
#import "QNScaleData.h"
#import "QNScaleStoreData.h"

typedef NS_ENUM(NSInteger, QNScaleEvent) {
    QNScaleEventWiFiBleStartNetwork = 1, //WiFi蓝牙双模设备开始配网
    QNScaleEventWiFiBleNetworkSuccess = 2, //WiFi蓝牙双模设备联网成功
    QNScaleEventWiFiBleNetworkFail = 3, //WiFi蓝牙双模设备联网失败
    QNScaleEventRegistUserSuccess = 4, //用户秤专属，注册用户成功
    QNScaleEventRegistUserFail = 5, //用户秤专属，注册用户失败
    QNScaleEventVisitUserSuccess = 6, //用户秤专属，访问用户成功
    QNScaleEventVisitUserFail = 7, //用户秤专属，访问用户失败
    QNScaleEventDeleteUserSuccess = 8, //用户秤专属，删除用户成功
    QNScaleEventDeleteUserFail = 9, //用户秤专属，删除用户失败
    QNScaleEventSyncUserInfoSuccess = 10, //用户秤专属，同步用户信息成功
    QNScaleEventSyncUserInfoFail = 11, //用户秤专属，同步用户信息失败
    QNScaleEventUpdateIdentifyWeightSuccess = 12, //用户秤专属，更新用户识别体重成功
    QNScaleEventUpdateIdentifyWeightFail = 13, //用户秤专属，更新用户识别体重失败
    QNScaleEventUpdateScaleConfigSuccess = 14, //用户秤专属，更新秤端设置成功
    QNScaleEventUpdateScaleConfigFail = 15, //用户秤专属，更新秤端设置失败
};

@protocol QNScaleDataListener <NSObject>

/**
 实时数据的监听
 
 @param device QNBleDevice
 @param weight 实时体重
 */
- (void)onGetUnsteadyWeight:(QNBleDevice *)device weight:(double)weight;

/**
 稳定数据的监听
 
 @param device QNBleDevice
 @param scaleData 数据结果
 */
- (void)onGetScaleData:(QNBleDevice *)device data:(QNScaleData *)scaleData;


/**
 存储数据的监听
 
 @param device QNBleDevice
 @param storedDataList 结果数组
 */
- (void)onGetStoredScale:(QNBleDevice *)device data:(NSArray <QNScaleStoreData *> *)storedDataList;

/**
 充电款电量的监听

 @param electric electric
 @param device QNBleDevice
 */
- (void)onGetElectric:(NSUInteger)electric device:(QNBleDevice *)device;;

/**
 秤连接或测量状态变化
 
 @param device QNBleDevice
 @param state 状态
 */
- (void)onScaleStateChange:(QNBleDevice *)device scaleState:(QNScaleState)state;

/**
 秤事件的回调
 
 @param device QNBleDevice
 @param scaleEvent 秤事件
 */
- (void)onScaleEventChange:(QNBleDevice *)device scaleEvent:(QNScaleEvent)scaleEvent;

@optional
/**
 普通蓝牙称读取设备SN码
 
 @param device QNBleDevice
 @param sn sn
 */
- (void)readSnComplete:(QNBleDevice *)device sn:(NSString *)sn;
@end
