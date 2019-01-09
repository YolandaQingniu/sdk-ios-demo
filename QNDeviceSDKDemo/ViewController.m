//
//  ViewController.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "ViewController.h"
#import "PickerView.h"
#import "DetectionViewController.h"
#import "BandVC.h"

@interface ViewController ()<PickerViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userIdTF;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *bandBtn;

@property (weak, nonatomic) IBOutlet UIButton *everyBtn;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;

@property (weak, nonatomic) IBOutlet UIButton *jinBtn;
@property (weak, nonatomic) IBOutlet UIButton *stBtn;
@property (weak, nonatomic) IBOutlet UIButton *kgBtn;
@property (weak, nonatomic) IBOutlet UIButton *lbBtn;

@property (nonatomic, weak) PickerView *pickerView;
@property (nonatomic, strong) QNBleApi *bleApi;
@property (nonatomic, strong) QNConfig *config;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) NSDate *birthdayDate;

@end

@implementation ViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.bleApi = [QNBleApi sharedBleApi];
    self.config = [self.bleApi getConfig];
    
    [self setDefaultValue];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([BandMessage sharedBandMessage].mac.length == 0) {
        self.bandBtn.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        [self.bandBtn setTitle:@"未绑定手环" forState:UIControlStateNormal];
        [self.bandBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.bandBtn.enabled = NO;
    }else {
        self.bandBtn.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        [self.bandBtn setTitle:@"已绑定手环" forState:UIControlStateNormal];
        [self.bandBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.bandBtn.enabled = YES;
    }
}

- (void)setDefaultValue {
    self.userIdTF.text = @"123456";
    self.maleBtn.selected = YES;
    self.heightLabel.text = @"170cm";
    self.birthdayLabel.text = @"1990-01-01";
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 1990;
    dateComponents.month = 1;
    dateComponents.day = 1;
    self.birthdayDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    [self selectUnit:self.config.unit];

    if (self.config.allowDuplicates) {
        [self selectEveryBtn:self.everyBtn];
    }else {
        [self selectFirstBtn:self.firstBtn];
    }
}

- (IBAction)turnToBandVC:(UIButton *)sender {
    
    int height = [[self.heightLabel.text stringByReplacingOccurrencesOfString:@"cm" withString:@""] intValue];
    QNUser *user = [[QNUser alloc] init];
    user.userId = self.userIdTF.text;
    user.height = height;
    user.birthday = self.birthdayDate;
    user.gender = self.femaleBtn.selected ? @"female" : @"male";
    user.weight = 60;//此处应为用户的实际体重值，该值会影响健康的相关数据
    
    [BandMessage sharedBandMessage].user = user;
    
    BandVC *bandVc = [[BandVC alloc] init];
    [self.navigationController pushViewController:bandVc animated:YES];
}

#pragma mark - 确认用户ID
#pragma mark 点击键盘Return键
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 选择身高
- (IBAction)selectHeight:(UITapGestureRecognizer *)sender {
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeNumber;
    [pickerView defaultNum:[[self.heightLabel.text stringByReplacingOccurrencesOfString:@"cm" withString:@""] intValue] maxNum:240 minNum:40 intervalNum:1];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (void)confirmDate:(NSDate *)date {
    self.birthdayDate = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.birthdayLabel.text = [dateFormatter stringFromDate:self.birthdayDate];
}

- (void)confirmNumber:(NSInteger)num {
    self.heightLabel.text = [NSString stringWithFormat:@"%ldcm",(long)num];
}


- (void)dismissPickView {
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

#pragma mark 选择生日
- (IBAction)selectBirthday:(UITapGestureRecognizer *)sender {
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
    [pickerView defaultDate:self.birthdayDate maxDate:maxDate minDate:minDate];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

#pragma mark - 选中性别
#pragma mark 选中性别-女
- (IBAction)selectFemaleBtn:(UIButton *)sender {
    if (sender.isSelected) return;
    sender.selected = YES;
    self.maleBtn.selected = NO;
}

#pragma mark 选中性别-男
- (IBAction)selectMaleBtn:(UIButton *)sender {
    if (sender.isSelected) return;
    sender.selected = YES;
    self.femaleBtn.selected = NO;
}

#pragma mark - 选中扫描模式-每次
- (IBAction)selectEveryBtn:(UIButton *)sender {
    if (sender.isSelected) return;
    sender.selected = YES;
    self.firstBtn.selected = NO;
    self.config.allowDuplicates = YES;
}

#pragma mark 选中扫描模式-首次
- (IBAction)selectFirstBtn:(UIButton *)sender {
    if (sender.isSelected) return;
    sender.selected = YES;
    self.everyBtn.selected = NO;
    self.config.allowDuplicates = NO;
}

#pragma mark - 选中称量单位-斤
- (IBAction)selectJinBtn:(UIButton *)sender {
    [self selectUnit:QNUnitJIN];
}

#pragma mark 选中称量单位-st
- (IBAction)selectStBtn:(UIButton *)sender {
    [self selectUnit:QNUnitST];
}

#pragma mark 选中称量单位-kg
- (IBAction)selectKgBtn:(UIButton *)sender {
    [self selectUnit:QNUnitKG];
}

#pragma mark 选中称量单位-lb
- (IBAction)selectLbBtn:(UIButton *)sender {
    [self selectUnit:QNUnitLB];
}

- (void)selectUnit:(QNUnit)unit {
    self.config.unit = unit;
    switch (unit) {
            case QNUnitLB:
            self.kgBtn.selected = NO;
            self.jinBtn.selected = NO;
            self.stBtn.selected = NO;
            self.lbBtn.selected = YES;
            break;
            
            case QNUnitJIN:
            self.kgBtn.selected = NO;
            self.jinBtn.selected = YES;
            self.stBtn.selected = NO;
            self.lbBtn.selected = NO;
            break;
            
            case QNUnitST:
            self.kgBtn.selected = NO;
            self.jinBtn.selected = NO;
            self.stBtn.selected = YES;
            self.lbBtn.selected = NO;
            break;
            
        default:
            self.kgBtn.selected = YES;
            self.jinBtn.selected = NO;
            self.stBtn.selected = NO;
            self.lbBtn.selected = NO;
            break;
    }
}


#pragma mark - 点击确认跳转扫描
- (IBAction)clickConfirm:(UIButton *)sender {
    int height = [[self.heightLabel.text stringByReplacingOccurrencesOfString:@"cm" withString:@""] intValue];
    QNUser *user = [[QNUser alloc] init];
    user.userId = self.userIdTF.text;
    user.height = height;
    user.birthday = self.birthdayDate;
    user.gender = self.femaleBtn.selected ? @"female" : @"male";

    DetectionViewController *detectionVC = [[DetectionViewController alloc] init];
    detectionVC.user = user;
    detectionVC.config = self.config;
    [self.navigationController pushViewController:detectionVC animated:YES];
}

@end
