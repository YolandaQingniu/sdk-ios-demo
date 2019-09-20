//
//  QNScaleDataProtocol.h
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/31.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNBleDevice.h"
#import "QNScaleData.h"
#import "QNScaleStoreData.h"

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
@end
