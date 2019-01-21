//
//  BLETool.h
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/8.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol BLEToolDelegate <NSObject>
@optional

- (void)qnBleStateUpdate:(QNBLEState)bleState;

- (void)qnDiscoverDevice:(QNBleDevice *)device;

- (void)qnScaleReceiveRealTimeWeight:(double)weight device:(QNBleDevice *)device;

- (void)qnScaleReceiveResultData:(QNScaleData *)scaleData device:(QNBleDevice *)device;

- (void)qnScaleStoredDatas:(NSArray<QNScaleStoreData *> *)storedDataList device:(QNBleDevice *)device;

- (void)qnScaleElectric:(NSUInteger)electric device:(QNBleDevice *)device;

- (void)qnDeviceStateChange:(QNScaleState)state device:(QNBleDevice *)device;

- (void)qnBandTakePhotosWithDevice:(QNBleDevice *)device;

- (void)qnBandFindWithDevice:(QNBleDevice *)device;

@end

@interface BLETool : NSObject

+ (BLETool *)sharedBLETool;

@property (nullable, nonatomic, weak) id<BLEToolDelegate> delegate;

@property (nullable, nonatomic, strong) QNBleDevice *bandDevice;

@property (nullable, nonatomic, strong) QNBleDevice *scaleDevice;

@property (nullable, nonatomic, strong) QNBandManager *bandManager;

- (void)connectDevice:(QNBleDevice *)device user:(nullable QNUser *)user;

- (void)disconnectScale;

- (void)disconnectBand;

- (void)scanDevice;

- (void)stopScan;

- (double)convertWeightWithTargetUnit:(double)kgWeight unit:(QNUnit)unit;

@end

NS_ASSUME_NONNULL_END
