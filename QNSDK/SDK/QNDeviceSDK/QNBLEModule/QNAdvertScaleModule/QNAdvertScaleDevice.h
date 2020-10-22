//
//  QNAdvertScaleDevice.h
//  Pods
//
//  Created by donyau on 2018/12/24.
//

#import <Foundation/Foundation.h>
#import "QNAdvertScaleEnum.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QNAdvertDeviceType) {
    QNAdvertDeviceTypeQNS3 = 0,
    QNAdvertDeviceTypeOKOK,
    QNAdvertDeviceTypeKitchen,
    QNAdvertDeviceTypeQS1,
    QNAdvertDeviceTypeKitchenOneToOn,
};

@interface QNAdvertScaleDevice : NSObject
/** 蓝牙名称 */
@property (nonatomic, strong, nonnull) NSString *bluetoothName;
/** mac地址 */
@property (nonatomic, strong, nonnull) NSString *mac;
/** 信号强度 */
@property (nonatomic, strong, nonnull) NSNumber *RSSI;
/** 内部型号 */
@property (nonatomic, strong, nonnull) NSString *internalModel;
/** 设备UUID */
@property (nonatomic, strong) NSString *UUIDIdentifier;
/** 硬件版本 */
@property (nonatomic, assign) int scaleVer;
/** 软件版本 */
@property (nonatomic, assign) int bleVer;
/** 秤的单位 */
@property (nonatomic, assign) QNAdvertScaleUnitMode unit;
/** 是否支持修改单位 */
@property (nonatomic, assign) BOOL supportUnitChangeFlag;
/** 秤类型 */
@property(nonatomic, assign) QNAdvertDeviceType deviceType;
/** 是否支持测体脂 */
@property(nonatomic, assign) BOOL supportBodyFat;


/** 是否是历史数据 */
@property(nonatomic, assign) BOOL storageFlag;
/** 当前有多少条历史数据 */
@property(nonatomic, assign) int storageNum;
/** 存储数据测量时间 */
@property(nonatomic, assign) long measureTimeStamp;


/** 体重 */
@property(nonatomic, assign) double weight;
/** 测量完成的编码 (非单向厨房秤有效) */
@property(nonatomic, assign) NSInteger count;
/** 是否测量完成 (厨房秤无效)*/
@property(nonatomic, assign) BOOL isComplete;
/** 50电阻的值 (厨房秤无效) */
@property (nonatomic, assign) NSInteger resistance;



/** 是否去皮 (厨房秤专属) */
@property (nonatomic, assign) BOOL isShelling;
/** 是否是负体重 (厨房秤专属) */
@property (nonatomic, assign) BOOL reverseWeightFlag;
/** 是否超载 (厨房秤专属) */
@property (nonatomic, assign) BOOL overWeightFlag;
/** 是否稳定 (厨房秤专属) */
@property (nonatomic, assign) BOOL isStable;
@end

NS_ASSUME_NONNULL_END
