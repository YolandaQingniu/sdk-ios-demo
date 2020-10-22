//
//  QNAdvertScaleEnum.h
//  Pods
//
//  Created by donyau on 2018/12/24.
//

#pragma mark 秤单位设置
typedef NS_ENUM(NSUInteger, QNAdvertScaleUnitMode) {
    QNAdvertScaleUnitKG = 1,
    QNAdvertScaleUnitLB,
    QNAdvertScaleUnitJin,
    QNAdvertScaleUnitST,
    //以下是营养秤单位
    QNAdvertScaleUnitG,
    QNAdvertScaleUnitML,
    QNAdvertScaleUnitOZ,
    QNAdvertScaleUnitLBOZ,
    QNAdvertScaleUnitMilkML
};

#pragma mark 秤端交互过程状态
typedef NS_ENUM(NSUInteger, QNAdvertScaleState) {
    QNAdvertScaleStateUnknow = 0,       //未连接
    QNAdvertScaleStateConnecting,       //正在连接
    QNAdvertScaleStateConnected,        //连接成功
    QNAdvertScaleStateConnectFail,      //连接失败
    QNAdvertScaleStateRealTime,         //实时体重
    QNAdvertScaleStateMeasureComplete,  //测量完成
    QNAdvertScaleStateDisconected,      //设备断开
};

typedef NS_ENUM(NSUInteger, QNAdvertScaleCode) {
    QNAdvertScaleHasDeviceConnectError = 14000,
    QNAdvertScaleUnsupportUnitChange,
    QNAdvertScaleParamsError,
    QNAdvertScaleUnconnectDevice,
    QNAdvertScaleUnSupportConnect,
    QNAdvertScaleConnectOverTime,
    QNAdvertScaleConnected,
};
