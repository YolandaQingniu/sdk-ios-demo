//
//  PickerView.h
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/15.
//  Copyright © 2018年 Yolanda. All rights reserved.
//
//关系类型
typedef enum{
    PickerViewTypeNumber = 0,//数字
    PickerViewTypeDate = 1,//日期
}PickerViewType;



#import <UIKit/UIKit.h>
@class PickerView;

@protocol PickerViewDelegate <NSObject>
@optional
/** 确定生日*/
- (void)confirmDate:(NSDate *)date;
/** 确定身高*/
- (void)confirmNumber:(NSInteger )num;

- (void)dismissPickView;

@end

@interface PickerView : UIView
/** 显示类型*/
@property (nonatomic, assign) PickerViewType type;

@property (nonatomic, weak) id<PickerViewDelegate> pickerViewDelegate;

- (void)defaultDate:(NSDate *)defaultDate maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate;

- (void)defaultNum:(NSUInteger)defaultNum maxNum:(NSUInteger)maxNum minNum:(NSUInteger)minNum intervalNum:(NSUInteger)intervalNum;

@end
