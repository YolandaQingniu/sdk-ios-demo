//
//  QNPProtocolData.h
//  QNPScaleModule
//
//  Created by JuneLee on 2019/8/19.
//  协议解析数据回调模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNPProtocolData : NSObject
/** 蓝牙服务的UUID */
@property (nonatomic, strong) NSString *serviceUUID;
/** 特征值的UUID */
@property (nonatomic, strong) NSString *characteristicUUID;
/** 需要写入的数据 */
@property (nonatomic, strong) NSData *data;
@end

NS_ASSUME_NONNULL_END
