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
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *heightPickerView;
@property (nonatomic, strong) NSMutableArray *heightSource;
@end

@implementation PickerView

+ (instancetype)secPickerView {
    NSString *className = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    return [nib instantiateWithOwner:nil options:nil].firstObject;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initBirthdayPickerViewData];
    [self initHeightPickerViewData];
}

- (void)initBirthdayPickerViewData {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFlags fromDate:now];
    NSInteger year = [components year];
    [components setYear:year - 80];
    [components setMonth:1];
    [components setDay:1];
    NSDate *minDate = [calendar dateFromComponents:components];
    components = [calendar components:unitFlags fromDate:now];
    year = [components year];
    [components setYear:year - 3];
    [components setMonth:1];
    [components setDay:1];
    NSDate *maxDate = [calendar dateFromComponents:components];

    [self.birthdayPickerView setMinimumDate:minDate];
    [self.birthdayPickerView setMaximumDate:maxDate];

    [self.birthdayPickerView setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"]];
    [self.birthdayPickerView setTimeZone:[NSTimeZone systemTimeZone]];
}

- (void)initHeightPickerViewData {
    NSArray *unitArray = [NSArray arrayWithObjects:@"cm",nil];
    NSMutableArray *heightArray = [NSMutableArray array];
    for (int h = 40; h <= 240; h++) {
        [heightArray addObject:[NSString stringWithFormat:@"%d",h]];
    }
    [self.heightSource addObject:heightArray];
    [self.heightSource addObject:unitArray];
    self.heightPickerView.showsSelectionIndicator = YES;
    self.heightPickerView.delegate = self;
    self.heightPickerView.dataSource = self;
}

- (void)setType:(PickerViewType)type {
    _type = type;
    if (_type == PickerViewTypeBirthday) {
        self.heightPickerView.hidden = YES;
        self.birthdayPickerView.hidden = NO;
    }else {
        self.birthdayPickerView.hidden = YES;
        self.heightPickerView.hidden = NO;
    }
}

- (void)setDefaultHeight:(NSInteger)defaultHeight {
    _defaultHeight = defaultHeight;
    [self.heightPickerView selectRow:defaultHeight - 40 inComponent:0 animated:NO];
}

- (void)setDefaultBirthday:(NSDate *)defaultBirthday {
    _defaultBirthday = defaultBirthday;
    [self.birthdayPickerView setDate:defaultBirthday];
}

- (IBAction)confirm:(UIButton *)sender {
    if (_type == PickerViewTypeBirthday) {
        if (self.pickerViewDelegate && [self.pickerViewDelegate respondsToSelector:@selector(confirmBirthday:)]) {
            [self.pickerViewDelegate confirmBirthday:[self.birthdayPickerView date]];
        }
    }else {
        if (self.pickerViewDelegate && [self.pickerViewDelegate respondsToSelector:@selector(confirmHeight:)]) {
            NSInteger height = [[[self.heightSource objectAtIndex:0] objectAtIndex:_heightSelectedRow] integerValue];
            [self.pickerViewDelegate confirmHeight:height];
        }
    }
    self.hidden = YES;
}

- (IBAction)cancel:(UIButton *)sender {
    self.hidden = YES;
}


#pragma mark - pickerView的代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == self.heightPickerView) {
        return self.heightSource.count;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.heightPickerView) {
        return [[self.heightSource objectAtIndex:component] count];
    }
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.heightPickerView) {
        return [[self.heightSource objectAtIndex:component] objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        if (pickerView == self.heightPickerView) {
            _heightSelectedRow = row;
        }
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (pickerView == self.heightPickerView) {
        if (component == 0) {
            return 80.0f;
        }else {
            return 50.0f;
        }
    }
    return 0.0f;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.hidden = YES;
}

- (NSMutableArray *)heightSource {
    if (!_heightSource) {
        _heightSource = [NSMutableArray arrayWithCapacity:1];
    }
    return _heightSource;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale=[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"];
        _dateFormatter.timeZone = [NSTimeZone systemTimeZone];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}
@end
