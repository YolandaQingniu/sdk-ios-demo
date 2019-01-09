//
//  BandUserVC.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandUserVC.h"
#import "PickerView.h"

typedef NS_ENUM(NSUInteger, QNUserPickerType) {
    QNUserPickerStep = 0,
    QNUserPickerWeight,
    QNUserPickerHeight,
};

@interface BandUserVC ()<PickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIButton *stepGoalBtn;
@property (weak, nonatomic) IBOutlet UIButton *weightBtn;
@property (weak, nonatomic) IBOutlet UIButton *heightBtn;
@property (weak, nonatomic) IBOutlet UIButton *birthdayBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegControl;
@property (nonatomic, strong) PickerView *pickerView;
@property (nonatomic, assign) QNUserPickerType pickType;
@property (nonatomic, strong) QNUser *user;
@end

@implementation BandUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44 + 10;
    
    self.user = [[QNUser alloc] init];
    self.user.userId = @"123456";
    self.user.height = 170;
    self.user.weight = 65;
    self.user.gender = @"female";
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 1990;
    dateComponents.month = 1;
    dateComponents.day = 1;
    self.user.birthday = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
 
    [self update];
}

- (void)update {
    [self.stepGoalBtn setTitle:[NSString stringWithFormat:@"%d",[BandMessage sharedBandMessage].sportGoal] forState:UIControlStateNormal];

    [self.weightBtn setTitle:[NSString stringWithFormat:@"%ld",(long)self.user.weight] forState:UIControlStateNormal];
    [self.heightBtn setTitle:[NSString stringWithFormat:@"%ld",(long)self.user.height] forState:UIControlStateNormal];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    [self.birthdayBtn setTitle:[dateFormatter stringFromDate:self.user.birthday] forState:UIControlStateNormal];
    
    if ([self.user.gender isEqualToString:@"male"]) {
        self.genderSegControl.selectedSegmentIndex = 1;
    }else {
        self.genderSegControl.selectedSegmentIndex = 0;
    }
}

- (IBAction)stepGoalSelected:(UIButton *)sender {
    self.pickType = QNUserPickerStep;
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeNumber;
    [pickerView defaultNum:[BandMessage sharedBandMessage].sportGoal maxNum:80000 minNum:0 intervalNum:100];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (IBAction)weightSelected:(UIButton *)sender {
    self.pickType = QNUserPickerWeight;
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeNumber;
    [pickerView defaultNum:self.user.weight maxNum:180 minNum:0 intervalNum:1];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (IBAction)heightSelected:(UIButton *)sender {
    self.pickType = QNUserPickerHeight;
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeNumber;
    [pickerView defaultNum:self.user.height maxNum:240 minNum:40 intervalNum:1];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (IBAction)birthdaySelected:(UIButton *)sender {
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
    
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeDate;
    [pickerView defaultDate:self.user.birthday maxDate:maxDate minDate:minDate];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (IBAction)genderSelected:(UISegmentedControl *)sender {
    [self syncUser];
}

- (void)confirmDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    [self.birthdayBtn setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
    [self syncUser];
}

- (void)confirmNumber:(NSInteger)num {
    if (self.pickType == QNUserPickerStep) {
        [self.stepGoalBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
        [self syncGoal];
    }else if (self.pickType == QNUserPickerHeight) {
        [self.heightBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
        [self syncUser];
    }else {
        [self.weightBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
        [self syncUser];
    }
}

- (void)dismissPickView {
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}


- (void)syncGoal {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步...";
    int goal = [self.stepGoalBtn.titleLabel.text intValue];
    [[[QNBleApi sharedBleApi] getBandManager] syncGoal:goal callback:^(NSError *error) {
        if (error) {
            hud.label.text = @"同步失败...";
            [self update];
        }else {
            hud.label.text = @"同步成功";
            [BandMessage sharedBandMessage].sportGoal = goal;
        }
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (void)syncUser {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    QNUser *user = [[QNUser alloc] init];
    user.userId = @"123456";
    user.height = [self.heightBtn.titleLabel.text intValue];
    user.weight = [self.weightBtn.titleLabel.text doubleValue];
    user.gender = self.genderSegControl.selectedSegmentIndex == 1 ? @"male" : @"female";
    user.birthday = [dateFormatter dateFromString:self.birthdayBtn.titleLabel.text];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步...";
    [[[QNBleApi sharedBleApi] getBandManager] syncUser:user callback:^(NSError *error) {
        if (error) {
            hud.label.text = @"同步失败...";
            [self update];
        }else {
            self.user = user;
            hud.label.text = @"同步成功";
        }
        [hud hideAnimated:YES afterDelay:1];
    }];
}

@end
