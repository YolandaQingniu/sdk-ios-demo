//
//  QNHeightScaleEnum.h
//  Pods
//
//  Created by qiudongquan on 2020/6/10.
//

#ifndef QNHeightScaleEnum_h
#define QNHeightScaleEnum_h

#pragma mark 秤单位设置
typedef NS_ENUM(NSUInteger, QNHeightScaleUnitMode) {
    QNHeightScaleKG  = 0,
    QNHeightScaleLB  = 1,
    QNHeightScaleJin = 2, //若秤不支持斤的显示，则显示KG
    QNHeightScaleST  = 3, //若秤不支持ST的显示，则显示ST
};

#pragma mark 秤端交互过程状态
typedef NS_ENUM(NSUInteger, QNHeightScaleState) {
    QNHeightScaleUnknow = 0,              //未连接
    QNHeightScaleConnecting,              //正在连接
    QNHeightScaleConnectFail,             //连接失败
    QNHeightScaleConnected,               //连接成功
    QNHeightScaleDiscoverServices,        //发现服务
    QNHeightScaleDiscoverCharacteristics, //发现特征
    QNHeightScaleReadyWeight,             //实时体重
    QNHeightScaleReadyHeight,             //实时身高
    QNHeightScaleBodyFat,                 //测量阻抗
    QNHeightScaleMeasureComplete,         //测量完成
    QNHeightScaleDisconected,             //设备断开
};

typedef NS_ENUM(NSUInteger, QNHeightScaleCode) {
    QNHeightScaleDiscoverServiceError = 12001,
    QNHeightScaleDiscoverCharacteristicsError,
    QNHeightScaleUnconnectedDeviceError,     //未连接设备
    QNHeightScaleHasDeviceConnectError,      //已有设备连接
    QNHeightScaleScaleDeviceParamsError,     //连接对象参数有误
    QNHeightScaleUserParamsError,            //用户参数有误
    QNHeightScaleWifiConfigParamsError,      //wifi参数有误
    QNHeightScaleHardwareParamsError,        //硬件参数出错
};

#endif /* QNHeightScaleEnum */
