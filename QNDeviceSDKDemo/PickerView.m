//
//  PickerView.m
//  QNDeviceSDKDemo
//
//  Created by yolanda on 2018/3/15.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "PickerView.h"
@interface PickerView () <UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSInteger _heightSelectedRow;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *numPickerView;
@property (nonatomic, assign) NSUInteger intervalNum;
@property (nonatomic, assign) NSUInteger minNum;
@property (nonatomic, assign) NSUInteger maxNum;
@end

@implementation PickerView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.datePickerView setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"]];
    [self.datePickerView setTimeZone:[NSTimeZone systemTimeZone]];
}

- (void)initBirthdayPickerViewData {

}

- (void)initHeightPickerViewData {

}

- (void)setType:(PickerViewType)type {
    _type = type;
    if (_type == PickerViewTypeDate) {
        self.numPickerView.hidden = YES;
        self.datePickerView.hidden = NO;
    }else {
        self.numPickerView.showsSelectionIndicator = YES;
        self.numPickerView.delegate = self;
        self.numPickerView.dataSource = self;
        self.datePickerView.hidden = YES;
        self.numPickerView.hidden = NO;
    }
}

- (void)defaultDate:(NSDate *)defaultDate maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate {
    self.datePickerView.date = defaultDate;
    self.datePickerView.maximumDate = maxDate;
    self.datePickerView.minimumDate = minDate;
}


- (void)defaultNum:(NSUInteger)defaultNum maxNum:(NSUInteger)maxNum minNum:(NSUInteger)minNum intervalNum:(NSUInteger)intervalNum {
    self.minNum = minNum;
    self.maxNum = maxNum;
    self.intervalNum = intervalNum;
    [self.numPickerView reloadAllComponents];
    [self.numPickerView selectRow:(defaultNum - minNum) / intervalNum inComponent:0 animated:NO];
}


- (IBAction)confirm:(UIButton *)sender {
    if (_type == PickerViewTypeDate) {
        if ([self.pickerViewDelegate respondsToSelector:@selector(confirmDate:)]) {
            [self.pickerViewDelegate confirmDate:[self.datePickerView date]];
        }
    }else {
        if ([self.pickerViewDelegate respondsToSelector:@selector(confirmNumber:)]) {
            NSInteger index = [self.numPickerView selectedRowInComponent:0];
            [self.pickerViewDelegate confirmNumber:index * self.intervalNum + self.minNum];
        }
    }
    if ([self.pickerViewDelegate respondsToSelector:@selector(dismissPickView)]) {
        [self.pickerViewDelegate dismissPickView];
    }
}

- (IBAction)cancel:(UIButton *)sender {
    if ([self.pickerViewDelegate respondsToSelector:@selector(dismissPickView)]) {
        [self.pickerViewDelegate dismissPickView];
    }
}


#pragma mark - pickerView的代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (self.maxNum - self.minNum) / self.intervalNum + 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld",(long)self.minNum + row * self.intervalNum];
}


-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 80.0f;
}

@end
