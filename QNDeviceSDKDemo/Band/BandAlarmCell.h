//
//  BandAlarmCell.h
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2019/1/18.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BandAlarmDelegate <NSObject>

- (void)selectedAlarmHourNum:(QNAlarm *)alarm;
- (void)selectedAlarmMintureNum:(QNAlarm *)alarm;

- (void)updateAlarm:(QNAlarm *)alarm;

- (void)deleteAlarm:(QNAlarm *)alarm;

@end

@interface BandAlarmCell : UITableViewCell

@property (nonatomic, weak) id<BandAlarmDelegate> delegate;

@property (nonatomic, strong) QNAlarm *alarm;

@end

NS_ASSUME_NONNULL_END
