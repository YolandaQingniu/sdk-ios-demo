//
//  PickerView.h
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/15.
//  Copyright © 2018年 Yolanda. All rights reserved.
//
//关系类型
typedef enum{
    PickerViewTypeHeight = 0,//身高
    PickerViewTypeBirthday= 1,//生日
}PickerViewType;



#import <UIKit/UIKit.h>
@class PickerView;

@protocol PickerViewDelegate <NSObject>
@optional
/** 确定生日*/
- (void)confirmBirthday:(NSDate *)birthday;
/** 确定身高*/
- (void)confirmHeight:(NSInteger )height;

@end

@interface PickerView : UIView
/** 显示类型*/
@property (nonatomic, assign) PickerViewType type;

/** 默认显示生日*/
@property (nonatomic, strong) NSDate *defaultBirthday;

/** 默认显示高度*/
@property (nonatomic, assign) NSInteger defaultHeight;

@property (nonatomic, weak) id<PickerViewDelegate> pickerViewDelegate;

/** 时间转化格式*/
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

+ (instancetype)secPickerView;

@end
